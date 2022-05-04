//
//  CommonAlertModel.swift
//  Tickt
//
//  Created by S H U B H A M on 27/09/21.
//

import Foundation

enum AlertType {
    case bothButton
    case singleButton
}

struct CommonAlertModel {
    
    var alertType: AlertType
    var alertTitle: String
    var alertSubTitle: String
    var acceptButtonTitle: String
    var declineButtonTitle: String
    
    init(alertType: AlertType, alertTitle: String, alertMessage: String, acceptButtonTitle: String, declineButtonTitle: String) {
        self.alertType = alertType
        self.alertTitle = alertTitle
        self.alertSubTitle = alertMessage
        self.acceptButtonTitle = acceptButtonTitle
        self.declineButtonTitle = declineButtonTitle
    }
}
