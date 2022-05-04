//
//  CreateAccount+Actions.swift
//  Tickt
//
//  Created by Admin on 08/03/21.
//

import UIKit
import AuthenticationServices

extension CreateAccountVC {
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case self.backButton:
            kAppDelegate.signupModel.name = ""
            kAppDelegate.signupModel.email = ""
            pop()
        case agreeButton:
            agreeButton.isSelected = !(agreeButton.isSelected)
            return
        case signUpButton:
            kUserDefaults.set(false, forKey: UserDefaultKeys.kIsSocialLogin)
            if validate() {
                viewModel.checkEmailId(emailId: emailTextField.text!)
            }
        case googleLoginButton:
            kAppDelegate.googleHandler?.delegate = self
            kAppDelegate.googleHandler?.presentingVC = self
            kAppDelegate.googleHandler?.loginWithGooglePlus()
        case linkedInLoginButton:
            let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
            vc.delegate = self
            present(vc, animated: true, completion: {})
        case appleLoginButton:
            loginWithApple()
        default:
            break
        }
        disableButton(sender)        
    }
    
    func loginWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func validate() -> Bool {
        
        if fullNameTextField.text!.isEmpty {
            self.fullNameErrorLabel.text = Validation.errorEmptyName
//            CommonFunctions.showToastWithMessage(Validation.errorEmptyName)
            return false
        }else {
            self.fullNameErrorLabel.text = CommonStrings.emptyString
        }
                
        if emailTextField.text!.isEmpty {
            self.emailErrorLabel.text = Validation.errorEmailEmpty
//            CommonFunctions.showToastWithMessage(Validation.errorEmailEmpty)
            return false
        }else {
            self.emailErrorLabel.text = CommonStrings.emptyString
        }
        
        if !emailTextField.text!.isValidEmail() {
            self.emailErrorLabel.text = Validation.errorEmailInvalid
//            CommonFunctions.showToastWithMessage(Validation.errorEmailInvalid)
            return false
        }else {
            self.emailErrorLabel.text = CommonStrings.emptyString
        }
        
        if !agreeButton.isSelected {
            CommonFunctions.showToastWithMessage(Validation.errorTermsAndCondition)
            return false
        }
        return true
    }
    
}
