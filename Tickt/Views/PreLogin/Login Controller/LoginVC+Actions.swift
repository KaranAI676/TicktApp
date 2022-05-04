//
//  LoginVC+Actions.swift
//  Tickt
//
//  Created by Admin on 05/03/21.
//

import UIKit
import AuthenticationServices

extension LoginVC {
   
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case signUpButton:
            login()
        case googleLoginButton:
            kAppDelegate.googleHandler?.delegate = self
            kAppDelegate.googleHandler?.presentingVC = self
            kAppDelegate.googleHandler?.loginWithGooglePlus()
        case linkedInLoginButton:
            let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
            vc.delegate = self
            self.navigationController?.present(vc, animated: true, completion: nil)
        case appleLoginButton:
            loginWithApple()
        case forgottenButton:
            goToForgottenVC()
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
    
    func login() {
        let email = fullNameTextField.text ?? ""
        let password = emailTextField.text ?? ""
        
        if email.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmailEmpty)
            return 
        }
        
        if !(email.checkIfValid(.email)) {
            CommonFunctions.showToastWithMessage(Validation.errorEmailInvalid)
//            self.fullNameErrorLabel.text = "Please enter a valid email"
            return
        } else {
            self.fullNameErrorLabel.text = ""
        }
        
        if password.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter a password")
//            self.emailErrorLabel.text = "Please enter a password"
            return
        } else {
            self.emailErrorLabel.text = ""
        }
        
        fullNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        let param: [String: Any] = [ApiKeys.email: email,
                     ApiKeys.password: password,
                     ApiKeys.userType: kUserDefaults.getUserType(),
                     ApiKeys.deviceToken: kUserDefaults.getDeviceToken()]
        viewModel.login(param: param, methodName: EndPoint.login.path)
    }
}
