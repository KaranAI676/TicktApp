//
//  AddPayment+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//

extension AddPaymentVC: BankAccountDelegates {
    func didGetBankAccount(model: BankModel) {
        bankModel = model
        if model.result.accountName.isNil {
            checkAccountStatus(status: false)
        } else {            
            checkAccountStatus(status: true)
        }
    }
    
    func failure(error: String) {
        
    }
    
    func checkAccountStatus(status: Bool) {
        containerView.isHidden = !status        
        selectBankAccount.isHidden = !status        
        accountSelected = true
        setBankAccount()
    }
}
