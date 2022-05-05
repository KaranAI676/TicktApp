//
//  Router.swift
//  NowCrowdApp
//
//  Created by Admin on 15/06/20.
//  Copyright © 2020 Admin2020. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AppRouter {
    
    static func setAsWindowRoot(_ navigationController: UINavigationController) {
        kAppDelegate.window?.rootViewController = navigationController
        kAppDelegate.window?.becomeKey()
        kAppDelegate.window?.makeKeyAndVisible()
    }
    
    static func updateURL(link: String) {
        let application = UIApplication.shared
        guard let url = URL(string: link)  else {
            CommonFunctions.showToastWithMessage("LocalizedString.SomethingWentWrong.localized")
            return
        }
        if application.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                application.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            if #available(iOS 10.0, *) {
                application.open(URL(string: link)!, options: [:], completionHandler: nil)
            } else {
                application.openURL(URL(string: link)!)
            }
        }
    }
   
    static func goToMainHomeWithTabbarr() {
        let homeScene = TabBarVC.instantiate(fromAppStoryboard: .tabbar)
        let navigationController = UINavigationController(rootViewController: homeScene)
        navigationController.setNavigationBarHidden(true, animated: false)
        setAsWindowRoot(navigationController)
    }
    
    static func launchApp() {        
        if #available(iOS 13.0, *) {
            kAppDelegate.window?.overrideUserInterfaceStyle = .light
        }
                        
        if kAppDelegate.window == nil {
            kAppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        let mainVC = kUserDefaults.isUserLogin()
            ? TabBarController.instantiate(fromAppStoryboard: .home)
            : SelectUserVC.instantiate(fromAppStoryboard: .onBoarding)
        
        kAppDelegate.tabbar = (mainVC as? TabBarController)?.tabBar as? TabBarView
        kAppDelegate.mainNavigation.viewControllers.removeAll()
        kAppDelegate.mainNavigation.viewControllers.insert(mainVC, at: 0)
        kAppDelegate.tabBarController = mainVC as? TabBarController
        let navVC = SwipeableNavigationController(rootViewController: mainVC)
        navVC.setNavigationBarHidden(true, animated: false)        
        defer { kAppDelegate.window?.makeKeyAndVisible() }
        if !kUserDefaults.isUserLogin() {
            sleep(2)
        }
        
        if kUserDefaults.isUserLogin() {
            kAppDelegate.configureFirebase()            
            kAppDelegate.updateDeviceToken()
            if true || FirebaseAuth.Auth.auth().currentUser.isNotNil {
                if kUserDefaults.getUserEmail().isEmpty { return }
                if kUserDefaults.isFirebaseCreated() {
                    ChatHelper.signIn(withEmail: kUserDefaults.getUserEmail(), password: "12345678") { status in
                        if status {
                            print("Logged in to Firebase Console")
                        }
                    }
                } else {
                    ChatHelper.createFirebaseUser(withEmail: kUserDefaults.getUserEmail(), password: "12345678") { status in
                            ChatHelper.signIn(withEmail: kUserDefaults.getUserEmail(), password: "12345678") { status in
                                if status {
                                    print("Logged in to Firebase Console")
                                }
                            }
                    }
                }
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        kAppDelegate.getTradeList()
        setAsWindowRoot(navVC)
//        testingVC()
    }
    
    static func testingVC() {
        let vc = TabBarController.instantiate(fromAppStoryboard: .home)        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: false)
        setAsWindowRoot(navigationController)
    }
    
    static func openSettings(_ vc: UIViewController) {
        AppRouter.showAppAlertWithCompletion(vc: vc, alertType: .bothButton,
                                             alertTitle: "Location Permission",
                                             alertMessage: LS.changePrivacySettingAndAllowAccessToLocation.localized(),
                                             acceptButtonTitle: "Settings",
                                             declineButtonTitle: "Cancel") {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } dismissCompletion: {
            
        }
    }
    
    static func goToVC(viewController: UIViewController) {
        
        let nvc = UINavigationController(rootViewController: viewController)
        nvc.isNavigationBarHidden = true
        UIView.transition(with: kAppDelegate.window!, duration: 0.33, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            kAppDelegate.window?.rootViewController = nvc
        }, completion: nil)
        kAppDelegate.window?.becomeKey()
        kAppDelegate.window?.makeKeyAndVisible()
    }
    
    static func navigateToController(controllerName: String) {
        if let controller = controllerName.getViewController() {
            print(controller)
        }
    }
    
    static func showAppAlertWithCompletion(vc: UIViewController? = nil,
                                           alertType: AlertType = .bothButton,
                                           alertTitle: String = "Alert!",
                                           alertMessage: String,
                                           acceptButtonTitle: String = "Yes",
                                           declineButtonTitle: String = "Cancel",
                                           completion: (() -> Void)? = nil,
                                           dismissCompletion: (() -> Void)? = nil) {
        
        let alertVC = CommonAlertVC.instantiate(fromAppStoryboard: .commonAlert)
        alertVC.modalPresentationStyle = .overCurrentContext
        
        let model = CommonAlertModel(alertType: alertType, alertTitle: alertTitle, alertMessage: alertMessage, acceptButtonTitle: acceptButtonTitle, declineButtonTitle: declineButtonTitle)
        
        alertVC.model = model
        alertVC.btnActionClosure = { btnType in
            switch btnType {
            case .acceptButton:
                completion?()
            case .declineButton:
                dismissCompletion?()
            }
        }
        
        if vc != nil {
            vc?.present(alertVC, animated: false, completion: {
                alertVC.view.fadeIn(0.2)
            })
        } else {
            if let topVC = UIApplication.getTopViewController() {
                topVC.present(alertVC, animated: false, completion: {
                    alertVC.view.fadeIn(0.2)
                })
            }
        }
    }
}
