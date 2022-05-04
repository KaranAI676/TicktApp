//
//  JobPreview+Routing.swift
//  Tickt
//
//  Created by Admin on 27/04/21.
//

import Foundation

extension CreatingJobPreviewVC {
    
    func goToMessageVC() {
        let jobStatus = jobDetail?.result?.jobStatus ?? ""
        if screenType == .activeJobDetail && jobStatus.lowercased() != "applied" && jobStatus.lowercased() != "cancelledapply" && jobStatus.lowercased() != "expired" {
            let tradieId = kUserDefaults.getUserId()
            let builderId = jobDetail?.result?.postedBy?.builderId ?? ""
            let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderId)
            ChatHelper.checkInboxExistsFor(jobId: self.jobId, otherUserId: builderId, userId: tradieId, completion: { (exists) in
                var chatRoom: ChatRoom?
                if !exists {
                    ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: builderId, unreadCount: 0, jobId: self.jobId, jobName: self.jobDetail?.result?.jobName ?? "")
                }
                ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                    [weak self] (room) in
                    guard let self = self else { return }
                    if room != nil, !(room?.chatRoomId.isEmpty)! {
                        chatRoom = room
                    } else {
                        chatRoom = ChatHelper.createRoom(jobId: self.jobId, tradieId: tradieId, builderId: builderId, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: builderId)])
                    }                    
                    if self.emptyCheck(array: [tradieId, self.jobId, chatRoom?.chatRoomId ?? "", builderId, self.jobDetail?.result?.jobName ?? ""]) {
                        let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                        chatVC.tradieId = tradieId
                        chatVC.jobName = self.jobDetail?.result?.jobName ?? ""
                        chatVC.jobId = self.jobId
                        chatVC.chatRoom = chatRoom!
                        chatVC.builderId = builderId
                        chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: builderId, receiverId: tradieId, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderId), otherUserUnreadCount: 0, jobId: self.jobId)
                        self.push(vc: chatVC)
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to fetch details")
                    }
                })
            })
        } else {
            if let popup: JobListPopup = loadCustomView() {
                popup.frame = view.frame
                view.addSubview(popup)
                popup.delegate = self
                popup.userId = jobDetail?.result?.postedBy?.builderId ?? ""
                popup.initialSetup()
                popup.popIn()
            }
        }
    }
    
    func goToQuoteListing() { 
        let vc = ViewQuoteVC.instantiate(fromAppStoryboard: .quotes)
        push(vc: vc)
    }
    
    func goToQuestionVC() {
        let vc = QuestionVC.instantiate(fromAppStoryboard: .search)
        let jobStatus = jobDetail?.result?.jobStatus ?? ""
        vc.jobId = jobId
        vc.tradeId = tradeId
        vc.specializationId = specialisationId
        vc.isPastJob = jobStatus == "expired" || jobStatus == "completed" || jobStatus == "cancelled"
        vc.builderName = jobDetail?.result?.postedBy?.builderName ?? ""
        vc.builderId = jobDetail?.result?.postedBy?.builderId ?? ""
        vc.jobName = jobDetail?.result?.jobName ?? ""
        vc.updateQuestionCountAction = { [weak self] count in
            self?.jobDetail?.result?.questionsCount = count
            self?.mainQueue { [weak self] in
                self?.tableViewOutlet.reloadSections(IndexSet(arrayLiteral: 5), with: .none)
            }
        }
        push(vc: vc)
    }
    
    func goToSuccessScreen() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = model.jobId.isEmpty ? .jobPosted : .republishJob
        push(vc: vc)
    }
    
    func goToCreateJobVC() {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        push(vc: vc)
    }
    
    func goToJobDetailsVC() {
        let vc = JobDescriptionVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        push(vc: vc)
    }
    
    func goToMilestoneListingVC() {
        let vc = MilestoneListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        push(vc: vc)
    }
    
    func goToAddMediaVC() {
        let vc = CreateJobUploadMediaVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        push(vc: vc)
    }
    
    func goToQuestionBuilderVC() {
        let vc = QuestionListingBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.jobId = self.jobDetail?.result?.jobId ?? ""
        self.push(vc: vc)
    }
}
