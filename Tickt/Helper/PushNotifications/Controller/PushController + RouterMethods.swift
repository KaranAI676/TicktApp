//
//  PushController + RouterMethods.swift
//  Tickt
//
//  Created by S H U B H A M on 02/08/21.
//

import Foundation

extension PushNotificationController {
    
    func goToTradieProfileVC(_ tradieId: String, jobId: String, jobName: String) {
        if let vc = UIApplication.getTopViewController() as? TradieProfilefromBuilderVC {
            vc.tradieId = tradieId
            vc.jobId = jobId
            vc.jobName = jobName
            vc.showSaveUnsaveButton = true
            vc.hitApi()
            return
        }
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.jobId = jobId
        vc.jobName = jobName
        vc.tradieId = tradieId
        vc.showSaveUnsaveButton = true
        goToVC(vc)
    }
    
    func goToBuilderProfile(jobName: String, jobId: String, builderId: String) {
        if let vc = UIApplication.getTopViewController() as? BuilderProfileVC {
            vc.jobId = jobId
            vc.jobName = jobName
            vc.builderId = builderId
            vc.hitAPI()
            return
        }
        let vc = BuilderProfileVC.instantiate(fromAppStoryboard: .profile)
        vc.jobId = jobId
        vc.jobName = jobName
        vc.builderId = builderId
        goToVC(vc)
    }
    
    func goToCheckApproveVC(_ jobId: String) {
        if let vc = UIApplication.getTopViewController() as? CheckApproveBuilderVC {
            vc.jobId = jobId
            vc.hitApi()
            return
        }
        let vc = CheckApproveBuilderVC.instantiate(fromAppStoryboard: .checkApproveBuilder)
        vc.jobId = jobId
        goToVC(vc)
    }
    
    func goToMilestoneVC(_ jobId: String) {
        if let vc = UIApplication.getTopViewController() as? MilestoneVC {
            vc.jobId = jobId
            vc.hitAPI()
            return
        }
        let vc = MilestoneVC.instantiate(fromAppStoryboard: .jobDashboard)
        vc.jobId = jobId
        goToVC(vc)
    }
        
    func reviewTradieVC(model: PushNotificationModel) {
        if let jobId = model.jobId,
           let tradieId = model.othersId {
            let jobData = PastJobData(jobId: jobId,
                                      jobName: model.myExtraModel()?.jobName ?? "",
                                      tradeImage: model.myExtraModel()?.tradeImage ?? "",
                                      tradeName: model.myExtraModel()?.tradeName ?? "",
                                      fromDate: model.myExtraModel()?.fromDate ?? "",
                                      toDate: model.myExtraModel()?.toDate ?? "")
            
            let tradieData = PastJobTradieData(tradieId: tradieId,
                                               tradieImage: model.myExtraModel()?.tradieImage ?? "",
                                               tradieName: model.myExtraModel()?.tradieName ?? "",
                                               reviews: model.myExtraModel()?.reviewCount ?? 0,
                                               rating: model.myExtraModel()?.rating ?? 0.0)
            
            if let vc = UIApplication.getTopViewController() as? ReviewTradePeopleVC {
                vc.ratingModel = ReviewTradePeopleModel(jobName: model.myExtraModel()?.jobName ?? "", jobData: jobData, tradieData: tradieData)
            }
            
            let vc = ReviewTradePeopleVC.instantiate(fromAppStoryboard: .reviewTradePeople)
            vc.ratingModel = ReviewTradePeopleModel(jobName: model.myExtraModel()?.jobName ?? "", jobData: jobData, tradieData: tradieData)
            goToVC(vc)
        }
    }
    
    func reviewTradieVC(model: NotificationListingModel) {
        if let jobId = model.jobId,
           let tradieId = model.othersId {
            let jobData = PastJobData(jobId: jobId,
                                      jobName: model.extraData?.jobName ?? "",
                                      tradeImage: model.extraData?.tradeImage ?? "",
                                      tradeName: model.extraData?.tradeName ?? "",
                                      fromDate: model.extraData?.fromDate ?? "",
                                      toDate: model.extraData?.toDate ?? "")
            
            let tradieData = PastJobTradieData(tradieId: tradieId,
                                               tradieImage: model.extraData?.tradieImage ?? "",
                                               tradieName: model.extraData?.tradieName ?? "",
                                               reviews: model.extraData?.reviewCount ?? 0,
                                               rating: model.extraData?.rating ?? 0.0)
            
            if let vc = UIApplication.getTopViewController() as? ReviewTradePeopleVC {
                vc.ratingModel = ReviewTradePeopleModel(jobName: model.extraData?.jobName ?? "", jobData: jobData, tradieData: tradieData)
            }
            
            let vc = ReviewTradePeopleVC.instantiate(fromAppStoryboard: .reviewTradePeople)
            vc.ratingModel = ReviewTradePeopleModel(jobName: model.extraData?.jobName ?? "", jobData: jobData, tradieData: tradieData)
            goToVC(vc)
        }
    }
    
