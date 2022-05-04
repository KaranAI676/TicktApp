//
//  BuilderProfile+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

import SwiftyJSON

extension BuilderProfileVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch cellArray[section] {
        case .detail:
            return CGFloat.leastNormalMagnitude
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch cellArray[section] {
        case .detail:
            return nil
        default:
            let headerView = tableView.dequeueHeaderFooter(with: SearchHeaderView.self)
            headerView.backView.backgroundColor = .white
            headerView.headerLabel.text = headerTitles[section]
            headerView.headerLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch cellArray[section] {
        case .jobs:
            if (profileModel?.result?.jobPostedData?.count ?? 0) > 2 {
                return 66
            }
        case .review:
            if (profileModel?.result?.reviewData?.count ?? 0) > 2 {
                return 66
            }
        default:
            return CGFloat.leastNormalMagnitude
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch cellArray[section] {
        case .jobs:
            if (profileModel?.result?.jobPostedData?.count ?? 0) > 2 {
                let footerView = tableView.dequeueHeaderFooter(with: ProfileFooterView.self)
                footerView.footerButton.setTitle("Show all \(profileModel?.result?.totalJobPostedCount ?? 0) jobs", for: .normal)
                footerView.buttonHandler = { [weak self] in
                    self?.showAllJobs()
                }
                return footerView
            }
        case .review:
            if (profileModel?.result?.reviewData?.count ?? 0) > 2 {
                let footerView = tableView.dequeueHeaderFooter(with: ProfileFooterView.self)
                footerView.footerButton.setTitle("Show all \(profileModel?.result?.reviewsCount ?? 0) reviews", for: .normal)
                footerView.buttonHandler = { [weak self] in
                    self?.showAllReviews()
                }
                return footerView
            }
        default:
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cellArray[indexPath.section] {
        case .portfolio:
            return (kScreenWidth - 68) / 3
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch cellArray[section] {
        case .jobs:
            let count = profileModel?.result?.jobPostedData?.count ?? 0
            if count > 2 {
                return 2
            } else {
                return count
            }
        case .review:
            let count = profileModel?.result?.reviewData?.count ?? 0
            if count > 2 {
                return 2
            } else {
                return count
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellArray[indexPath.section] {
        case .detail:
            let cell = tableView.dequeueCell(with: ProfileDetailCell.self)
            cell.profileDetail = profileModel?.result
            cell.messageButtonAction = { [weak self] in
                self?.goToMessageVC()
            }
            return cell
        case .area:
            let cell = tableView.dequeueCell(with: DynamicCollectionView.self)
            cell.extraCellSize = CGSize(width: 32, height: 10)
            cell.areasOfJob = profileModel?.result?.areasOfjobs
            cell.layoutIfNeeded()
            return cell
        case .about:
            let cell = tableView.dequeueCell(with: SingleLabelCell.self)
            cell.titleLabel.text = profileModel?.result?.aboutCompany ?? "N.A"
            return cell
        case .portfolio:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.photoUrlsModel = self.photosArray
            cell.layoutIfNeeded()
            cell.imageTapped = { [weak self] (_, index) in
                guard let self = self else { return }
                self.goToPortFolioDetailVC(index: index)
            }
            return cell
        case .jobs:
            let cell = profileTableView.dequeueCell(with: SearchListCell.self)
            cell.job = profileModel?.result?.jobPostedData![indexPath.row]
            return cell
        case .review:
            let cell = tableView.dequeueCell(with: ReviewCell.self)
            cell.review = profileModel?.result?.reviewData![indexPath.row]
            cell.replyButtonClosure = {}
            return cell
        }
    }
    
    func goToMessageVC() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is SingleChatVC }) {
            mainQueue { [weak self] in
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            if jobId.isEmpty {
                if let popup: JobListPopup = loadCustomView() {
                    popup.frame = view.frame
                    view.addSubview(popup)
                    popup.delegate = self
                    popup.userId = builderId
                    popup.initialSetup()
                    popup.popIn()
                }
            } else {
                let tradieId = kUserDefaults.getUserId()
                let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: self.builderId)
                ChatHelper.checkInboxExistsFor(jobId: self.jobId, otherUserId: self.builderId, userId: tradieId, completion: { (exists) in
                    var chatRoom: ChatRoom?
                    if !exists {
                        ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: self.builderId, unreadCount: 0, jobId: self.jobId, jobName: self.jobName)
                    }
                    ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                        [weak self] (room) in
                        guard let self = self else { return }
                        if room != nil, !(room?.chatRoomId.isEmpty)! {
                            chatRoom = room
                        } else {
                            chatRoom = ChatHelper.createRoom(jobId: self.jobId, tradieId: tradieId, builderId: self.builderId, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: self.builderId)])
                        }
                        
                        if self.emptyCheck(array: [tradieId, self.jobId, chatRoom?.chatRoomId ?? "", self.builderId, self.jobName]) {
                            let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                            chatVC.jobId = self.jobId
                            chatVC.tradieId = tradieId
                            chatVC.chatRoom = chatRoom!
                            chatVC.builderId = self.builderId
                            chatVC.jobName = self.jobName
                            chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: self.builderId, receiverId: tradieId, chatRoom: chatRoom!, chatMember: ChatMember(userId: self.builderId), otherUserUnreadCount: 0, jobId: self.jobId)
                            self.push(vc: chatVC)
                        } else {
                            CommonFunctions.showToastWithMessage("Failed to fetch details")
                        }
                    })
                })
            }
        }
    }
    
    func goToPortFolioDetailVC(index: IndexPath) {
        let vc = PortfolioDetailsBuilderVC.instantiate(fromAppStoryboard: .portfolioDetailsBuilder)
        var model = TradieProfilePortfolio()
        model.jobName = profileModel?.result?.portfolio?[index.row].jobName ?? ""
        model.portfolioId = profileModel?.result?.portfolio?[index.row].portfolioId ?? ""
        model.jobDescription = profileModel?.result?.portfolio?[index.row].jobDescription ?? ""
        model.portfolioImage = profileModel?.result?.portfolio?[index.row].portfolioImage ?? []
        vc.model = model
        push(vc: vc)
    }
    
    func showAllJobs() {
        let jobListVC = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        jobListVC.screenType = .allJobs
        jobListVC.allJobsCount = profileModel?.result?.totalJobPostedCount ?? 0
        jobListVC.builderId = builderId
        push(vc: jobListVC)
    }
    
    func showAllReviews() {
        let jobListVC = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
        jobListVC.screenType = .allReviews
        jobListVC.allReviewsCount = profileModel?.result?.reviewsCount ?? 0
        jobListVC.builderId = builderId
        push(vc: jobListVC)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellArray[indexPath.section] {
        case .jobs:
            let model = profileModel?.result?.jobPostedData![indexPath.row]
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            let status = model?.jobStatus ?? ""
            if status.isEmpty {
                jobDetailVC.screenType = .jobDetail
            } else {
                jobDetailVC.screenType = .activeJobDetail
            }
            jobDetailVC.jobId = model?.jobId ?? ""
            jobDetailVC.tradeId = model?.tradeId ?? ""
            jobDetailVC.specialisationId = model?.specializationId ?? ""
            push(vc: jobDetailVC)
        case .review:
            showAllReviews()
        default:
            break
        }
    }
}
