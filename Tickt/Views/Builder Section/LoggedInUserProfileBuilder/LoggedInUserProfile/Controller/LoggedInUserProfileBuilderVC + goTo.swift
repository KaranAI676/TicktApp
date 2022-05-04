//
//  LoggedInUserProfileBuilderVC + goTo.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

extension LoggedInUserProfileBuilderVC {
    
    func goToAddPaymenrDetail() {
        let vc = ConfirmAndPayPaymentBuilderVC.instantiate(fromAppStoryboard: .approveMilestoneBuilder)
        vc.canPay = false
        push(vc: vc)
    }
    
    func goToMilestoneTemplates() {
        let vc = TemplatesListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .editTemplates
        self.push(vc: vc)
    }
    
    func goToSavedJobs() {
        let jobListing = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        jobListing.screenType = .savedjobs
        push(vc: jobListing)
    }
    
    func goToMyPayment() {
        let revenueVc = MyRevenueVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        push(vc: revenueVc)        
    }
    
    func gotoBankingDetails() {
        let paymentVC = PaymentDetailVC.instantiate(fromAppStoryboard: .jobDashboard)
        paymentVC.isFromProfile = true
        push(vc: paymentVC)
    }
    
    func goToProfileInformation() {
        if kUserDefaults.isTradie() {
            self.viewProfile(isEdit: true)
        } else {
            let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
            vc.loggedInBuilder = true
            push(vc: vc)
        }
    }
    
    func goToPaymentHistory() {
        let vc = TransactionHistoryBuilder.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        push(vc: vc)
    }
    
    func goToSettings() {
        let vc = SettingsBuilderVC.instantiate(fromAppStoryboard: .settingsBuilder)
        push(vc: vc)
    }
    
    func goToSavedTradespeople() {
        let vc = SavedTradieBuilderVC.instantiate(fromAppStoryboard: .savedTradieBuilder)
        vc.showSaveUnsaveButton = true
        push(vc: vc)
    }
    
    func goToSupportChat() {
        IntercomHandler.shared.show()
    }
    
    func goToAppGuide() {
        let vc = AppGuideVC.instantiate(fromAppStoryboard: .appGuide)
        if let homeVC = tabBarController?.viewControllers?.first as? TradieHomeVC {
            vc.homeVC = homeVC
            vc.currentTabBar = .profile
            tabBarController?.selectedIndex = TabBarIndex.home.tabValue
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    }
    
    func goToProvacyPolicy() {
        let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .privacy
        push(vc: vc)
    }
    
    func goToTermsOfUse() {
        let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .terms
        push(vc: vc)        
    }
}
