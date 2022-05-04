//
//  PushNotificationController.swift
//  Tickt
//
//  Created by S H U B H A M on 26/07/21.
//

import Foundation

class PushNotificationController {
    
    static var shared = PushNotificationController()
    
    func redirectNotification(model: PushNotificationModel) {
        
        if !validate(model) { return }
        guard let notificationType = PushNotificationTypes.init(rawValue: model.notificationType!.intValue) else { return }
        
        ///
        switch notificationType {
        case .tradieProfile:
            if let tradieId = model.othersId, let jobId = model.jobId {
                goToTradieProfileVC(tradieId, jobId: jobId, jobName: model.myExtraModel()?.jobName ?? "")
            }
        case .builderProfile:
            if let jobId = model.jobId,
               let jobName = model.myExtraModel()?.jobName,
               let builderId = model.othersId {
                goToBuilderProfile(jobName: jobName, jobId: jobId, builderId: builderId)
            }
        case .jobDetails:
            if let jobId = model.jobId,
               let jobStatus = JobStatus(rawValue: model.myExtraModel()?.jobStatusText ?? "") {
                if kUserDefaults.isTradie() {
                    jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.myExtraModel()?.jobName ?? "")
                } else {
                    jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                }
            } else {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.jobDetailTradieVC(jobStatus: nil, jobId: model.jobId ?? "", jobName: model.myExtraModel()?.jobName ?? "")
                } else {
                    CommonFunctions.showToastWithMessage("Invalid Job Status")
                }
            }
        case .paymentReceived:
            if kUserDefaults.isTradie() {
                goToPaymentTradieVC()
            }
        case .dispute:
            if let jobId = model.jobId,
               let jobStatus = JobStatus(rawValue: model.myExtraModel()?.jobStatusText ?? "") {
                if kUserDefaults.isTradie() {
                    jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.myExtraModel()?.jobName ?? "")
                } else {
                    jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                }
            }  else {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.jobDetailTradieVC(jobStatus: nil, jobId: model.jobId ?? "", jobName: model.myExtraModel()?.jobName ?? "")
                } else {
                    CommonFunctions.showToastWithMessage("Invalid Job Status")
                }
            }
        case .reviewTradie:
            reviewTradieVC(model: model)
        case .reviewBuilder:
            reviewBuilder(model: model)
        case .questionListing:
            if let jobId = model.jobId,
               let jobName = model.myExtraModel()?.jobName,
               let jobStatus = JobStatus(rawValue: model.myExtraModel()?.jobStatusText ?? "") {
                if kUserDefaults.isTradie() {
                    questionListingTradieVC(jobStatus: jobStatus.rawValue, jobId: jobId, jobName: jobName, builderName: model.myExtraModel()?.builderName ?? "", builderId: model.othersId ?? "")
                } else {
                    questionListingBuilderVC(jobId: jobId, jobName: jobName, jobStatus: jobStatus)
                }
            }
        case .reviewListing:
            if let id = model.othersId {
                if kUserDefaults.isTradie() {
                    reviewListingTradieVC(isMyProfile: false, builderId: id) /// this is for builder reviews
                } else {
                    reviewListingBuilder(loggedInBuilder: false, tradieId: id, builderId: "")
                }
            }
        case .termsOfUse:
            goToTermsOfUse()
        case .jobDashBoard:
            if let jobId = model.jobId,
               let jobStatus = JobStatus(rawValue: model.myExtraModel()?.jobStatusText ?? "") {
                if kUserDefaults.isTradie() {
                    if let redirectStatus =  RedirectStatus(rawValue: model.myExtraModel()?.redirectStatus ?? 0) {
                        switch redirectStatus {
                        case .past:
                            PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.myExtraModel()?.jobName ?? "")
                        case .active:
                            PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.myExtraModel()?.jobName ?? "")
                        case .new:
                            openNewJobsTradie()
                        }
                    } else {
                        PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.myExtraModel()?.jobName ?? "")
                    }
                } else {
                    PushNotificationController.shared.jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                }
            } else {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.jobDetailTradieVC(jobStatus: nil, jobId: model.jobId ?? "", jobName: model.myExtraModel()?.jobName ?? "")
                } else {
                    CommonFunctions.showToastWithMessage("Invalid Job Status")
                }
            }
        case .accountBlocked:
            userBlocked()
        case .approveMilestone:
            if let jobId = model.jobId {
                if kUserDefaults.isTradie() {
                    goToMilestoneVC(jobId)
                } else {
                    goToCheckApproveVC(jobId)
                }
            }
        case .jobHomePage:
            CommonFunctions.showToastWithMessage("Navigate to Job Home Page")
            break
        case .selfReviewList:
            if kUserDefaults.isTradie() {
                reviewListingTradieVC(isMyProfile: true) /// this is for own reviews
            } else {
                if let builderId = model.myId {
                    reviewListingBuilder(loggedInBuilder: true, tradieId: "", builderId: builderId)
                }
            }
        case .tradieVouchReceived:
            openTradieVouchListing()
        case .privacyPolicy:
            gotToPrivacyPolicy()
        case .newsUpdate:
            break
        case .quoteJobCancel:
            if !kUserDefaults.isTradie() {
                gotoAccountVC(jobID: model.jobId ?? "",tradieID: model.myExtraModel()?.tradieId ?? "")
            }
        case .viewQuote:
            goToJobQuotesVC(model: model)
        }
    }
}

extension PushNotificationController {
    
    func goToVC(_ vc: UIViewController) {
        let topVC = UIApplication.getTopViewController()
        if topVC?.navigationController == nil {
            kAppDelegate.mainNavigation.pushViewController(vc, animated: true)
            return
        }
        if let nvc = topVC?.navigationController, nvc === kAppDelegate.mainNavigation {
            kAppDelegate.mainNavigation.pushViewController(vc, animated: true)
        } else {
            topVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func validate(_ model: PushNotificationModel) -> Bool {
        if model.notificationType.isNil || kUserDefaults.getAccessToken().isEmpty {
            CommonFunctions.showToastWithMessage("Something went wrong")
            return false
        }
        return true
    }
}

