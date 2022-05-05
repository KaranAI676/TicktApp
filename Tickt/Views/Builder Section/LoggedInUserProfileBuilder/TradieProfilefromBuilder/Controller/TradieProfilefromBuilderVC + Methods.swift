//
//  TradieProfilefromBuilderVC + Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import SwiftyJSON

extension TradieProfilefromBuilderVC {
    
    func initialSetup() {
        viewModel.delegate = self
        setupTableView()
        hitApi()
    }
    
    func hitApi() {
        if loggedInBuilder {
            viewModel.getProfileInfo()
        } else {
            viewModel.getProfileHomeTradieData(tradieId: tradieId, jobId: jobId)
        }
    }
    
    private func setupTableView() {
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: ReviewsTableCell.self)
        tableViewOutlet.registerCell(with: VoucherTableCell.self)
        tableViewOutlet.registerCell(with: BottomButtonsTableCell.self)
        tableViewOutlet.registerCell(with: RatingProfileBlocksTableCell.self)
        tableViewOutlet.registerCell(with: TradieProfileInfoTableCell.self)
        tableViewOutlet.registerCell(with: DescriptionTableCell.self)
        tableViewOutlet.registerCell(with: ApplyJobCell.self)
        tableViewOutlet.registerCell(with: SearchListCell.self)
    }
    
    func goToNextVC(status: AcceptDecline) {
        func goToSourceVC() {
            if let vc = navigationController?.viewControllers.first(where: { $0 is NewApplicantsBuilderVC }) {
                NotificationCenter.default.post(name: NotificationName.refreshNewApplicant, object: nil, userInfo: nil)
                if status == .accept {
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                }
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                if status == .accept {
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                }
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                self.delegate?.getAcceptDeclineTradie(tradieId: self.tradieId, status: status)
                self.pop()
            }
        }
        
        if status == .accept {
            goToSourceVC()
        }
        
        if noOfTraidesCount > 1 {
            self.delegate?.getAcceptDeclineTradie(tradieId: self.tradieId, status: status)
            self.pop()
        } else {
            goToSourceVC()
        }
    }
    
    func goToPortFolioDetailVC(index: IndexPath) {
        let vc = PortfolioDetailsBuilderVC.instantiate(fromAppStoryboard: .portfolioDetailsBuilder)
        if loggedInBuilder, let data = loggedInBuilderModel?.result.portfolio[index.row] {
            vc.model = TradieProfilePortfolio(data)
        } else {
            vc.model = self.tradieModel?.result.portfolio[index.row]
        }
        push(vc: vc)
    }
    
    func goToShowAllReviewVC() {
        let vc = QuestionListingBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.tradieId = loggedInBuilder ? (loggedInBuilderModel?.result.builderId ?? "") : tradieId
        vc.newtradieId = tradieId
        vc.newbuilderId = loggedInBuilderModel?.result.builderId ?? ""
        vc.delegate = self
        vc.screenType = loggedInBuilder ? .reviewReply : .review
        push(vc: vc)
    }

    func showAllReviews() {
        let jobListVC = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        jobListVC.screenType = .allReviews
        jobListVC.allReviewsCount = tradieModel?.result.reviewsCount ?? 0
        jobListVC.isMyProfile = true
        jobListVC.builderId = kUserDefaults.getUserId()
        push(vc: jobListVC)
    }
    
    func goToShowAllJobs() {
        let jobListVC = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        jobListVC.screenType = .loggedInBuilder
        jobListVC.allJobsCount = loggedInBuilderModel?.result.jobCount ?? 0
        jobListVC.allJobsCount = loggedInBuilderModel?.result.totalJobPostedCount ?? 0
        jobListVC.builderId = loggedInBuilderModel?.result.builderId ?? ""
        push(vc: jobListVC)
    }
    
    func goToShowAllVouchVC() {
        let vc = VouchesLisitngBuilderVC.instantiate(fromAppStoryboard: .vouchesBuilder)
        vc.tradieId = tradieId
        vc.delegate = self
        push(vc: vc)
    }
    
    func goToChooseJobVC() {
        let vc = JobListingBuilderVC.instantiate(fromAppStoryboard: .jobListingBuilder)
        vc.tradieId = tradieId
//        vc.screenType = (tradieModel?.result.isInvited ?? false) ? .forCancelInvite : .forInvite
        vc.screenType = .forInvite
        vc.delegate = self
        push(vc: vc)
    }
    
    func goToMessageVC() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is SingleChatVC }) {
            mainQueue { [weak self] in
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else if isOpenJob || jobId.isEmpty {
            if let popup: JobListPopup = loadCustomView() {
                popup.frame = view.frame
                view.addSubview(popup)
                popup.delegate = self
                popup.userId = tradieModel?.result.tradieId ?? ""
                popup.initialSetup()
                popup.popIn()
            }
        } else {
            if let vc = navigationController?.viewControllers.first(where: { $0 is SingleChatVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                let tradieId = tradieModel?.result.tradieId ?? ""
                let builderIds = kUserDefaults.getUserId()
                let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderIds)

                ChatHelper.checkInboxExistsFor(jobId: self.jobId, otherUserId: builderIds, userId: tradieId, completion: { (exists) in
                    var chatRoom: ChatRoom?
                    if !exists {
                        ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: builderIds, unreadCount: 0, jobId: self.jobId, jobName: self.jobName)
                    }
                    ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                          [weak self] (room) in
                        guard let self = self else { return }
                        if room != nil, !(room?.chatRoomId.isEmpty)! {
                            chatRoom = room
                        } else {
                            chatRoom = ChatHelper.createRoom(jobId: self.jobId, tradieId: tradieId, builderId: builderIds, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: builderIds)])                            
                        }
                        if self.emptyCheck(array: [tradieId, self.jobId, chatRoom?.chatRoomId ?? "", builderIds, self.jobName]) {
                            let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                            chatVC.tradieId = tradieId
                            chatVC.jobId = self.jobId
                            chatVC.chatRoom = chatRoom!
                            chatVC.builderId = builderIds
                            chatVC.jobName = self.jobName
                            chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: builderIds, receiverId: tradieId, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderIds), otherUserUnreadCount: 0, jobId: self.jobId)
                            self.push(vc: chatVC)
                        } else {
                            CommonFunctions.showToastWithMessage("Failed to fetch details")
                        }
                    })
                })
            }
        }
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
    
    func goToLeaveVouch() {
        let vc = LeaveVouchBuilderVC.instantiate(fromAppStoryboard: .vouchesBuilder)
        vc.tradieId = tradieId
        vc.delegate = self
        push(vc: vc)
    }
    
    func goToEditableOptionVC() {
        let vc = EditableOptionBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        vc.loggedInBuilderModel = loggedInBuilderModel
        push(vc: vc)
    }
    
    func goToDetailVC(_ jobId: String, screenType: ScreenType, status: String, republishModel: RepublishJobResult? = nil) {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = screenType
        vc.jobId = jobId
        vc.pastJobStatus = status
        vc.republishModel = republishModel
        self.push(vc: vc)
    }
    
    func getTradieObject(model: TradieProfileResult) -> SavedTradies {
        var tradeData = [BuilderHomeTradeData]()
        if let tradeObject = model.areasOfSpecialization.tradeData.first {
            tradeData = [BuilderHomeTradeData(tradeObject)]
        }
        
        let specialisationData: [BuilderHomeSpecialisation] = model.areasOfSpecialization.specializationData.map({ eachModel -> BuilderHomeSpecialisation in
            return BuilderHomeSpecialisation(name: eachModel.specializationName, id: eachModel.specializationId)
        })

        return SavedTradies(tradieId: model.tradieId ?? "", tradieImage: model.tradieImage ?? "", tradieName: model.tradieName, businessName: model.businessName ?? "", ratings: model.ratings, reviews: model.reviewsCount, tradeData: tradeData, specializationData: specialisationData)
    }
    
    func previewDoc(_ url: String) {
        if url.isValidUrl(url) {
            let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
            vc.comingFromLocal = false
            vc.url = url
            push(vc: vc)
        } else {
            CommonFunctions.showToastWithMessage("Error while loading...")
        }
    }
}

