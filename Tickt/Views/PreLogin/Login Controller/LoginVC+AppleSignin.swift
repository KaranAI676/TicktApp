//
//  LoginVC+AppleSignin.swift
//  Tickt
//
//  Created by Admin on 06/03/21.
//

import AuthenticationServices
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
         
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        printDebug(error.localizedDescription)
    }
       
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName ?? "N.A"
            let appleUserLastName = appleIDCredential.fullName?.familyName ?? "N.A"
            let appleUserEmail = appleIDCredential.email ?? "N.A"
            print(appleId, appleUserFirstName, appleUserLastName, appleUserEmail )

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleId) { [weak self] (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("Authorized")
                    kUserDefaults.set(true, forKey: UserDefaultKeys.kIsSocialLogin)
                    kUserDefaults.setValue(AccountType.apple.rawValue, forKey: UserDefaultKeys.kAccountType)
                    kUserDefaults.set(appleId, forKey: UserDefaultKeys.kSocialId)
                    kUserDefaults.set(appleUserEmail, forKey: UserDefaultKeys.kLoggedInEmail)
                    kUserDefaults.set(appleUserFirstName, forKey: UserDefaultKeys.kFirstName)
                    self?.viewModel.checkSocialId(socialId: appleId)
                    break
                case .revoked:
                    CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "")
                    print("Revoked")
                    break
                case .notFound:
                    print("Not Found")
                    CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "")
                default:
                    break
                }
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            print(appleUsername, applePassword)
        }
    }
}


