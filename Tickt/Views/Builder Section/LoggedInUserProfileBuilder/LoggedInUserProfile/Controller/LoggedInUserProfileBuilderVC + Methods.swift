//
//  LoggedInUserProfileBuilderVC + Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

extension LoggedInUserProfileBuilderVC {
    
    func initialSetup() {
        getCellArray()
        setupTableView()
        viewModel.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProfile(_:)), name: NotificationName.refreshProfile, object: nil)
        if kUserDefaults.isTradie() {
            viewModel.getTradieProfile()
        } else {
            viewModel.getBuilderProfile()
        }
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: ProfileOptionTableCell.self)
        tableViewOutlet.registerCell(with: ProfileTopViewTableCell.self)
        tableViewOutlet.registerCell(with: RatingProfileBlocksTableCell.self)
        ///
        tableViewOutlet.contentInset.bottom = 35
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func getCellArray() {
        if kUserDefaults.isTradie() {
            cellArray = [.profileInformation, .bankingDetails, .myPayments, .settings, .savedJobs, .supportChat, .appGuide, .privacyPolicy, .termsOfUse, .logout]            
        } else {
            cellArray = [.profileInformation, .paymentDetails, .milestoneTemplates, .paymentsHistory, .settings, .savedTradespeople, .supportChat, .appGuide, .privacyPolicy, .termsOfUse, .logout]
        }
    }
    
    private func logout() {
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertMessage: "Are you sure you want to logout?", completion: {
            self.viewModel.logout()
        })
    }
    
    @objc func refreshProfile(_ notification: Notification) {
        if kUserDefaults.isTradie() {
            viewModel.getTradieProfile()
        } else {
            viewModel.getBuilderProfile()
        }
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        if kUserDefaults.isTradie() {
            viewModel.getTradieProfile(isPullToRefresh: true)
        } else {
            viewModel.getBuilderProfile(isPullToRefresh: true)
        }
    }
    
    func goToCommonPopupVC() {
       let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
       vc.modalPresentationStyle = .overCurrentContext
       vc.delegate = self
       vc.isAnimated = true
       vc.buttonTypeArray = [.photo, .gallery]
       mainQueue { [weak self] in
           self?.navigationController?.present(vc, animated: true, completion: nil)
       }
   }
    
    func goToPreviewImage(image: UIImage?, url: String?) {
        let nextVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
        if let url = url {
            nextVC.urlString = url
        } else if let image = image {
            nextVC.image = image
        }
        push(vc: nextVC)
    }
    
    func optionTappedAction(option: CellTypes) {
        switch option {
        case .profileInformation:
            goToProfileInformation()
        case .paymentDetails:
            goToAddPaymenrDetail()
        case .bankingDetails:
            gotoBankingDetails()
        case .myPayments:
            goToMyPayment()
        case .savedJobs:
            goToSavedJobs()
        case .milestoneTemplates:
            goToMilestoneTemplates()
        case .paymentsHistory:
            goToPaymentHistory()
        case .settings:
            goToSettings()
        case .savedTradespeople:
            goToSavedTradespeople()
        case .supportChat:
            goToSupportChat()
        case .appGuide:
            goToAppGuide()
        case .privacyPolicy:
            goToProvacyPolicy()
        case .termsOfUse:
            goToTermsOfUse()
        case .logout:
            logout()
        }
    }
}
