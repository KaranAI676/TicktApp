//
//  BuilderProfile+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

import Foundation

extension BuilderProfileVC: BuilderProfileDelegate {
    func didGetProfile(model: ProfileModel) {
        refreshControl.endRefreshing()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileModel = model
        cellArray = [.detail, .area]
        headerTitles = ["", "Areas of Jobs"]
        let aboutCompany = model.result?.aboutCompany ?? ""
        if !aboutCompany.isEmpty {
            cellArray.append(.about)
            headerTitles.append("About")
        }
        
        if (model.result?.portfolio?.count ?? 0) > 0 {
            cellArray.append(.portfolio)
            let photosArray = model.result?.portfolio?.map({ eachModel -> String in
                return eachModel.portfolioImage?.first ?? ""
            })
            self.photosArray = photosArray
            headerTitles.append("Portfolio (\(profileModel?.result?.portfolio?.count ?? 0) jobs)")
        }
        if (model.result?.totalJobPostedCount ?? 0) > 0 {
            cellArray.append(.jobs)
            headerTitles.append("Job posted")
        }
        if (model.result?.reviewsCount ?? 0) > 0 {
            cellArray.append(.review)
            headerTitles.append("Review")
        }
        
        mainQueue { [weak self] in
            self?.profileTableView.reloadData { [weak self] in
                self?.profileTableView.reloadData()
            }
        }
    }
    
    func failure(error: String) {
        refreshControl.endRefreshing()
    }
}

extension BuilderProfileVC: JobChatDelegate {
    func didJobSelected(jobDetail: JobListData) {
        
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
                    chatVC.jobId = jobId
                    chatVC.tradieId = tradieId
                    chatVC.chatRoom = chatRoom!
                    chatVC.builderId = builderIds
                    chatVC.jobName = jobDetail.jobData?.jobName ?? ""
                    chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: tradieId, receiverId: builderIds, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderIds), otherUserUnreadCount: 0, jobId: jobId)
                    self.push(vc: chatVC)
                } else {
                    CommonFunctions.showToastWithMessage("Failed to fetch details")
                }
            })
        })
    }
}
