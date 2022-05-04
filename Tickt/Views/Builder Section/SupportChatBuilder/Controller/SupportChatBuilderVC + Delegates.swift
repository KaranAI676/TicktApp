//
//  SupportChatBuilderVC + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import Foundation

extension SupportChatBuilderVC: SupportChatBuilderVMDelegate {
    
    func success() {
        goToSuccessVC()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
