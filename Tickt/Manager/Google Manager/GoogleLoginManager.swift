//
//  GooglePlusLoginManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 04/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import GoogleSignIn

protocol GoogleSignDelegate: AnyObject {
    func present(viewController: UIViewController)
    func dismiss(viewController: UIViewController)
    func failure(error: Error)
    func success(data: [String: String])
}

class GoogleLoginManager: NSObject {
    
    weak var delegate: GoogleSignDelegate?
    var presentingVC: UIViewController?
    
    init(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        GIDSignIn.sharedInstance().clientID = "795502342919-18chok9djsvkeosprp029e0emn5fikr1.apps.googleusercontent.com"
    }
    
    func loginWithGooglePlus() {
        if let controller = presentingVC {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = controller
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
    }
}

extension GoogleLoginManager: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let nonNilError = error {
            delegate?.failure(error: nonNilError)
        } else {
            if let user = user {
                var userData = [String: String]()
                if let userId = user.userID {
                    userData[ApiKeys.socialId] = userId
                }
                if let name = user.profile.name {
                    userData[ApiKeys.name] = name
                }
                if let email = user.profile.email {
                    userData[ApiKeys.email] = email
                }                
                userData[ApiKeys.userImage] = user.profile.imageURL(withDimension: 400).absoluteString
                printDebug(userData)
                delegate?.success(data: userData)
                return
            }
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        printDebug(error.localizedDescription)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        delegate?.present(viewController: viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        delegate?.dismiss(viewController: viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        printDebug(error.localizedDescription)
    }
}

