//
//  ConfirmAndPayPaymentBuilderVC + Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 11/07/21.
//

import Foundation

extension ConfirmAndPayPaymentBuilderVC {
    
    func initialSetup() {
        setupUI()
        viewModel.cardListing()
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        setupTableView()
    }
    
    private func setupUI() {
        navTitleLabel.text = paymentDetailModel.jobName
        if !canPay {
            screenTitleLabel.text = "Payment details"
            payButton.isHidden = true
        }
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: BankCardTableCell.self)
        tableViewOutlet.registerCell(with: BottomButtonsTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func setupRecentCard() {
        if paymentDetailModel.paymentMethods.isEmpty {
            if !(viewModel.model?.isEmpty ?? true) {
                viewModel.model?[0].isSelected = true
                tableViewOutlet.reloadData()
            }
            return
        }
        
        if let index = viewModel.model?.firstIndex(where: { $0.cardId == paymentDetailModel.paymentMethods }) {
            viewModel.model?[index].isSelected = true
            
            if let deletedObject = (viewModel.model?.remove(at: index)) {
                viewModel.model?.insert(deletedObject, at: 0)
            }
        }
        
        tableViewOutlet.reloadData()
    }
    
    func validate() -> Bool {
        let index = viewModel.model?.firstIndex(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        
        if let index = index, let cardId = self.viewModel.model?[index].cardId {
                paymentDetailModel.paymentMethods = cardId
                return true
        }else {
            CommonFunctions.showToastWithMessage("Please choose payment method")
            return false
        }
    }
}

//MARK:- goTo Methods
//===================
extension ConfirmAndPayPaymentBuilderVC {
    
    func goToSuccessVC(_ screenType: ScreenType) {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = screenType
        push(vc: vc)
    }
    
    func goToAddPaymenrDetail(_ isEdit: Bool = false, _ model: CardListResultModel? = nil) {
        let vc = AddPaymentDetailsBuilderVC.instantiate(fromAppStoryboard: .approveMilestoneBuilder)
        if let model = model {
            vc.model = AddPaymentDetailBuilderModel(model)
        }
        vc.screenType = isEdit ? .editDetails : .addDetails
        vc.delegate = self
        push(vc: vc)
    }
    
    func goToAddBankDetail(_ isEdit: Bool = false, _ model: CardListResultModel? = nil) {
        let vc = PaymentDetailVC.instantiate(fromAppStoryboard: .jobDashboard)
        vc.fromBuilder = true
        push(vc: vc)
    }
}