extension TradieProfilefromBuilderVC {
    
    func getSectionArray() -> [SectionArray] {
        guard let model = self.tradieModel?.result else { return [] }
        
        var sectionArray: [SectionArray] = [.tradieInfo, .ratingblocks]
        
        if !model.about.isEmpty {
            sectionArray.append(.about)
        }
        
        if !model.portfolio.isEmpty {
            sectionArray.append(.portfolio)
        }
        
        if !model.areasOfSpecialization.specializationData.isEmpty {
            sectionArray.append(.specialisation)
        }
        
        if !model.reviewData.isEmpty {
            sectionArray.append(.reviews)
        }
        
        if model.reviewData.count > maxReviewCanDisplay {
            sectionArray.append(.showAllReviews)
        }
        
        if !model.vouchesData.isEmpty {
            sectionArray.append(.vouchers)
        }
        
        if model.vouchesData.count > maxVouchCanDisplay {
            sectionArray.append(.showAllVouchers)
        } else {
            if !kUserDefaults.isTradie() {
                sectionArray.append(.leaveVouch)
            }
        }
        
        if !kUserDefaults.isTradie() {
            if model.isRequested ?? false {
                isOpenJob = true
                sectionArray.append(.bottomButtons)
            } else if showSaveUnsaveButton {//} || (model.isInvited ?? false) {
                sectionArray.append(.invite)
            }
        }
        self.sectionArray = sectionArray
        return sectionArray
    }
    
    func getBuilderSectionArray() -> [SectionArray] {
        
        guard let model = loggedInBuilderModel?.result else { return [] }
        
        var sectionArray: [SectionArray] = [.tradieInfo, .ratingblocks]
        
        if !((model.aboutCompany ?? "").isEmpty) {
            sectionArray.append(.about)
        }
        
        if !model.portfolio.isEmpty {
            sectionArray.append(.portfolio)
        }
        
//        if !(model.areasOfSpecialization.specializationData.isEmpty || model.areasOfSpecialization.tradeData.isEmpty) {
//            sectionArray.append(.specialisation)
//        } //B77
        
        
        if !model.jobPostedData.isEmpty {
            sectionArray.append(.jobPosted)
        }
        
        if model.totalJobPostedCount > maxJobsCanDisplay {
            sectionArray.append(.showAllJobs)
        }
        
        if !model.reviewData.isEmpty {
            sectionArray.append(.reviews)
        }
        
        if model.reviewData.count > 1 {
            sectionArray.append(.showAllReviews)
        }
        
        self.sectionArray = sectionArray
        return sectionArray
    }
}
