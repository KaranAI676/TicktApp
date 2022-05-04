//
//  VerifyPhone+Delegate.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

import UIKit

extension VerifyPhoneNumberVC: VerifyPhoneDelegate {
    
    func emailVerifiedSuccess() {
        let vc = AddPhoneNumberVC.instantiate(fromAppStoryboard: .registration)
        push(vc: vc)
    }
    
    func resendEmailOTP() {
        self.startTimer()
    }
    
    func successEmailVerification() {
        successAction()
    }    
    
    func successResendOTP() {        
        self.startTimer()
    }
    
    func success() {
        successAction()
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}

extension VerifyPhoneNumberVC {
    
    fileprivate func successAction() {
        switch screenType {
        case .createAccount:
            if kUserDefaults.isSocialLogin() {
                if kUserDefaults.isTradie() {
                    let tradeVC = WhatIsYourTradeVC.instantiate(fromAppStoryboard: .registration)
                    push(vc: tradeVC)                    
                } else {
                    let companyDetail = CompanyDetailsVC.instantiate(fromAppStoryboard: .registration)
                    mainQueue { [weak self] in
                        self?.navigationController?.pushViewController(companyDetail, animated: true)
                    }
                }
            } else {
                self.goToCreatePasswordVC()
            }
        case .edit:
            self.goToCreatePasswordVC()
        case .changeEmail:
            CommonFunctions.removeUserDefaults()
            ///
            let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
            vc.screenType = .changeEmail
            push(vc: vc)
        default:
            break
        }
    }
}
