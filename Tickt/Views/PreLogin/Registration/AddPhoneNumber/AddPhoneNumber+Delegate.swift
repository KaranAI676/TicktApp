//
//  AddPhoneNumber+Delegate.swift
//  Tickt
//
//  Created by Admin on 10/03/21.
//

import UIKit

extension AddPhoneNumberVC: AddPhoneNumberDelegate {
    func success() {
        let verifyOTP = VerifyPhoneNumberVC.instantiate(fromAppStoryboard: .registration)
        if screenType == .edit {
            verifyOTP.number = emailField.text!.removeSpaces
        } else {
            verifyOTP.number = phoneNumberTextField.text!.removeSpaces
        }
        verifyOTP.screenType = screenType
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(verifyOTP, animated: true)
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