    func questionListingBuilderVC(jobId: String, jobName: String, jobStatus: JobStatus) {
        if let vc = UIApplication.getTopViewController() as? QuestionListingBuilderVC {
            vc.jobId = jobId
            vc.jobName = jobName
            vc.isJobExpired = jobStatus == .expired || jobStatus == .cancelled || jobStatus == .completed
            vc.hitAPI()
            return
        }
        let vc = QuestionListingBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.jobId = jobId
        vc.jobName = jobName
        vc.isJobExpired = jobStatus == .expired || jobStatus == .cancelled || jobStatus == .completed
        goToVC(vc)
    }
    
    func questionListingTradieVC(jobStatus: String?, jobId: String, jobName: String, builderName: String, builderId: String) {
        if let vc = UIApplication.getTopViewController() as? QuestionVC {
            vc.jobId = jobId
            vc.isPastJob = jobStatus?.lowercased() == "expired" || jobStatus?.lowercased() == "completed" || jobStatus?.lowercased() == "cancelled"
            vc.builderName = builderName
            vc.builderId = builderId
            vc.jobName = jobName
            vc.initialSetup()
            return
        }
        let vc = QuestionVC.instantiate(fromAppStoryboard: .search)
        vc.jobId = jobId
        vc.isPastJob = jobStatus?.lowercased() == "expired" || jobStatus?.lowercased() == "completed" || jobStatus?.lowercased() == "cancelled"
        vc.builderName = builderName
        vc.builderId = builderId
        vc.jobName = jobName
        goToVC(vc)
    }
    
    func jobDetailBuilderVC(jobId: String, jobStatus: JobStatus) {
        
        if false  { //jobStatus == .inactive
            //Navigate to job Dashboard
        } else {
            if let vc = UIApplication.getTopViewController() as? CommonJobDetailsVC {
                vc.screenType = CommonFunctions.getScreenTypeFromJobStatus(jobStatus)
                vc.jobId = jobId
                vc.pastJobStatus = jobStatus.rawValue.uppercased()
                vc.republishModel = nil
                vc.hitApi()
                return
            }
            let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
            vc.screenType = CommonFunctions.getScreenTypeFromJobStatus(jobStatus)
            vc.jobId = jobId
            vc.pastJobStatus = jobStatus.rawValue.uppercased()
            vc.republishModel = nil
            goToVC(vc)
        }
    }
    
    func openNewJobsTradie() {
        if let vc = UIApplication.getTopViewController() as? JobListingVC {
            vc.screenType = .newJob
            vc.initialSetup()
            return
        }
        
        let vc = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        vc.screenType = .newJob
        goToVC(vc)
    }
    
    func reviewListingBuilder(loggedInBuilder: Bool, tradieId: String, builderId: String) {
        if let vc = UIApplication.getTopViewController() as? QuestionListingBuilderVC {
            vc.tradieId = loggedInBuilder ? builderId : tradieId
            vc.screenType = loggedInBuilder ? .reviewReply : .review
            vc.hitAPI()
            return
        }
        let vc = QuestionListingBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.tradieId = loggedInBuilder ? builderId : tradieId
        vc.screenType = loggedInBuilder ? .reviewReply : .review
        goToVC(vc)
    }
    
    func reviewListingTradieVC(isMyProfile: Bool, builderId: String = "") {
        if let vc = UIApplication.getTopViewController() as? JobListingVC {
            vc.screenType = .allReviews
//            vc.allReviewsCount = reviewCount
            vc.isMyProfile = isMyProfile
            vc.builderId = isMyProfile ? builderId : kUserDefaults.getUserId()
            return
        }
        let vc = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        vc.screenType = .allReviews
//        vc.allReviewsCount = reviewCount
        vc.isMyProfile = isMyProfile
        vc.builderId = !isMyProfile ? builderId : kUserDefaults.getUserId()
        goToVC(vc)
    }
    
