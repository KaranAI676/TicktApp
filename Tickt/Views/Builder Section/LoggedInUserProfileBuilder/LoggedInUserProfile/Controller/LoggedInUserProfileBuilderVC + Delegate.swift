//
//  LoggedInUserProfileBuilderVC + Delegate.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

extension LoggedInUserProfileBuilderVC: LoggedInUserProfileBuilderVMDelegate {
    func profileUploadedSuccess(image: String) {
        ChatHelper.updateUserDetails()
        model?.result.userImage = image
        kUserDefaults.setValue(image, forKey: UserDefaultKeys.kProfileImage)
        tableViewOutlet.reloadData()
    }
        
    func didImageUploaded(imageUrl: String) {
        kUserDefaults.setValue(imageUrl, forKey: UserDefaultKeys.kProfileImage)
        ChatHelper.updateUserDetails()
        model?.result.userImage = imageUrl
        tableViewOutlet.reloadData()
    }
    
    func successGetBuilder(model: LoggedInUserProfileBuilderModel) {
        self.model = model
        kUserDefaults.set(model.result.userName, forKey: UserDefaultKeys.kUsername)
        IntercomHandler.shared.registerUser()
        refresher.endRefreshing()
        tableViewOutlet.reloadData()
    }
    
    func successLogout() {
        AppRouter.launchApp()
    }
 
    func didGetTradieProfile(model: LoggedInUserProfileBuilderModel) {
        self.model = model
        kUserDefaults.set(model.result.userName, forKey: UserDefaultKeys.kUsername)
        IntercomHandler.shared.registerUser()
        refresher.endRefreshing()
        tableViewOutlet.reloadData()
    }
    
    func failure(message: String) {
        refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(message)
    }
}
