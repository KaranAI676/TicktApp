//
//  FilterVC+TableView.swift
//  Tickt
//
//  Created by Admin on 05/05/21.
//

import UIKit

extension FilterVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellArray[section] {
        case .category, .bottomButton, .budget, .rangeSlider:
            return 1
        case .jobType:
            if kUserDefaults.isTradie() {
                return filterData.jobType.result.resultData.isEmpty ? 0 : 1
            }
            return 0
        case .sortBy:
            return sortByArray.count
        case .specialisation:
            if let index = selectedIndexOfTrade ,
               let model = tradeModel?.result?.trade?[index].specialisations,
               model.count > 0 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellArray[indexPath.section] {
        case .category:
            let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
            cell.populateUI(title: "Categories", dataArray: self.tradeModel?.result?.trade)
            ///
            cell.modelUpdateClosure = { [weak self] (bool, index) in
                guard let self = self else { return }
                self.selectedIndexOfTrade = bool ? index : nil
                for i in 0..<((self.tradeModel?.result?.trade?.count ?? 0)) {
                    self.tradeModel?.result?.trade?[i].isSelected = false
                }
                self.tradeModel?.result?.trade?[index].isSelected = bool
                tableView.reloadData()
            }
            return cell
        case .jobType:
            let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
            /// Populate UI
            cell.populateUI(title: "Job type", dataArray: filterData.jobType.result.resultData, cellType: .jobType)
            cell.extraCellSize = CGSize(width: (36 + 6 + 12 + 15), height: 45)
            cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 14.0)
            cell.stackView.spacing = 8
            cell.layoutIfNeeded()
            
            /// Update Model for selection and deselection
            cell.didSelectClosure = { [weak self] (_, jobTypeIndex, bool) in
                guard let self = self else { return }
                self.filterData.jobType.result.resultData[jobTypeIndex.row].isSelected = bool
                tableView.reloadData()
            }
            return cell
        case .specialisation:
            let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
            
            /// Populate UI
            cell.extraCellSize = CGSize(width: 16, height: 32)
            cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
            cell.stackView.spacing = 15
            if let index = selectedIndexOfTrade, let model = self.tradeModel?.result?.trade?[index].specialisations {
                cell.populateUI(title: "Specialisation", dataArray: model, cellType: .specialisation)
            } else {
                self.selectedIndexOfTrade = nil
                cell.specialisationModel.removeAll()
                cell.collectionViewOutlet.reloadData()
            }
            cell.layoutIfNeeded()
            