    func goToPastJobListing() {
        
    }
    
    func goToTermsOfUse() {
        if let vc = UIApplication.getTopViewController() as? WebViewController {
            vc.screenType = .terms
            vc.setScreenType()
            return
        }
        let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .terms
        goToVC(vc)
    }
    
    func gotToPrivacyPolicy() {
        if let vc = UIApplication.getTopViewController() as? WebViewController {
            vc.screenType = .privacy
            vc.setScreenType()
            return
        }
        let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .privacy
        goToVC(vc)
    }

    
    func goToPaymentTradieVC() {
        if let vc = UIApplication.getTopViewController() as? MyRevenueVC {
            vc.hitAPI()
            return
        }
        let vc = MyRevenueVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        goToVC(vc)
    }
    
    func reviewBuilder(model: PushNotificationModel) {        
        var jobData = RecommmendedJob()
        jobData.jobId = model.jobId
        jobData.jobName = model.myExtraModel()?.jobName ?? ""
        jobData.tradeName = model.myExtraModel()?.tradeName ?? ""
        jobData.jobDescription = model.myExtraModel()?.jobDesc ?? ""
        var object = BuilderData()
        object.builderId = model.othersId
        object.builderImage =  model.myExtraModel()?.builderImage
        object.jobDescription = model.myExtraModel()?.jobDesc
        jobData.builderData = object
        jobData.fromDate = model.myExtraModel()?.fromDate
        jobData.toDate = model.myExtraModel()?.toDate
        
        if let vc = UIApplication.getTopViewController() as? ReviewBuilderVC {
            vc.jobData = jobData
            vc.initialSetup()
            return
        }
        let vc = ReviewBuilderVC.instantiate(fromAppStoryboard: .profile)
        vc.jobData = jobData
        goToVC(vc)
    }
    
    func reviewBuilder(model: NotificationListingModel) {
        
        var jobData = RecommmendedJob()
        jobData.jobId = model.jobId ?? ""
        jobData.jobName = model.extraData?.jobName ?? ""
        jobData.tradeName = model.extraData?.tradeName ?? ""
        jobData.jobDescription = model.extraData?.jobDesc ?? "N.A"
        var object = BuilderData()
        object.builderId = model.othersId
        object.builderImage = model.extraData?.builderImage
        object.jobDescription = model.extraData?.jobDesc
        jobData.builderData = object
        jobData.fromDate = model.extraData?.fromDate
        jobData.toDate = model.extraData?.toDate
        
        if let vc = UIApplication.getTopViewController() as? ReviewBuilderVC {
            vc.jobData = jobData
            vc.initialSetup()
            return
        }
        let vc = ReviewBuilderVC.instantiate(fromAppStoryboard: .profile)
        vc.jobData = jobData
        goToVC(vc)
    }
    
    func jobDetailTradieVC(jobStatus: JobStatus?, jobId: String, jobName: String) {
        if false { //jobStatus == .inactive
            //Navigate to job Dashboard
        } else {
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            if jobStatus != nil, jobStatus != .open {
                jobDetailVC.screenType = .activeJobDetail
            } else {
                jobDetailVC.screenType = .jobDetail
            }
            jobDetailVC.jobId = jobId
            goToVC(jobDetailVC)
        }
    }
    
    func openTradieVouchListing() {
        let vc = VouchesLisitngBuilderVC.instantiate(fromAppStoryboard: .vouchesBuilder)
        vc.tradieId = kUserDefaults.getUserId()
        goToVC(vc)
    }
    
    func userBlocked() {
        CommonFunctions.removeUserDefaults()
        AppRouter.launchApp()
        if let vc = UIApplication.getTopViewController() {
            AppRouter.showAppAlertWithCompletion(vc: vc, alertType: .singleButton,
                                                 alertTitle: "Account Blocked",
                                                 alertMessage: "Admin has blocked your account",
                                                 acceptButtonTitle: "Settings",
                                                 declineButtonTitle: "Cancel") { } dismissCompletion: { }
        }
    }
    
