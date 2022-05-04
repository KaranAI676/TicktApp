//
//  TradieProfilefromBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

extension TradieProfilefromBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return loggedInBuilder ? getBuilderSectionArray().count : getSectionArray().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .tradieInfo, .ratingblocks, .specialisation, .about, .bottomButtons, .portfolio, .invite, .saveChanges, .leaveVouch:
            return 1
        case .reviews:
            let count = loggedInBuilder ? loggedInBuilderModel?.result.reviewData.count ?? 0 : self.tradieModel?.result.reviewData.count ?? 0
            return count < maxReviewCanDisplay ? count : maxReviewCanDisplay
        case .jobPosted:
            let count = loggedInBuilderModel?.result.jobPostedData.count ?? 0
            return count <= maxVouchCanDisplay ? count : maxVouchCanDisplay
        case .showAllReviews:
            return 1
        case .vouchers:
            let count = self.tradieModel?.result.vouchesData.count ?? 0
            return count < maxVouchCanDisplay ? count : maxVouchCanDisplay
        case .showAllVouchers:
            return 1
        case .showAllJobs:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .tradieInfo:
            let cell = tableView.dequeueCell(with: TradieProfileInfoTableCell.self)
            if loggedInBuilder {
                cell.loggedInModel = loggedInBuilderModel?.result
            } else {
                cell.model = self.tradieModel?.result
                if kUserDefaults.isTradie() {
                    cell.messageButton.isHidden = true
                } else {
                    cell.messageButton.isHidden = false
                }
            }
            cell.messageButtonClosure = { [weak self] in                
                self?.goToMessageVC()
            }
            return cell
        case .ratingblocks:
            let cell = tableView.dequeueCell(with: RatingProfileBlocksTableCell.self)
            loggedInBuilder ? (cell.loggedInBuilder = loggedInBuilderModel?.result) : (cell.model = self.tradieModel?.result)
            return cell
        case .reviews:
            let cell = tableView.dequeueCell(with: ReviewsTableCell.self)
            cell.reviewModel = loggedInBuilder ? (loggedInBuilderModel?.result.reviewData[indexPath.row]) : (self.tradieModel?.result.reviewData[indexPath.row])
            return cell
        case .showAllReviews:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.topConstraint.constant = 5
            if loggedInBuilder {
                cell.secondButton.setTitleForAllMode(title: "Show all \(loggedInBuilderModel?.result.reviewsCount ?? 0) reviews")
            } else {
                cell.secondButton.setTitleForAllMode(title: "Show all \(self.tradieModel?.result.reviewsCount ?? 0) reviews")
            }
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                if type == .secondButton {
                    if kUserDefaults.isTradie() {
                        self.showAllReviews()
                    } else {
                        self.goToShowAllReviewVC()
                    }
                }
            }
            return cell
        case .vouchers:
            let cell = tableView.dequeueCell(with: VoucherTableCell.self)
            cell.tableView = tableView
            cell.vouchesData = tradieModel?.result.vouchesData[indexPath.row]
            ///
            cell.openRecommendedClosure = { [weak self] index in
                guard let self = self else { return }
                self.previewDoc(self.tradieModel?.result.vouchesData[index.row].recommendation ?? "")
            }
            return cell
        case .showAllVouchers:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.topConstraint.constant = 5
            cell.secondButton.setTitleForAllMode(title: "Show all \(self.tradieModel?.result.voucherCount ?? 0) vouches")
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                if type == .secondButton {
                    self.goToShowAllVouchVC()
                }
            }
            return cell
        case .leaveVouch:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.topConstraint.constant = 2
            cell.secondButton.setTitleForAllMode(title: "Leave vouch")
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                if type == .secondButton {
                    self.goToLeaveVouch()
                }
            }
            return cell
        case .specialisation:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            loggedInBuilder ? (cell.loggedIntModel = loggedInBuilderModel?.result) : (cell.model = self.tradieModel?.result)
            cell.layoutIfNeeded()
            return cell
        case .portfolio:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.fromProfileShow = true
            cell.limitedShows = self.limitedShow
            cell.collectionViewOutlet.reloadData()
            cell.photoUrlsModel = self.photosArray
            cell.layoutIfNeeded()
            cell.imageTapped = { [weak self] (_, index) in
                guard let self = self else { return }
                self.goToPortFolioDetailVC(index: index)
            }
            return cell
        case .about:
            let cell = tableView.dequeueCell(with: DescriptionTableCell.self)
            cell.descriptionText = loggedInBuilder ? loggedInBuilderModel?.result.aboutCompany ?? "" : self.tradieModel?.result.about ?? ""
            cell.descriptionLabel.numberOfLines = showMoreContent ? 0 : 3
            return cell
        case .jobPosted:
            let cell = tableView.dequeueCell(with: SearchListCell.self)
            cell.loggedInModel = loggedInBuilderModel?.result.jobPostedData[indexPath.row]
            return cell
        case .showAllJobs:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.topConstraint.constant = 5
            cell.secondButton.setTitleForAllMode(title: "Show all \(loggedInBuilderModel?.result.totalJobPostedCount ?? 0) jobs")
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                if type == .secondButton {
                    self.goToShowAllJobs()
                }
            }
            return cell
        case .bottomButtons:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            ///
            cell.firstButton.setTitleForAllMode(title: "Accept")
            cell.secondButton.setTitleForAllMode(title: "Decline")
            ///
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                switch type {
                case .firstButton:
                    self.viewModel.acceptDecline(jobId: self.jobId, tradieId: self.tradieId, status: .accept)
                case .secondButton:
                    self.viewModel.acceptDecline(jobId: self.jobId, tradieId: self.tradieId, status: .decline)
                }
            }
            return cell
        case .invite:
            let cell = tableView.dequeueCell(with: ApplyJobCell.self)
            guard let model = self.tradieModel?.result else { return UITableViewCell() }
            cell.bookmarkButton.isSelected = model.isSaved ?? false
            let title = (model.isInvited ?? false) && !(model.invitationId ?? "").isEmpty ? "Cancel Invitation" : "Invite for job"
            //            let title = "Invite for job"
            cell.applyButton.setTitleForAllMode(title: title)
            ///
            cell.bookmarkButtonClosure = { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.saveUnsaveTradie(tradieId: self.tradieId, bool: !(model.isSaved ?? false))
            }
            cell.applyButtonClosure = { [weak self] in
                guard let self = self else { return }
                if (model.isInvited ?? false), !(model.invitationId ?? "").isEmpty {
                    self.viewModel.cancelInvite(tradieId: self.tradieId, jobId: self.jobId, invitationId: model.invitationId ?? "")
                } else {
                    self.goToChooseJobVC()
                }
            }
            return cell
            
        case .saveChanges:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = true
            cell.firstButton.setTitleForAllMode(title: "Save changes")
            cell.buttonClosure = { (type) in                
                tableView.reloadData()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section] {
        case .jobPosted:
            if let jobId = loggedInBuilderModel?.result.jobPostedData[indexPath.row].jobId,
               let jobStatus = loggedInBuilderModel?.result.jobPostedData[indexPath.row].jobStatus?.uppercased(),
               let status = JobStatus.init(rawValue: jobStatus) {
                let screenType = CommonFunctions.getScreenTypeFromJobStatus(status)
                if status == .expired {
                    viewModel.getRepublishJobDetails(jobId: jobId, status: status.rawValue)
                }else {
                    goToDetailVC(jobId, screenType: screenType, status: status.rawValue)
                }
            }
        case .reviews:
            if kUserDefaults.isTradie() {
                showAllReviews()
            } else {
                goToShowAllReviewVC()
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        header.backgroundColor = .red
        header.editButton.isHidden = true
        if loggedInBuilder, sectionArray[section] == .portfolio {
            let count = loggedInBuilderModel?.result.portfolio.count ?? 0
            header.headerLabel.text = sectionArray[section].title + "  (\(count) \(count > 1 ? " jobs)" : "job)")"
            if count >= 4 {
                header.editButton.isHidden = false
                header.editButton.setTitle(self.limitedShow ? "All" : "Less", for: .normal)
            }
        } else if sectionArray[section] == .portfolio {
            let count = tradieModel?.result.portfolio.count ?? 0
            header.headerLabel.text = sectionArray[section].title + "  (\(count) \(count > 1 ? " jobs)" : "job)")"
            if count >= 4 {
                header.editButton.isHidden = false
                header.editButton.setTitle(self.limitedShow ? "All" : "Less", for: .normal)
            }
        } else {
            if sectionArray[section] == .about {
                header.editButton.isHidden = false
                header.editButton.setTitle(self.showMoreContent ? "Less" : "More", for: .normal)
            }
            header.headerLabel.text = sectionArray[section].title
        }
        header.editButton.tag = section
        header.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
    
    
    @objc func editButtonAction(_ sender: UIButton) {
        switch sectionArray[sender.tag] {
        case  .about:
            self.showMoreContent = !self.showMoreContent
        case .portfolio:
            self.limitedShow = !self.limitedShow
        default:
            break
        }
        self.tableViewOutlet.reloadSections([sender.tag], with: .none)
    }
}
