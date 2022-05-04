//
//  UIApplicationExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import UIKit

extension UIApplication{
    
    func visibleViewController() -> UIViewController? {
        return self.windows.first { $0.isKeyWindow }?.rootViewController?.visibleViewController()
    }

    ///Opens Settings app
    @nonobjc class var openSettingsApp:Void{
        
        if #available(iOS 10.0, *) {
            self.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    ///Disables the ideal timer of the application
    @nonobjc class var disableApplicationIdleTimer:Void {
        self.shared.isIdleTimerDisabled = true
    }
    
    ///Enables the ideal timer of the application
    @nonobjc class var enableApplicationIdleTimer:Void {
        self.shared.isIdleTimerDisabled = false
    }    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension UIApplication {
    
    /// EZSE: Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    public class func topViewController(_ base: UIViewController? = kKeyWindow?.rootViewController) -> UIViewController {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
//        if let tab = base as? SSASideMenu {
//            if let selected = tab. {
//                return topViewController(selected)
//            }
//        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base!
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base ?? kAppDelegate.window?.rootViewController
    }
}
