//
//  ConfirmAndPayPaymentBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 11/07/21.
//

import Foundation
import Stripe

extension ConfirmAndPayPaymentBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .cards:
            return viewModel.model?.count ?? 0
        case .addAnother,.addBank:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .cards:
            let cell = tableView.dequeueCell(with: BankCardTableCell.self)
//            viewModel.hitPagination(index: indexPath.row) uncomment when pagination needed
            cell.cardModel = viewModel.model?[indexPath.row]
            cell.cardImageView.image = (viewModel.model?[indexPath.row].brand == "visa") ? #imageLiteral(resourceName: "visa") : #imageLiteral(resourceName: "Mastercard")
            cell.buttonBackView.isHidden = !canPay
            return cell
        case .addAnother:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.secondButton.round(radius: 3)
            let title = (viewModel.model?.isEmpty ?? true ) ? "Add card" : "Add another card"
            cell.secondButton.setTitleForAllMode(title: title)
            cell.buttonClosure = { [weak self] type in
                guard let self = self else { return }
                if type == .secondButton {
                    self.goToAddPaymenrDetail()
                }
            }
            return cell
        case .addBank:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.secondButton.round(radius: 3)
            let title = "Add bank"
            cell.secondButton.setTitleForAllMode(title: title)
            cell.buttonClosure = { [weak self] type in
                guard let self = self else { return }
                if type == .secondButton {
                    let vc = AddBankVC.instantiate(fromAppStoryboard: .approveMilestoneBuilder)
                    vc.amount = Int(self.paymentDetailModel.milestoneData.milestoneAmount) ?? 0
                    vc.paymentDetailModel = self.paymentDetailModel
                    self.push(vc: vc)
                }
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !canPay {
            return
        }
        switch sectionArray[indexPath.section] {
        case .cards:
            if viewModel.model?[indexPath.row].isSelected == true {
                self.viewModel.model?[indexPath.row].isSelected = false
                tableView.reloadData()
                return
            }
            for i in 0..<(self.viewModel.model?.count ?? 0) {
                self.viewModel.model?[i].isSelected = false
            }
            let bool = (self.viewModel.model?[indexPath.row].isSelected ?? false)
            viewModel.model?[indexPath.row].isSelected = !bool
            tableView.reloadData()
        default:
            break
        }
    }
}

extension ConfirmAndPayPaymentBuilderVC {
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
//    -> UISwipeActionsConfiguration? {
//        let editAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
//            self.goToAddPaymenrDetail(true, self.viewModel.model?[indexPath.row])
//        }
//        ///
//        let image = #imageLiteral(resourceName: "EditWithTitlte")
//        let size = CGSize(width: image.size.width, height: image.size.height + 20)
//        editAction.image = UIGraphicsImageRenderer(size: size).image { context in
//        var centralizedRect = CGRect(origin: .zero, size: image.size)
//        centralizedRect.origin.y = centralizedRect.origin.y + 20
//            image.draw(in: centralizedRect)
//        }
//        editAction.backgroundColor = .white
//        let configuration = UISwipeActionsConfiguration(actions: [editAction])
//        return configuration
//    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            if let cardId = self.viewModel.model?[indexPath.row].cardId {
                AppRouter.showAppAlertWithCompletion(vc: self, alertMessage: "Are you sure you want to delete this card?", acceptButtonTitle: "Delete", declineButtonTitle: "Cancel", completion: {
                    self.viewModel.deleteCard(cardId: cardId, index: indexPath)
                }, dismissCompletion: {
                    tableView.reloadWithAnimation()
                })
            }
        }
        ///
        let image = #imageLiteral(resourceName: "delete")
        let size = CGSize(width: image.size.width, height: image.size.height + 20)
        deleteAction.image = UIGraphicsImageRenderer(size: size).image { context in
        var centralizedRect = CGRect(origin: .zero, size: image.size)
        centralizedRect.origin.y = centralizedRect.origin.y + 20
            image.draw(in: centralizedRect)
        }
        deleteAction.backgroundColor = .white
        
        let editAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.goToAddPaymenrDetail(true, self.viewModel.model?[indexPath.row])
        }
        ///
        let editimage = #imageLiteral(resourceName: "EditWithTitlte")
        let editsize = CGSize(width: editimage.size.width, height: editimage.size.height + 20)
        editAction.image = UIGraphicsImageRenderer(size: editsize).image { context in
        var centralizedRect = CGRect(origin: .zero, size: editimage.size)
        centralizedRect.origin.y = centralizedRect.origin.y + 20
            editimage.draw(in: centralizedRect)
        }
        editAction.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sectionArray[indexPath.section] != .addAnother
    }
}
