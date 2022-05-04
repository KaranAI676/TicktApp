//
//  UIDeviceExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import AVFoundation
import UserNotifications

// MARK:- UIDEVICE
//==================

extension UIDevice {
    
    static let size = UIScreen.main.bounds.size
    
    static let height = UIScreen.main.bounds.height
    
    static let width = UIScreen.main.bounds.width

    @available(iOS 11.0, *)
    static var bottomSafeArea = AppConstant.getKeyWindow().safeAreaInsets.bottom

    @available(iOS 11.0, *)
    static let topSafeArea = AppConstant.getKeyWindow().safeAreaInsets.top
    
    static func vibrate() {
        let feedback = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        feedback.prepare()
        feedback.impactOccurred()
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

@available(iOS 13.0, *)
public let kKeyWindow = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first

@objcMembers
@objc public class AppConstant: NSObject {
    private override init() {
        
    }
    
    @objc public class func getKeyWindow() -> UIWindow {
        if #available(iOS 13.0, *) {
            return kKeyWindow ?? UIWindow()
        } else {
            return UIApplication.shared.keyWindow ?? UIWindow()
        }
    }
    
    @objc public class func getStatusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return getKeyWindow().windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

struct NotificationName {
    static let refreshJobCount = NSNotification.Name("RefreshJobCount")
    static let refreshPastList = NSNotification.Name("RefreshPastList")
    static let refreshActiveList = NSNotification.Name("RefreshJobList")
    static let switchJobTypesTab = NSNotification.Name("SwitchJobTypesTab")
    static let refreshAppliedList = NSNotification.Name("RefreshAppliedList")
    static let refreshHomeBuilder = NSNotification.Name("refreshHomeBuilder")
    static let refreshNewApplicant = NSNotification.Name("RefreshNewApplicant")
    static let refreshReviewStatus = NSNotification.Name("RefreshReviewStatus")
    static let refreshMilestoneList = NSNotification.Name("RefreshMilestonelist")
    static let milestoneAcceptDecline = NSNotification.Name("milestoneAcceptDecline")
    static let refreshBuilderJobDashboard = NSNotification.Name("RefreshBuilderJobDashboard")
    static let goToTransactionHistory = NSNotification.Name("TransactionHistory")    
    static let changeRequestBuilder = NSNotification.Name("changeRequestBuilder")
    static let refreshProfile = NSNotification.Name("refreshProfile")
    static let newJobCreated = NSNotification.Name("newJobCreated")
    static let refreshBankDetails = NSNotification.Name("refreshBankDetails")
    static let openDocumentViewer = NSNotification.Name("openDocumentViewer")

}
