//
//  UIStoryboard+extension.swift
//  Verkoop
//
//  Created by Vijay on 01/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

enum AppStoryboard : String {
    
    case chat = "Chat"
    case home = "Home"
    case search = "Search"
    case tabbar = "Tabbar"
    case quotes = "Quotes"
    case filter = "Filter"
    case profile = "Profile"
    case onBoarding = "OnBoarding"
    case jobPosting = "JobPosting"
    case registration = "Registration"
    case jobDashboard = "JobDashboard"
    case homeSearchBuilder = "HomeSearchBuilder"
    case jobDashboardBuilder = "JobDashboardBuilder"
    case questionListingBuilder = "QuestionListingBuilder"
    case newApplicantsBuilder = "NewApplicantsBuilder"
    case checkApproveBuilder = "CheckApproveBuilder"
    case approveDeclineDetailBuilder = "ApproveDeclineDetailBuilder"
    case openJobsApplications = "OpenJobsApplications"
    case commonJobDetails = "CommonJobDetails"
    case tradieProfilefromBuilder = "TradieProfilefromBuilder"
    case reviewTradePeople = "ReviewTradePeople"
    case cancelJobBuilder = "CancelJobBuilder"
    case documentReader = "DocumentReader"
    case lodgeDispute = "LodgeDispute"
    case portfolioDetailsBuilder = "PortfolioDetailsBuilder"
    case jobListingBuilder = "JobListingBuilder"
    case approveMilestoneBuilder = "ApproveMilestoneBuilder"
    case declineMilestoneBuilder = "DeclineMilestoneBuilder"
    case vouchesBuilder = "VouchesBuilder"
    case savedTradieBuilder = "SavedTradieBuilder"
    case loggedInUserProfileBuilder = "LoggedInUserProfileBuilder"
    case changePassword = "ChangePassword"
    case settingsBuilder = "SettingsBuilder"
    case supportChatBuilder = "SupportChatBuilder"
    case appGuide = "AppGuide"
    case notificationBuilder = "NotificationBuilder"
    case jobQuotes = "JobQuotes"
    case uploadDocuments = "UploadDocuments"
    case commonAlert = "CommonAlert"
    
    
    
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
