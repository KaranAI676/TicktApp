//
//  PaymentDetail+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//

extension PaymentDetailVC: AddBankAccountDelegates {
    
    func didGetBankAccount(model: BankModel) {
        bankDetail = model.result
        setbankData()
    }
    
    func didMilestoneCompleted(jobCount: Int) {
        let successVC = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        if jobCount > 0 {
            successVC.jobsCompleted = jobCount
            successVC.screenType = .completeJob
        } else {
            if MilestoneVC.milestoneData.isPhotoEvidence {
                successVC.screenType = .completeMilestoneWithPhotoEvidence
            } else {
                successVC.screenType = .completeMilestone
            }
        }
        push(vc: successVC)
    }
    
    func didAddedBankAccount(model: BankModel) {
        if isEdit {
            Loader.hide()
            if isFromProfile {
                pop()
            } else {
                bankDetail = model.result
                initialSetup()
                addAccountAction?(model.result)
            }
        } else {
            viewModel.uploadImages()
        }
    }
    
    func didDeletedBankAccount() {
        bsbNumberField.text = ""
        accountNameField.text = ""
        accountNumberField.text = ""
        deleteAccountAction?()
        settingButton.isHidden = true
        isAccountSaved = false
        isEdit = true
        bankDetail?.resetData()
    }

    func failure(error: String) {
        
    }
}
