//
//  JobListing+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

extension JobListingVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if screenType == .allReviews {
            return viewModel.reviewModel?.result?.list?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenType {
        case .newJob, .savedjobs:
            return viewModel.jobModel?.result?.count ?? 0
        case .allJobs, .loggedInBuilder:
            return viewModel.jobModel?.result?.count ?? 0
        case .allReviews:
            if viewModel.reviewModel?.result?.list?[section].reviewData?.replyData.replyId != nil {
                if viewModel.reviewModel?.result?.list?[section].reviewData?.isReviewVisible ?? false {
                    return 1
                } else {
                    return 0
                }
            } else {
                return 0
            }
        case .newMilestone:
            return viewModel.milestoneModel?.result?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if screenType == .allReviews {
            let headerView = tableView.dequeueHeaderFooter(with: ReviewHeaderView.self)
            viewModel.hitPagination(index: section, screenType: screenType)
            let reviewData = viewModel.reviewModel?.result?.list?[section].reviewData
            headerView.allReviewData = reviewData
            if reviewData?.isModifiable ?? false {
                headerView.stackViewHeightConstraint.constant = 40
            } else {
                headerView.stackViewHeightConstraint.constant = 0
            }
            
            if viewModel.reviewModel?.result?.list?[section].reviewData?.replyData.replyId != nil {
                headerView.replyButtonHeightConstraint.constant = 40
                if viewModel.reviewModel?.result?.list?[section].reviewData?.isReviewVisible ?? false {
                    headerView.replyButton.setTitle("Hide reply", for: .normal)
                } else {
                    headerView.replyButton.setTitle("Show reply", for: .normal)
                }
            } else {
                if isMyProfile {
                    headerView.replyButtonHeightConstraint.constant = 40
                    headerView.replyButton.setTitle("Reply", for: .normal)
                } else {
                    headerView.replyButtonHeightConstraint.constant = 0
                    headerView.replyButton.setTitle("", for: .normal)
                }
            }
            
            headerView.replyButtonAction = { [weak self] in
                let labelText = headerView.replyButton.titleLabel?.text ?? ""
                switch labelText {
                case "Reply":
                    self?.replyReview(isEdit: false, index: section)
                case "Hide reply":
                    self?.showHideReview(isShow: false, section: section)
                case "Show reply":
                    self?.showHideReview(isShow: true, section: section)
                default:
                    break
                }
            }
            
            headerView.editButtonAction = { [weak self] in
                self?.replyReviewHeaderView(isEdit: true, index: section)
            }
            
            headerView.deleteButtonAction = { [weak self] in
                self?.showAlertForDeleteHeaderView(index: section)
            }
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if screenType == .allReviews {
            return UITableView.automaticDimension
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func showHideReview(isShow: Bool, section: Int) {
        viewModel.reviewModel?.result?.list?[section].reviewData?.isReviewVisible = isShow
        jobTableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
    }
    
    func replyReviewHeaderView(isEdit: Bool, index: Int) {
        let replyVC = ReplyReviewVC.instantiate(fromAppStoryboard: .jobDashboard)
        replyVC.isEdit = isEdit
        replyVC.isOtherProfileReview = !isMyProfile
        replyVC.builderId = builderId
        replyVC.jobId = viewModel.reviewModel?.result?.list?[index].reviewData?.jobId ?? ""
        replyVC.rating = viewModel.reviewModel?.result?.list?[index].reviewData?.rating ?? 1
        replyVC.review = viewModel.reviewModel?.result?.list?[index].reviewData?.review ?? ""
        replyVC.reviewId = viewModel.reviewModel?.result?.list?[index].reviewData?.reviewId ?? ""
        replyVC.updateReviewReplyHeader = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getBuildersReviews(showLoader: false, isPullToRefresh: true, builderId: self.builderId)
        }
        push(vc: replyVC)
    }
    
    func replyReview(isEdit: Bool, index: Int) {
        let replyVC = ReplyReviewVC.instantiate(fromAppStoryboard: .jobDashboard)
        replyVC.isEdit = isEdit
        replyVC.reviewId = viewModel.reviewModel?.result?.list?[index].reviewData?.reviewId ?? ""
        replyVC.review = viewModel.reviewModel?.result?.list?[index].reviewData?.replyData.reply ?? ""
        replyVC.replyId = viewModel.reviewModel?.result?.list?[index].reviewData?.replyData.replyId ?? ""
        replyVC.updateReviewReply = { [weak self] replyData in
            guard let self = self else { return }
            if let id = replyData.id, let firstIndex = self.viewModel.reviewModel?.result?.list?.firstIndex( where: {$0.reviewData?.replyData.reviewId == id}) {
                self.viewModel.reviewModel?.result?.list?[firstIndex].reviewData?.replyData.replyId = replyData.comments?.first?.id ?? ""
                self.viewModel.reviewModel?.result?.list?[firstIndex].reviewData?.replyData.reply = replyData.comments?.first?.comment ?? ""
                self.viewModel.reviewModel?.result?.list?[firstIndex].reviewData?.isReviewVisible = true
                self.jobTableView.reloadData()
            } else if !isEdit {
                self.viewModel.reviewModel?.result?.list?[index].reviewData?.replyData = ReplyData(userImage: replyData.userImage, reply: replyData.reply, date: replyData.date, reviewId: replyData.reviewId, replyId: replyData.replyId, name: replyData.name, isModifiable: true)
                self.viewModel.reviewModel?.result?.list?[index].reviewData?.isReviewVisible = true
                self.jobTableView.reloadData()
            }
        }
        push(vc: replyVC)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch screenType {
        case .newJob, .savedjobs:
            let cell = tableView.dequeueCell(with: SearchListCell.self)
            viewModel.hitPagination(index: indexPath.row, screenType: screenType)
            cell.job = viewModel.jobModel?.result?[indexPath.row]
            return cell
        case .allJobs:
            let cell = tableView.dequeueCell(with: SearchListCell.self)
            viewModel.hitPagination(index: indexPath.row, screenType: screenType)
            cell.job = viewModel.jobModel?.result?[indexPath.row]
            return cell
        case .loggedInBuilder:
            let cell = tableView.dequeueCell(with: SearchListCell.self)
            viewModel.hitPagination(index: indexPath.row, screenType: screenType)
            cell.job = viewModel.jobModel?.result?[indexPath.row]
            return cell
        case .allReviews:
            let cell = tableView.dequeueCell(with: ReviewReplyCell.self)
            cell.replyData = viewModel.reviewModel?.result?.list?[indexPath.section].reviewData?.replyData
            cell.editButtonAction = { [weak self] in
                self?.replyReview(isEdit: true, index: indexPath.section)
            }
            cell.deleteButtonAction = { [weak self] in
                self?.showAlertForDelete(index: indexPath.section)
            }
            return cell
        case .newMilestone:
            let cell = tableView.dequeueCell(with: JobStatusCell.self)
            viewModel.hitPagination(index: indexPath.row, screenType: screenType)
            cell.approvedMilestone = viewModel.milestoneModel?.result?[indexPath.row]
            return cell
        }
    }

    func showAlertForDeleteHeaderView(index: Int) {
        
        AppRouter.showAppAlertWithCompletion(vc: nil, alertType: .bothButton,
                                             alertTitle: "Delete Reply",
                                             alertMessage: "Are you sure you want to delete this reply?",
                                             acceptButtonTitle: "Yes",
                                             declineButtonTitle: "No") { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteReplyHeaderView(reviewId: self.viewModel.reviewModel?.result?.list?[index].reviewData?.reviewId ?? "", index: index)
        } dismissCompletion: { }
        
    }
    
    func showAlertForDelete(index: Int) {
        
        AppRouter.showAppAlertWithCompletion(vc: nil, alertType: .bothButton,
                                             alertTitle: "Delete Reply",
                                             alertMessage: "Are you sure you want to delete this reply?",
                                             acceptButtonTitle: "Yes",
                                             declineButtonTitle: "No") { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteReply(reviewId: self.viewModel.reviewModel?.result?.list?[index].reviewData?.reviewId ?? "", replyId: self.viewModel.reviewModel?.result?.list?[index].reviewData?.replyData.replyId ?? "", index: index)
        } dismissCompletion: { }        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch screenType {
        case .newJob, .allJobs, .savedjobs:
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            let model = viewModel.jobModel?.result![indexPath.row]
            let status = model?.jobStatus ?? ""
            if status.isEmpty {
                jobDetailVC.screenType = .jobDetail
            } else {
                jobDetailVC.screenType = .activeJobDetail
            }
            jobDetailVC.jobId = model?.jobId ?? ""
            jobDetailVC.tradeId = model?.tradeId ?? ""
            jobDetailVC.specialisationId = model?.specializationId ?? ""
            if screenType == .newJob {
                jobDetailVC.inviteAcceptDeclineClosure = { [weak self] in
                    self?.viewModel.jobModel?.result?.remove(at: indexPath.row)
                    self?.jobTableView.reloadData()
                }
            }
            push(vc: jobDetailVC)
        case .loggedInBuilder:
            
            let model = viewModel.jobModel?.result?[indexPath.row]
            if let jobId = model?.jobId,
               let jobStatus = model?.jobStatus?.uppercased(),
               let status = JobStatus.init(rawValue: jobStatus) {
                let screenType = CommonFunctions.getScreenTypeFromJobStatus(status)
                if status == .expired {
                    viewModel.getRepublishJobDetails(jobId: jobId, status: status.rawValue)
                } else {
                    goToDetailVC(jobId, screenType: screenType, status: status.rawValue)
                }
            }
        case .allReviews:
            break
        case .newMilestone:
            let milestoneVC = MilestoneVC.instantiate(fromAppStoryboard: .jobDashboard)
            milestoneVC.jobId = viewModel.milestoneModel?.result![indexPath.row].jobId ?? ""
            let data = viewModel.milestoneModel?.result![indexPath.row]
            TicketMoengage.shared.postEvent(eventType: .viewedApprovedMilestone(category: data?.tradeName ?? "", timestamp: "", milestoneNumber: data?.milestoneNumber ?? 0))
            push(vc: milestoneVC)
        }
    }
}
