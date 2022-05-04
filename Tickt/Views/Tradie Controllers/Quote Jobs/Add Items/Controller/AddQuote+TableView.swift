//
//  AddQuote+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 08/09/21.
//

import UIKit

extension AddQuoteVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .addItem:
            return 1
        case .itemList:
            if isEditItem {
                return 0
            } else {
                return itemList.count
            }
        case .totalPrice:
            return itemList.count == 0 ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .addItem:
            let cell = tableView.dequeueCell(with: AddItemCell.self)
            cell.currentItemNumber = currentItemNumber
            cell.isLastItem = isLastItem
            cell.isEditItem = isEditItem            
            cell.addButtonAction = { [weak self] itemdetail in
                self?.newItemAdded(itemDetail: itemdetail)
            }
            cell.deleteButtonAction = { [weak self] in
                self?.itemDeleted()
            }
            return cell
        case .itemList:
            let cell = tableView.dequeueCell(with: ItemListCell.self)
            cell.editButton.isHidden = false
            cell.itemDetail = itemList[indexPath.row]
            cell.editButtonAction = { [weak self] in                
                self?.editItem(indexPath: indexPath)
            }
            return cell
        case .totalPrice:
            let cell = tableView.dequeueCell(with: TotalPriceCell.self)
            let amount = itemList.map({$0.totalAmount}).reduce(0, +)
            let formattedAmount = String.getString(amount).commaSeprated()
            cell.totalPriceLabel.text = "Total cost: \(formattedAmount)"
            return cell
        }
    }
    
    func editItem(indexPath: IndexPath) {
        let vc = AddQuoteVC.instantiate(fromAppStoryboard: .quotes)
        vc.isEditItem = true
        vc.editDelegate = self
        vc.currentItemNumber = indexPath.row + 1
        vc.itemList = itemList
        vc.editedIndexPath = indexPath
        vc.isInvite = isInvite
        vc.isResubmitQuote = isResubmitQuote
        vc.jobDetail = jobDetail
        push(vc: vc)
    }
    
    func newItemAdded(itemDetail: ItemDetails) {
        if isEditItem {
            if isResubmitQuote {
                AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "This quote will be sent to builder", alertMessage: "Are you sure you want to update quote?", acceptButtonTitle: "Yes", declineButtonTitle: "No") { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.updateItem(item: itemDetail)
                } dismissCompletion: { }
            } else {
                updateEditedItem(item: itemDetail)
            }
        } else {
            if !itemList.map({$0.itemNumber}).contains(itemDetail.itemNumber) {
                if isResubmitQuote {
                    AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "This quote will be sent to builder", alertMessage: "Are you sure you want to update quote?", acceptButtonTitle: "Yes", declineButtonTitle: "No") { [weak self] in
                        guard let self = self else { return }
                        let quoteId = self.itemList.first?.quoteId ?? ""
                        self.viewModel.addItem(item: itemDetail, quoteId: quoteId)
                    } dismissCompletion: { }
                } else {
                    addItemToList(item: itemDetail)
                }
            } else {
                CommonFunctions.showToastWithMessage("Item Number should be unique.")
            }
        }
        enableQuoteButton()
    }
        
    func itemDeleted() {
        if isResubmitQuote {
            viewModel.deleteItem(itemId: itemList[editedIndexPath.row].id)
        } else {
            deleteItemFromList(indexPath: editedIndexPath)
        }
    }
    
    func addItemToList(item: ItemDetails) {
        currentItemNumber += 1
        itemList.append(item)
        let indexPath = IndexPath(row: itemList.count - 1, section: 0)
        let alreadyPresent = quoteTableView.numberOfRows(inSection: 2) == 1
        quoteTableView.beginUpdates()
        quoteTableView.insertRows(at: [indexPath], with: .automatic)
        if !alreadyPresent { //Check If Total Price is already present
            quoteTableView.insertRows(at: [IndexPath(row: 0, section: 2)], with: .none)
        }
        quoteTableView.endUpdates()
        delay(time: 0.01) { [weak self] in
            self?.quoteTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        updateAddItemCell()
        updateTotalPriceCell()
    }
    
    func updateEditedItem(item: ItemDetails) {
        itemList[editedIndexPath.row] = item
        if isEditItem {
            editDelegate?.didQuoteEdited(itemList: itemList, indexPath: editedIndexPath)
            pop()
        } else {
            isEditItem = false
            if let cell = quoteTableView.cellForRow(at: editedIndexPath) as? ItemListCell {
                cell.itemDetail = item
            }
            delay(time: 0.01) { [weak self] in
                self?.quoteTableView.scrollToRow(at: self?.editedIndexPath ?? IndexPath(row: 0, section: 0), at: .bottom, animated: false)
            }
            updateAddItemCell()
            updateTotalPriceCell()
        }
    }
        
    func deleteItemFromList(indexPath: IndexPath) {
        if isEditItem {
            editDelegate?.didItemDeleted(indexPath: indexPath)
            pop()
        } else {
            currentItemNumber -= 1
            isEditItem = false
            itemList.remove(at: indexPath.row)
            var indexPaths: [IndexPath] = []
            itemList.indices.forEach { index in
                if index >= indexPath.row {
                    itemList[index].itemNumber -= 1
                    indexPaths.append(IndexPath(row: index, section: 0))
                }
            }
            let isDeleteTotalPriceCell = itemList.count == 0
            quoteTableView.beginUpdates()
            quoteTableView.deleteRows(at: [indexPath], with: .none)
            if isDeleteTotalPriceCell { //Check If Total Price is  present
                quoteTableView.deleteRows(at: [IndexPath(row: 0, section: 2)], with: .none)
            }
            quoteTableView.endUpdates()
            if !indexPaths.isEmpty {
                delay(time: 0.1) { [weak self] in
                    self?.quoteTableView.reloadRows(at: indexPaths, with: .none)
                }
            }
            enableQuoteButton()
            updateAddItemCell()
            updateTotalPriceCell()
        }
    }

    func updateAddItemCell() {
        if let cell = quoteTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddItemCell {
            cell.currentItemNumber = currentItemNumber
            cell.clearForm()
        }
    }
    
    func updateTotalPriceCell() {
        if let cell = quoteTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? TotalPriceCell {
            let amount = itemList.map({$0.totalAmount}).reduce(0, +)
            let formattedAmount = String.getString(amount).commaSeprated()
            cell.totalPriceLabel.text = "Total cost: \(formattedAmount)"
        }
    }
    
    func enableQuoteButton() {
        if itemList.count > 0 || isEditItem {
            submitButton.isUserInteractionEnabled = true
            submitButton.backgroundColor = AppColors.themeYellow
        } else {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = AppColors.appGrey
        }
    }
}
