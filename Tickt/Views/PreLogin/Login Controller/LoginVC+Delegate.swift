//
//  LoginVC+Delegate.swift
//  Tickt
//
//  Created by Admin on 05/03/21.
//

import UIKit
import CoreLocation

extension LoginVC: GoogleSignDelegate {
    
    func present(viewController: UIViewController) {
        
    }
    
    func dismiss(viewController: UIViewController) {
        
    }
    
    func failure(error: Error) {
        //Workarround // Need to remove in further build.
        if !error.localizedDescription.contains("The user canceled the sign-in flow.") {
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
    
    func success(data: [String : String]) {
        kUserDefaults.set(true, forKey: UserDefaultKeys.kIsSocialLogin)
        kUserDefaults.set(data[ApiKeys.name] ?? "N.A", forKey: UserDefaultKeys.kUsername)
        kUserDefaults.set(data[ApiKeys.name] ?? "N.A", forKey: UserDefaultKeys.kFirstName)
        kUserDefaults.set(data[ApiKeys.socialId] ?? "", forKey: UserDefaultKeys.kSocialId)
        kUserDefaults.set(data[ApiKeys.email] ?? "", forKey: UserDefaultKeys.kLoggedInEmail)
        kUserDefaults.set(data[ApiKeys.userImage] ?? "", forKey: UserDefaultKeys.kProfileImage)
        kUserDefaults.setValue(AccountType.google.rawValue, forKey: UserDefaultKeys.kAccountType)
        viewModel.checkSocialId(socialId: data[ApiKeys.socialId] ?? "")        
    }
}

extension LoginVC: LinkedInSigninDelegate {    
    
    func linkedInSuccess(accessToken: String) {
        viewModel.getLinkedInProfile(accessToken: accessToken)
    }
    
    func linkedInFailure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }        
}

extension LoginVC: LoginViewModelDelegate {
    
    func socialIdExist(status: Bool) {
        if status { // Already registered
            let param: [String: Any] = [ApiKeys.authType: "login",
                                        ApiKeys.socialId: kUserDefaults.getSocialId(),
                                        ApiKeys.userType: kUserDefaults.getUserType(),
                                        ApiKeys.accountType: kUserDefaults.getSocialLoginType(),
                                        ApiKeys.deviceToken: kUserDefaults.getDeviceToken(),
                                        ApiKeys.email: kUserDefaults.getUserEmail()]
            viewModel.login(param: param, methodName: EndPoint.socialLogin.path)
        } else { //New User
            kAppDelegate.signupModel.name = kUserDefaults.getUsername()
            kAppDelegate.signupModel.email = kUserDefaults.getUserEmail()
            kAppDelegate.signupModel.profileImage = kUserDefaults.getUserProfileImage()
            let phoneVC = AddPhoneNumberVC.instantiate(fromAppStoryboard: .registration)
            push(vc: phoneVC)
        }
    }
    
    func willHitApi() {
        
    }
    
    func didGetSuccess() {
        TicketMoengage.shared.postEvent(eventType: .signup(status: true, source: "", name: kUserDefaults.getUsername(), email: kUserDefaults.getUserEmail(), platform: "IOS"))
        AppRouter.launchApp()
    }
    
    func linkedinSuccess(model: LinkedInModel) {
        let profileImage = model.profilePicture?.displayImage?.elements?.last?.identifiers?.last?.identifier ?? ""
        let lastName = model.lastName?.localized?.en_US ?? ""
        let firstName = model.firstName?.localized?.en_US ?? ""
        kUserDefaults.set(model.id, forKey: UserDefaultKeys.kSocialId)
        kUserDefaults.set(true, forKey: UserDefaultKeys.kIsSocialLogin)
        kUserDefaults.setValue(profileImage, forKey: UserDefaultKeys.kProfileImage)
        kUserDefaults.set(firstName + " " + lastName , forKey: UserDefaultKeys.kUsername)
        kUserDefaults.set(firstName + " " + lastName , forKey: UserDefaultKeys.kFirstName)
        kUserDefaults.setValue(AccountType.linkedIn.rawValue, forKey: UserDefaultKeys.kAccountType)
        viewModel.checkSocialId(socialId: model.id)
    }
    
    func didReceiveError(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}

//MARK:- CustomTextView: Delegate
//===============================
extension LoginVC: CustomTextViewDelegate {
    
    func getPassword(password: String) {
        
    }
}

//MARK:- TextField Delegates
//==========================
extension LoginVC: UITextFieldDelegate {
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let inputMode = textField.textInputMode else {
            return false
        }
        
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        
        guard let userEnteredString = textField.text else { return false }
        let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as NSString
        
        passwordFilled = newString.length > 0
        return newString.length <= 40
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === self.fullNameTextField {
            textField.resignFirstResponder()
            self.emailTextField.becomeFirstResponder()
        }
        
        if textField.returnKeyType == .done {
            emailTextField.resignFirstResponder()
        }
        return true
    }
}


extension LoginVC: CustomLocationManagerDelegate {
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
