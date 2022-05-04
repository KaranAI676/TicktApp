//
//  NotificationBuilderVC + Redirection.swift
//  Tickt
//
//  Created by S H U B H A M on 02/08/21.
//

import Foundation

extension NotificationBuilderVC {
    
    func redirectionNotification(type: PushNotificationTypes, model: NotificationListingModel) {
        switch type {
        case .tradieProfile:
            if let tradieId = model.othersId, let jobId = model.jobId {
                PushNotificationController.shared.goToTradieProfileVC(tradieId, jobId: jobId, jobName: model.extraData?.jobName ?? "")
            }
        case .builderProfile:
            if let jobId = model.jobId,
               let jobName = model.extraData?.jobName,
               let builderId = model.othersId {
                PushNotificationController.shared.goToBuilderProfile(jobName: jobName, jobId: jobId, builderId: builderId)
            }
        case .jobDetails:
            if let jobId = model.jobId,
               let jobStatus = JobStatus(rawValue: model.extraData?.jobStatusText ?? "") {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.extraData?.jobName ?? "")
                } else {
                    PushNotificationController.shared.jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                }
            } else {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.jobDetailTradieVC(jobStatus: nil, jobId: model.jobId ?? "", jobName: model.extraData?.jobName ?? "")
                } else {
                    CommonFunctions.showToastWithMessage("Invalid Job Status")
                }
            }
        case .paymentReceived:
            PushNotificationController.shared.goToPaymentTradieVC()
        case .dispute:
            redirectionNotification(type: .jobDetails, model: model)
        case .reviewTradie:
            if kUserDefaults.isTradie() {
                PushNotificationController.shared.reviewListingTradieVC(isMyProfile: true, builderId: kUserDefaults.getUserId())
            } else {
                PushNotificationController.shared.reviewTradieVC(model: model)
            }
        case .reviewBuilder:
            PushNotificationController.shared.reviewBuilder(model: model)
        case .questionListing:
            if let jobId = model.jobId,
               let jobName = model.extraData?.jobName {
                if let jobStatus = JobStatus(rawValue: model.extraData?.jobStatusText ?? "") {
                    if !kUserDefaults.isTradie() {
                        PushNotificationController.shared.questionListingBuilderVC(jobId: jobId, jobName: jobName, jobStatus: jobStatus)
                    } else {
                        if let builderId = model.extraData?.builderImage, let builderName = model.extraData?.builderName {
                            PushNotificationController.shared.questionListingTradieVC(jobStatus: jobStatus.rawValue, jobId: jobId, jobName: jobName, builderName: builderName, builderId: builderId)
                        } else {
                            PushNotificationController.shared.questionListingTradieVC(jobStatus: jobStatus.rawValue, jobId: jobId, jobName: jobName, builderName: model.extraData?.builderName ?? "", builderId: model.othersId ?? "")
                        }
                    }
                } else {
                    if let builderId = model.extraData?.builderImage, let builderName = model.extraData?.builderName {
                        PushNotificationController.shared.questionListingTradieVC(jobStatus: nil, jobId: jobId, jobName: jobName, builderName: builderName, builderId: builderId)
                    } else {
                        PushNotificationController.shared.questionListingTradieVC(jobStatus: nil, jobId: jobId, jobName: jobName, builderName: model.extraData?.builderName ?? "", builderId: model.othersId ?? "")
                    }
                }
            }
        case .reviewListing:
            if let id = model.othersId {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.reviewListingTradieVC(isMyProfile: false, builderId: id) /// this is for builder reviews
                } else {
                    PushNotificationController.shared.reviewListingBuilder(loggedInBuilder: false, tradieId: id, builderId: "")
                }
            }
        case .termsOfUse:
            PushNotificationController.shared.goToTermsOfUse()
        case .jobDashBoard:
            if let jobId = model.jobId,
               let jobStatus = JobStatus(rawValue: model.extraData?.jobStatusText ?? "") {
                if kUserDefaults.isTradie() {
                    if let redirectStatus =  RedirectStatus(rawValue: model.extraData?.redirectStatus ?? 0) {
                        switch redirectStatus {
                        case .past:
                            PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.extraData?.jobName ?? "")
                        case .active:
                            PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.extraData?.jobName ?? "")
                        case .new:
                            PushNotificationController.shared.openNewJobsTradie()
                        }
                    } else {
                        PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.extraData?.jobName ?? "")
                    }
                } else {
                    PushNotificationController.shared.jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                }
            } else {
                if kUserDefaults.isTradie() {
                    PushNotificationController.shared.jobDetailTradieVC(jobStatus: nil, jobId: model.jobId ?? "", jobName: model.extraData?.jobName ?? "")
                } else {
                    CommonFunctions.showToastWithMessage("Invalid Job Status")
                }
            }
            
        case .accountBlocked:
            PushNotificationController.shared.userBlocked()
        case .tradieVouchReceived:
            PushNotificationController.shared.openTradieVouchListing()
        case .approveMilestone:
            if let jobId = model.jobId, let jobStatus = JobStatus(rawValue: model.extraData?.jobStatusText ?? "") {
                if jobStatus == .completed || jobStatus == .cancelled || jobStatus == .cancelledJob {
                    if kUserDefaults.isTradie() {
                        PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.extraData?.jobName ?? "")
                    } else {
                        PushNotificationController.shared.jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                    }
                } else {
                    if kUserDefaults.isTradie() {
                        PushNotificationController.shared.goToMilestoneVC(jobId)
                    } else {
                        PushNotificationController.shared.goToCheckApproveVC(jobId)
                    }
                }
            }
        case .jobHomePage:
            break
        case .selfReviewList:
            if kUserDefaults.isTradie() {
                PushNotificationController.shared.reviewListingTradieVC(isMyProfile: true) /// this is for own reviews
            } else {
                if let builderId = model.myId {
                    PushNotificationController.shared.reviewListingBuilder(loggedInBuilder: true, tradieId: "", builderId: builderId)
                }
            }
        case .privacyPolicy:
            PushNotificationController.shared.gotToPrivacyPolicy()
        case .newsUpdate:
            break
        case .quoteJobCancel:
            if !kUserDefaults.isTradie() {
                PushNotificationController.shared.gotoAccountVC(jobID:model.jobId ?? "",tradieID: model.extraData?.tradieId ?? "" )
            }
        case .viewQuote:
            if kUserDefaults.isTradie(){
                if let jobId = model.jobId,
                   let jobStatus = JobStatus(rawValue: model.extraData?.jobStatusText ?? "") {
                    if kUserDefaults.isTradie() {
                        PushNotificationController.shared.jobDetailTradieVC(jobStatus: jobStatus, jobId: jobId, jobName: model.extraData?.jobName ?? "")
                    } else {
                        PushNotificationController.shared.jobDetailBuilderVC(jobId: jobId, jobStatus: jobStatus)
                    }
                } else {
                    if kUserDefaults.isTradie() {
                        PushNotificationController.shared.jobDetailTradieVC(jobStatus: nil, jobId: model.jobId ?? "", jobName: model.extraData?.jobName ?? "")
                    } else {
                        CommonFunctions.showToastWithMessage("Invalid Job Status")
                    }
                }
            }else{
                PushNotificationController.shared.goToJobQuotesVC(model: model)
            }
        }
    }
}

