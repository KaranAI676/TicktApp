//
//  CancelJobBuilderVC+Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 02/06/21.
//

import Foundation

extension CancelJobBuilderVC: CancelJobBuilderVMDelegate {
    
    func success() {
        goToSuccessScreen()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