    func gotoAccountVC(jobID:String,tradieID:String){
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .quoteClose
        vc.jobId = jobID
        vc.tradieId = tradieID
        goToVC(vc)
    }

    func goToJobQuotesVC(model: PushNotificationModel) {
        let vc = QuotesListingVC.instantiate(fromAppStoryboard: .jobQuotes)
        var jobModel = BasicJobModel()
        jobModel.tradeName = model.myExtraModel()?.tradeName ?? ""
        jobModel.jobName = model.myExtraModel()?.jobName ?? ""
        jobModel.tradeImage = model.myExtraModel()?.tradeImage ?? ""
        jobModel.jobFromDate = model.myExtraModel()?.fromDate ?? ""
        jobModel.jobToDate = model.myExtraModel()?.toDate ?? ""
        jobModel.jobId = model.jobId ?? ""
        jobModel.quoteJob = true
        jobModel.quoteCount = model.myExtraModel()?.quoteCount ?? 0
        vc.jobModel = jobModel
        goToVC(vc)
    }
    
    func goToJobQuotesVC(model: NotificationListingModel) {
        let vc = QuotesListingVC.instantiate(fromAppStoryboard: .jobQuotes)
        var jobModel = BasicJobModel()
        jobModel.tradeName = model.extraData?.tradeName ?? ""
        jobModel.jobName = model.extraData?.jobName ?? ""
        jobModel.tradeImage = model.extraData?.tradeImage ?? ""
        jobModel.jobFromDate = model.extraData?.fromDate ?? ""
        jobModel.jobToDate = model.extraData?.toDate ?? ""
        jobModel.jobId = model.jobId ?? ""
        jobModel.quoteJob = true
        jobModel.quoteCount = model.extraData?.quoteCount ?? 0
        vc.jobModel = jobModel
        goToVC(vc)
    }
    
    func openChatVC(dict: [AnyHashable: Any]) {
        if let object = dict as? JSONDictionary,
           let jsonString = dict["gcm.notification.sender"] as? String,
           let senderDetail = kAppDelegate.getSenderDetail(jsonString: jsonString),
           let matchingId = senderDetail["user_id"] as? String {
            let jobId = object["gcm.notification.jobId"] as? String ?? ""
            let jobName = object["gcm.notification.jobName"] as? String ?? ""
            var tradieId = ""
            var builderIds = ""
            var userId = ""
            var otherUserId = ""
            
            if kUserDefaults.isTradie() {
                tradieId = kUserDefaults.getUserId()
                builderIds = matchingId
                userId = tradieId
                otherUserId = builderIds
            } else {
                tradieId = matchingId
                builderIds = kUserDefaults.getUserId()
                userId = builderIds
                otherUserId = tradieId
            }
            
            let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderIds)
            ChatHelper.checkInboxExistsFor(jobId: jobId, otherUserId: otherUserId, userId: userId, completion: { (exists) in
                var chatRoom: ChatRoom?
                if !exists {
                    ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: builderIds, unreadCount: 0, jobId: jobId, jobName: jobName)
                }
                ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                    [weak self] (room) in
                    guard let self = self else { return }
                    if room != nil, !(room?.chatRoomId.isEmpty)! {
                        chatRoom = room
                    } else {
                        chatRoom = ChatHelper.createRoom(jobId: jobId, tradieId: tradieId, builderId: builderIds, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: builderIds)])
                    }
                    if self.emptyCheck(array: [tradieId, jobId, chatRoom?.chatRoomId ?? "", builderIds, jobName]) {
                        let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                        chatVC.tradieId = tradieId
                        chatVC.jobId = jobId
                        chatVC.chatRoom = chatRoom!
                        chatVC.builderId = builderIds
                        chatVC.jobName = jobName
                        if kUserDefaults.isTradie() {
                            chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: builderIds, receiverId: otherUserId, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderIds), otherUserUnreadCount: 0, jobId: jobId)
                        } else {
                            chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: builderIds, receiverId: otherUserId, chatRoom: chatRoom!, chatMember: ChatMember(userId: tradieId), otherUserUnreadCount: 0, jobId: jobId)
                        }
                        self.goToVC(chatVC)
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to fetch details")
                    }
                })
            })
        }
    }
    
    func emptyCheck(array: [String]) -> Bool {
        for string in array {
            if string.isEmpty {
                return false
            }
        }
        return true
    }

}