            /// Update Model for selection and deselection
            cell.didSelectClosure = { [weak self] (_, specialisationIndex, bool) in
                guard let self = self else { return }
                if let tradeIndex = self.selectedIndexOfTrade {
                    if specialisationIndex.row == 0 {
                        for index in 0..<(self.tradeModel?.result?.trade?[tradeIndex].specialisations?.count ?? 0) {
                            self.tradeModel?.result?.trade?[tradeIndex].specialisations?[index].isSelected = bool
                        }
                    } else {
                        if bool {
                            self.tradeModel?.result?.trade?[tradeIndex].specialisations?[specialisationIndex.row].isSelected = true
                            if let selectedSpecializations = self.tradeModel?.result?.trade?[tradeIndex].specialisations?.filter({($0.isSelected ?? false)}) {
                                if selectedSpecializations.count == (self.tradeModel?.result?.trade?[tradeIndex].specialisations?.count ?? 0) - 1 {
                                    self.tradeModel?.result?.trade?[tradeIndex].specialisations?[0].isSelected = true
                                }
                            }
                        } else { //Remove "all" case
                            self.tradeModel?.result?.trade?[tradeIndex].specialisations?[0].isSelected = false
                            self.tradeModel?.result?.trade?[tradeIndex].specialisations?[specialisationIndex.row].isSelected = false
                        }
                    }
                    tableView.reloadData()
                }
            }
            return cell
        case .sortBy:
            let cell = tableView.dequeueCell(with: CommonRadioButtonTableCell.self)
            cell.tableView = tableView
            if self.sortBy == nil {
                cell.radioButtonOutlet.isSelected = false
            } else {
                cell.radioButtonOutlet.isSelected = (self.sortBy == sortByArray[indexPath.row])
            }
            cell.populateUI(title: (indexPath.row == 0) ? "Sort By" : nil, name: sortByArray[indexPath.row].rawValue)
            ///
            cell.buttonClosure = { [weak self] (index) in
                guard let self = self else { return }                
                if self.sortBy != self.sortByArray[index.row] {
                    self.sortBy = self.sortByArray[index.row]
                }
                tableView.reloadData()
            }
            return cell
        case .bottomButton:
            let cell = tableViewOutlet.dequeueCell(with: BottomButtonTableCell.self)
            cell.setTitle(title: "Submit")
            ///
            cell.actionButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.submitButtonAction()
                tableView.reloadData()
            }
            return cell
            
        case .budget: //Pure Workarround // Fix it later
            let cell = tableView.dequeueCell(with: BudgetCell.self)
            cell.handleArrowImage(status: selectButtonSelected)
            cell.dropDownTextField.text = filterData.payType.isEmpty ? PayType.perHour.rawValue : filterData.payType
            cell.detailTextField.delegate = self
            if filterData.price.isEmpty {
                cell.detailTextField.text = filterData.price
            } else {
                cell.detailTextField.text = "$" + filterData.price
            }
            cell.detailTextField.addTarget(self, action: #selector(textFieldDidChange) , for: .editingChanged)
            cell.selectButtonClosure = { [weak self] status in
                self?.selectButtonSelected = status
                self?.updateTableCell(indexPath: indexPath)
            }
            return cell
            
        case .rangeSlider:
            let cell = tableView.dequeueCell(with: PriceRangeCell.self)
            cell.setPrefilledData(payType: PayType(rawValue: filterData.payType) ?? .perHour)
            cell.configureCell(minValue: (self.filterData.minimumPrice)/10000, maxValue: (self.filterData.maximumPrice)/10000)
            cell.setPrice()
            cell.payTypeButtonAction = { [weak self] payType in
                self?.filterData.payType = payType.rawValue
            }
            cell.didChangeSliderValue = { [weak self] (minPrice, maxPrice) in
                self?.filterData.isSliderMoved = true
                self?.filterData.minimumPrice = minPrice
                self?.filterData.maximumPrice = maxPrice
            }
            return cell
        }
    }
    
    func updateTableCell(indexPath: IndexPath) {
        if let budgetView = Bundle.main.loadNibNamed("BudgetView", owner: self, options: nil)?.first as? BudgetView, let cell = tableViewOutlet.cellForRow(at: indexPath) as? BudgetCell {
            budgetView.frame = view.frame
            view.addSubview(budgetView)
            let buttonFrame = cell.selectionButton.frame
            let buttonRectInScreen = cell.selectionButton.convert(buttonFrame, to: tableViewOutlet.superview)
            let yCordinate = buttonRectInScreen.origin.y
            if kScreenHeight - yCordinate > 120 { // Can show in bottom
                budgetView.topConstraint.constant = yCordinate + 52 //52 is the height of button
            } else { //Show in top
                budgetView.topConstraint.constant = yCordinate - 111 //112 is the height of popup
            }
            budgetView.initialSetup()
            budgetView.budgetAction = { [weak self] paytype in
                self?.selectButtonSelected = !(self?.selectButtonSelected ?? false)
                self?.filterData.payType = paytype
                self?.mainQueue { [weak self] in
                    self?.tableViewOutlet.reloadRows(at: [indexPath], with: .none)
                }
            }
            budgetView.closeButtonAction = { [weak self] in
                self?.selectButtonSelected = !(self?.selectButtonSelected ?? false)
                self?.mainQueue { [weak self] in
                    self?.tableViewOutlet.reloadRows(at: [indexPath], with: .none)
                }
            }
            delay(time: 0.001) {
                budgetView.bottomListViewContainer.popIn()
            }
        }
    }
}
