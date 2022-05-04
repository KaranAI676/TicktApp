//
//  AddAbn+Delegate.swift
//  Tickt
//
//  Created by Admin on 12/03/21.
//

import UIKit
import CoreLocation

extension AddAbnVC: AddAbnDelegate {
    func success() {
        TicketMoengage.shared.postEvent(eventType: .signup(status: true, source: "", name: kUserDefaults.getUsername(), email: kUserDefaults.getUserEmail(), platform: "IOS"))
        let successVC = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        successVC.screenType = .createAccount
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(successVC, animated: true)
        }
    }
    
    func failure(error: String) {
        
    }
}

extension AddAbnVC: CustomLocationManagerDelegate {
    func accessDenied() {
        kAppDelegate.signupModel.location[0] = kUserDefaults.getUserLongitude()
        kAppDelegate.signupModel.location[1] = kUserDefaults.getUserLatitude()
    }
    
    func accessRestricted() {
        kAppDelegate.signupModel.location[0] = kUserDefaults.getUserLongitude()
        kAppDelegate.signupModel.location[1] = kUserDefaults.getUserLatitude()
    }
    
    func fetchLocation(location: CLLocation) {
        kAppDelegate.signupModel.location[0] = location.coordinate.longitude
        kAppDelegate.signupModel.location[1] = location.coordinate.latitude
    }
}
