//
//  CancelJob+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 22/06/21.
//

import Foundation

extension CancelJobVC: CancelJobDelegate {
    
    func success() {
        let successVC = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        successVC.screenType = .cancelJob
        push(vc: successVC)
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
