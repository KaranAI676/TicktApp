//
//  IntercomHandler.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import Intercom
import Foundation

class IntercomHandler {
    
    //MARK:- Variables
    static let shared = IntercomHandler()
    
    //MARK:- Methods
    func registerAPI() {
        Intercom.setApiKey(AppConstants.getIntercomApiKey.rawValue, forAppId: AppConstants.getIntercomAppId.rawValue)
    }
    
    func registerUser() {
        if !kUserDefaults.getUserId().isEmpty {
            Intercom.registerUser(withUserId: kUserDefaults.getUserId(), email: kUserDefaults.getUserEmail())
            self.updateUser()
        }
    }
    
    private func updateUser() {
        let userAttributes = ICMUserAttributes()
        userAttributes.name = kUserDefaults.getUsername()
        Intercom.updateUser(userAttributes)
    }
    
    func logout() {
        Intercom.logout()
    }
    
    func show() {
        Intercom.presentMessenger()
    }
    
//    func hide() {
//        Intercom.hideMessenger()
//    }
}
