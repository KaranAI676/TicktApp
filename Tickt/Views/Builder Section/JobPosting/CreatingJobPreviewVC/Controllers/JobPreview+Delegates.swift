//
//  JobPreview+Delegates.swift
//  Tickt
//
//  Created by Admin on 05/05/21.
//

import UIKit

extension CreatingJobPreviewVC: CreatingJobPreviewVMDelegate, JobChatDelegate, SubmitQuoteDelegate {
    
    func didQuoteSubmitted() {
        jobDetail?.result?.alreadyApplyQuote = true
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
        didJobApplied()
    }
    
    func didQuoteAccepted() {
        jobDetail?.result?.alreadyApplyQuote = true
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
        didJobAcceptedRejected(isReject: true)
    }
    
    func didAcceptCancelChangeRequest(status: AcceptDecline) {
        if status == .accept {
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                NotificationCenter.default.post(name: NotificationName.refreshActiveList, object: nil, userInfo: nil)
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            }
        } else {
            jobDetail?.result?.reasonForCancelJobRequest = 0
            jobDetail?.result?.reasonNoteForCancelJobRequest = ""
            jobDetail?.result?.isCancelJobRequest = false
            if let model = jobDetail {
                didGetJobDetail(model: model)
            }
        }
    }
            
    func didAcceptRejectChangeRequest() {
        jobDetail?.result?.isChangeRequest = false
        cellsArray.remove(object: .changeRequest)
        tableViewOutlet.reloadData()
        changeRequestClosure?()
    }
        
    func didJobAcceptedRejected(isReject: Bool) { //Remove the job from New job Screen
        if !isReject {
            jobDetail?.result?.isInvited = false
            jobDetail?.result?.appliedStatus = "Apply"
            cellsArray.append(.applyJob)
        }
        cellsArray.remove(object: .inviteAccept)
        tableViewOutlet.reloadData()
        inviteAcceptDeclineClosure?()
    }
    
    func didJobApplied() {
        let successVC = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        successVC.screenType = .jobApplied
        push(vc: successVC)
    }
    
    func didJobSaved(status: Bool) {
        bookmarkButton.isSelected = !status
        jobDetail?.result?.isSaved = !status
        if let cell = tableViewOutlet.cellForRow(at: IndexPath(row: 0, section: 9)) as? ApplyJobCell { 
            cell.isJobSaved = !status
            cell.bookmarkButton.isSelected = !status
            cell.layoutIfNeeded()
        }
    }
            
    func success() {
        if let jobData = kAppDelegate.postJobModel {
            NotificationCenter.default.post(name: NotificationName.newJobCreated, object: nil, userInfo: ["model": JobListingBuilderResult(jobData)])
        }
        kAppDelegate.postJobModel = nil
        kAppDelegate.datesDict = [:]
        goToSuccessScreen()
    }
    
    func didGetJobDetail(model: JobDetailsModel) {
        if screenType == .activeJobDetail {
            cellsArray = [.category, .gridCell, .jobType, .specialisation, .details, .question, .milestones, .photos, .postedBy]
        } else {
            cellsArray = [.category, .gridCell, .jobType, .specialisation, .details, .question, .milestones, .photos, .postedBy, .applyJob]
        }
        
        refreshControl.endRefreshing()
        jobDetail = model
        tradeId = model.result?.tradeId ?? ""
        // Insert View Quote button
        if (model.result?.quoteJob ?? false) && screenType == .activeJobDetail {
            cellsArray.insert(.viewQuotes, at: 7)
        }
        
        //To remove Apply job cell if job expired/cancelled,completed
        let jobStatus = model.result?.jobStatus ?? ""
        
        //To show invite cell
        if model.result?.isInvited ?? false {
            if !cellsArray.contains(.inviteAccept) {
                cellsArray.append(.inviteAccept)
                cellsArray.remove(object: .applyJob)
            }
        } else {
            cellsArray.remove(object: .inviteAccept)
        }
        
        //Check weather apply button need to show
        if jobDetail?.result?.applyButtonDisplay ?? false {
            if !cellsArray.contains(.applyJob) , !cellsArray.contains(.inviteAccept) {
                cellsArray.append(.applyJob)
            }
        } else if (model.result?.appliedStatus ?? "").lowercased() != "applied".lowercased() {
            if cellsArray.contains(.applyJob) {
                cellsArray.remove(object: .applyJob)
            }
        } else {
            if !cellsArray.contains(.applyJob) {
                cellsArray.remove(object: .applyJob)
            }
        }

        //To show change request cell        
        let isChangeRequest = model.result?.isChangeRequest ?? false
        let reasonNoteForChangeRequest = model.result?.reasonForChangeRequest ?? []
        
        if isChangeRequest, !(jobStatus.lowercased() == "expired".lowercased() || jobStatus.lowercased() == "completed".lowercased() || jobStatus.lowercased() == "cancelled".lowercased() || jobStatus.lowercased() == "cancelledApply".lowercased()) { //Show reason with button
            if !cellsArray.contains(.changeRequest) {
                cellsArray.insert(.changeRequest, at: 0)
            }
        } else if jobStatus.lowercased() == JobStatus.active.rawValue, reasonNoteForChangeRequest.count > 0 { //Only Show reason
            if !cellsArray.contains(.changeRequest) {
                cellsArray.insert(.changeRequest, at: 0)
            }
        } else {
            if cellsArray.contains(.changeRequest) {
                cellsArray.remove(object: .changeRequest)
            }
        }
        
        //To show Cancel request cell
        let isCancelRequest = model.result?.isCancelJobRequest ?? false
        let selectedReason = model.result?.reasonForCancelJobRequest ?? 0
        let rejectReasonForCancelRequest = model.result?.rejectReasonNoteForCancelJobRequest ?? ""
            
        if isCancelRequest, !(jobStatus.lowercased() == "expired" || jobStatus.lowercased() == "completed" || jobStatus.lowercased() == "cancelled" || jobStatus.lowercased() == "cancelledapply") { //Show reason with button
            if !cellsArray.contains(.cancelRequest) {
                cellsArray.insert(.cancelRequest, at: 0)
            }
        } else if !rejectReasonForCancelRequest.isEmpty { //Only Show reason
            if !cellsArray.contains(.cancelRequest) {
                cellsArray.insert(.cancelRequest, at: 0)
            }
        } else if selectedReason != 0 { //Only Show reason //Workarround Remember
            if !cellsArray.contains(.cancelRequest) {
                cellsArray.insert(.cancelRequest, at: 0)
            }
        } else {
            if cellsArray.contains(.cancelRequest) {
                cellsArray.remove(object: .cancelRequest)
            }
        }
        
        //To show Bookmark button at top
        bookmarkButton.isSelected = jobDetail?.result?.isSaved ?? false
        if jobStatus.lowercased() == "expired".lowercased() || jobStatus.lowercased() == "completed".lowercased() || jobStatus.lowercased() == "cancelledApply".lowercased() || jobStatus.lowercased() == "active".lowercased() || jobStatus.lowercased() == "cancelled".lowercased() {
            if cellsArray.contains(.applyJob) {
                cellsArray.remove(object: .applyJob)
            }
        } else {
            
        }
                        
        bookmarkButton.isHidden = false //cellsArray.contains(.applyJob)
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData {
                CommonFunctions.delay(delay: 0.3, closure: {
                    self?.tableViewOutlet.reloadData()
                })
            }
        }
    }

    func openJobDetails(model: JobDetailsModel) {
        refreshControl.endRefreshing()
        jobDetail = model
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func failure(error: String) {
        refreshControl.endRefreshing()
        CommonFunctions.showToastWithMessage(error)
    }
    
    func didJobSelected(jobDetail: JobListData) {
        openMessageDetail(jobDetail: jobDetail)
    }
    
    func openMessageDetail(jobDetail: JobListData) {
        let jobId = jobDetail.id?.jobId ?? ""
        let tradieId = jobDetail.id?.tradieId ?? ""
        let builderIds = jobDetail.id?.builderId ?? ""
        let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderIds)

        ChatHelper.checkInboxExistsFor(jobId: jobId, otherUserId: builderIds, userId: tradieId, completion: { (exists) in
            var chatRoom: ChatRoom?
            if !exists {
                ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: builderIds, unreadCount: 0, jobId: jobId, jobName: jobDetail.jobData?.jobName ?? "")
            }
            ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                  [weak self] (room) in
                guard let self = self else { return }
                if room != nil, !(room?.chatRoomId.isEmpty)! {
                    chatRoom = room
                } else {
                    chatRoom = ChatHelper.createRoom(jobId: jobId, tradieId: tradieId, builderId: builderIds, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: builderIds)])
                }
                if self.emptyCheck(array: [tradieId, jobId, chatRoom?.chatRoomId ?? "", builderIds, jobDetail.jobData?.jobName ?? ""]) {
                    let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                    chatVC.tradieId = tradieId
                    chatVC.jobId = jobId
                    chatVC.chatRoom = chatRoom!
                    chatVC.builderId = builderIds
                    chatVC.jobName = jobDetail.jobData?.jobName ?? ""
                    chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: builderIds, receiverId: tradieId, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderIds), otherUserUnreadCount: 0, jobId: jobId)
                    self.push(vc: chatVC)
                } else {
                    CommonFunctions.showToastWithMessage("Failed to fetch details")
                }
            })
        })
    }
}
