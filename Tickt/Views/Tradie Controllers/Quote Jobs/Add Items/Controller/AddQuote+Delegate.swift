//
//  AddQuote+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 08/09/21.
//

extension AddQuoteVC: AddQuoteDelegate {
    
    func addItem(item: ItemDetails) {
        addItemToList(item: item)
    }
    
    func deleteItem() {
        deleteItemFromList(indexPath: editedIndexPath)
    }
    
    func updateItem(item: ItemDetails) {
        updateEditedItem(item: item)
    }
    
    func quoteSubmitted() {
        if isInvite {
            showSuccessScreen()
            delegate?.didQuoteAccepted()
        } else {
            showSuccessScreen()
        }
    }
    
    func showSuccessScreen() {
        let successVC = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        successVC.screenType = .quoteSubmited
        successVC.builderName = jobDetail?.postedBy?.builderName ?? ""
        push(vc: successVC)
    }
    
    func didGetQuoteDetail(items: [ItemDetails]) {
        quoteTableView.delegate = self
        quoteTableView.dataSource = self
        currentItemNumber = items.count + 1
        itemList = items
        var count = 1
        self.itemList.indices.forEach { index in
            self.itemList[index].itemNumber = count
            count += 1
        }
        enableQuoteButton()
        mainQueue { [weak self] in
            self?.quoteTableView.reloadData()
        }
    }
}

extension AddQuoteVC: EditQuoteDelegate {
    
    func didItemDeleted(indexPath: IndexPath) {
        deleteItemFromList(indexPath: indexPath)
    }
        
    func didPressSubmitQuoteFromEdit() {
        pop()
    }
    
    func didQuoteEdited(itemList: [ItemDetails], indexPath: IndexPath) {
        isEditItem = false
        self.itemList = itemList
        mainQueue { [weak self] in
            self?.quoteTableView.reloadData()
        }
        delay(time: 0.01) { [weak self] in
            self?.quoteTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        updateTotalPriceCell()
    }
}
