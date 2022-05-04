//
//  JobPreview+TableView.swift
//  Tickt
//
//  Created by Admin on 27/04/21.
//

import UIKit

extension CreatingJobPreviewVC: TableDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellsArray[section] {
        case .category, .grid, .jobType, .specialisation, .details, .question, .bottomButton, .gridCell, .applyJob, .postedBy, .changeRequest, .inviteAccept, .cancelRequest, .viewQuotes:
            return 1
        case .photos:
            if screenType == .jobDetail || screenType == .activeJobDetail {
                return (jobDetail?.result?.photos?.count ?? 0) > 0 ? 1 : 0
            } else {
                return model.mediaImages.count == 0 ? 0 : 1
            }
        case .milestones:
            switch screenType {
            case .jobPreview:
                return model.milestones.count + 1 /// One extra for title
            case .openJobs:
                return (jobDetail?.result?.jobMilestonesData?.count ?? 0) + 1
            default:
                return (jobDetail?.result?.jobMilestonesData?.count ?? 0) + 1 /// One extra for title
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellsArray[indexPath.section] {
        case .viewQuotes:
            return self.getQuotesCell(indexPath: indexPath)
        case .category:
            return self.getCategoryCell(tableView: tableView, indexPath: indexPath)
        case .grid:
            return getGridTableCell(tableView: tableView, indexPath: indexPath)
        case .jobType:
            return self.getJobTypesCell(tableView: tableView, indexPath: indexPath)
        case .specialisation:
            return self.getSpecialisationCell(tableView: tableView, indexPath: indexPath)
        case .details:
            return getDetailsCell(tableView: tableView, indexPath: indexPath)
        case .question:
            return self.getQuestionCell(tableView: tableView, indexPath: indexPath)
        case .milestones:
            return indexPath.row == 0 ? self.getMilestoneTitleCell(tableView: tableView, indexPath: indexPath) : self.getMilestoneCell(tableView: tableView, indexPath: indexPath)
        case .photos:
            return self.getPhotosTableCell(tableView: tableView, indexPath: indexPath)
        case .bottomButton:
            return self.getBottomButtonCell(tableView: tableView, indexPath: indexPath)
        case .gridCell:
            return self.getGridCell(tableView: tableView, indexPath: indexPath)
        case .applyJob:
            return self.getApplyJobsCell(tableView: tableView, indexPath: indexPath)
        case .postedBy:
            return self.getPostedByCell(tableView: tableView, indexPath: indexPath)
        case .inviteAccept:
            return getAcceptRejectCell(indexPath: indexPath)
        case .changeRequest:
            return getChangeRequestCell(indexPath: indexPath)
        case .cancelRequest:
            return getCancelRequestCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popUpView.popOut()
    }
}

extension CreatingJobPreviewVC {

    private func getQuotesCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueCell(with: ButtonCell.self)
        cell.completeButtonAction = { [weak self] in
            let vc = ViewQuoteVC.instantiate(fromAppStoryboard: .quotes)
            var object = RecommmendedJob()
            object.tradeName = self?.jobDetail?.result?.tradeName
            object.jobName = self?.jobDetail?.result?.jobName
            object.jobId = self?.jobDetail?.result?.jobId
            object.tradeSelectedUrl = self?.jobDetail?.result?.tradeSelectedUrl
            vc.jobObject = object
            self?.push(vc: vc)
        }
        return cell
    }
    
    //Change Request and cancel request
    private func getChangeRequestCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueCell(with: ChangeRequestCell.self)
        
        let jobStatus = jobDetail?.result?.jobStatus ?? ""
        let isChangeRequest = jobDetail?.result?.isChangeRequest ?? false
        let reasonNoteForChangeRequest = (jobDetail?.result?.reasonForChangeRequest ?? []).joined(separator: "\n")
        
        cell.titleLabel.text = "Change request details"
        cell.changeRequestLabel.text = reasonNoteForChangeRequest
        
        if isChangeRequest, !(jobStatus.lowercased() == "expired".lowercased() || jobStatus.lowercased() == "completed".lowercased() || jobStatus.lowercased() == "cancelled".lowercased() || jobStatus.lowercased() == "cancelledApply".lowercased()) { //Show reason with button
            cell.heightConstraint.constant = 40
            cell.bottomConstraint.constant = 24
        } else { //Only Show reasoncell.heightConstraint.constant = 0 // if reasonNoteForChangeRequest.count > 0
            cell.heightConstraint.constant = 0
            cell.bottomConstraint.constant = 0
        }
        
        cell.acceptButtonAction = { [weak self]  in
            guard let self = self else { return }
            self.viewModel.acceptDeclineChangeRequest(jobId: self.jobId, isAccept: 1, note: "Accpeted")
        }
        
        cell.declineButtonAction = { [weak self] in
            guard let self = self else { return }
            self.showDeclineView()
        }
        return cell
    }
//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
    //Cancel request cell
    private func getCancelRequestCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueCell(with: ChangeRequestCell.self)
        
        //To show change request cell
        let jobStatus = jobDetail?.result?.jobStatus ?? ""
        let isCancelRequest = jobDetail?.result?.isCancelJobRequest ?? false
        let rejectReasonForCancelRequest = jobDetail?.result?.rejectReasonNoteForCancelJobRequest ?? ""
        
        cell.titleLabel.text = "Job cancellation request"
        if isCancelRequest, !(jobStatus.lowercased() == "expired".lowercased() || jobStatus.lowercased() == "completed".lowercased() || jobStatus.lowercased() == "cancelled".lowercased() || jobStatus.lowercased() == "cancelledApply".lowercased()) { //Show reason with button
            cell.heightConstraint.constant = 40
            cell.bottomConstraint.constant = 24
            if let reasonIndex = jobDetail?.result?.reasonForCancelJobRequest, let reason = ReasonsType(rawValue: reasonIndex)?.reason {
                cell.changeRequestLabel.text = reason + "\n" + (jobDetail?.result?.reasonNoteForCancelJobRequest ?? "")
            } else {
                cell.changeRequestLabel.text = jobDetail?.result?.reasonNoteForCancelJobRequest
            }
        } else  { //Only Show reason
            cell.heightConstraint.constant = 0
            cell.bottomConstraint.constant = 0
            
            if let reasonIndex = jobDetail?.result?.reasonForCancelJobRequest, let reason = ReasonsType(rawValue: reasonIndex)?.reason {
                if rejectReasonForCancelRequest.isEmpty {
                    cell.changeRequestLabel.text = reason 
                } else {
                    cell.changeRequestLabel.text = reason + "\n" + rejectReasonForCancelRequest
                }
            } else {
                cell.changeRequestLabel.text = rejectReasonForCancelRequest
            }
        }
        
        cell.acceptButtonAction = { [weak self]  in
            guard let self = self else { return }
            self.showAlert(alert: "Cancel Job", msg: "Are you sure, you want to end this job?", done: "Yes", cancel: "No") { status in
                if status {
                    self.viewModel.acceptDeclineCancelRequest(jobId: self.jobId, status: .accept, note: "Accpeted")
                }
            }
        }
        cell.declineButtonAction = { [weak self] in
            guard let self = self else { return }
            self.showRejectView()
        }
        return cell
    }
    
    private func showRejectView() {
        if let rejectPopup: CancelJobView = loadCustomView() {
            view.addSubview(rejectPopup)
            rejectPopup.frame = view.frame
            rejectPopup.cancelRequestClosure = { [weak self] reason in
                guard let self = self else { return }
                self.viewModel.acceptDeclineCancelRequest(jobId: self.jobId, status: .decline, note: reason)
            }
            rejectPopup.popIn()
        }
    }
    
    private func showDeclineView() {
        let declineView = DeclineRequestView.instantiate(fromAppStoryboard: .jobPosting)
        declineView.modalPresentationStyle = .overCurrentContext
        declineView.declineRequestClosure = { [weak self] note in
            guard let self = self else { return }
            self.viewModel.acceptDeclineChangeRequest(jobId: self.jobId, isAccept: 2, note: note)
        }
        present(declineView, animated: true, completion: nil)
    }
    
    private func getAcceptRejectCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueCell(with: BottomButtonsTableCell.self)
        cell.firstButton.setTitle("Apply", for: .normal)
        cell.secondButton.setTitle("Decline", for: .normal)
        cell.buttonClosure = { [weak self] sender in
            guard let self = self else { return }
            if self.jobDetail?.result?.quoteJob ?? false {
                if sender == .firstButton {
                    if self.jobDetail?.result?.alreadyApplyQuote ?? false {
                        self.checkQuoteApply(isEditQuote: true, isInvite: true)
                    } else {
                        self.checkQuoteApply(isEditQuote: false, isInvite: true)
                    }
                } else {
                    self.viewModel.acceptDeclineJob(builderId: self.jobDetail?.result?.postedBy?.builderId ?? "", jobId: self.jobId, isAccept: false)
                }
            } else {
                if sender == .firstButton {
                    self.viewModel.acceptDeclineJob(builderId: self.jobDetail?.result?.postedBy?.builderId ?? "", jobId: self.jobId, isAccept: true)
                } else {
                    self.viewModel.acceptDeclineJob(builderId: self.jobDetail?.result?.postedBy?.builderId ?? "", jobId: self.jobId, isAccept: false)
                }
            }
        }
        return cell
    }
    
    private func getCategoryCell(tableView: UITableView, indexPath: IndexPath) -> TradeWithDescriptionTableCell {
        let cell = tableView.dequeueCell(with: TradeWithDescriptionTableCell.self)
        cell.isJobDetail = screenType == .jobDetail || screenType == .activeJobDetail
        ///
        switch screenType {
        case .jobPreview:
            cell.populateUI(title: model.categories?.tradeName ?? "N.A", description: model.jobName, image: model.categories?.selectedUrl ?? "")
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToCreateJobVC()
            }
            return cell
        case .jobDetail, .activeJobDetail:
            cell.populateUI(title: jobDetail?.result?.tradeName ?? "N.A", description: jobDetail?.result?.jobName ?? "N.A", image: jobDetail?.result?.tradeSelectedUrl ?? "")
            return cell
        case .openJobs:
            cell.populateUI(title: jobDetail?.result?.tradeName ?? "N.A", description: jobDetail?.result?.jobName ?? "N.A", image: jobDetail?.result?.tradeSelectedUrl ?? "")
            cell.editButtonBackView.isHidden = true
            return cell
        default:
            return TradeWithDescriptionTableCell()
        }
    }
    
    private func getJobTypesCell(tableView: UITableView, indexPath: IndexPath) -> DynamicHeightCollectionViewTableCell {
        let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
        cell.isJobDetail = screenType == .jobDetail || screenType == .activeJobDetail
        cell.titleLabel.textColor = AppColors.themeBlue
        cell.stackView.spacing = 0
        cell.isSelectionEnable = false
        cell.titleLabelFont = UIFont.kAppDefaultFontBold(ofSize: 16)
        cell.extraCellSize = CGSize(width: (36 + 6 + 12 + 15), height: 26)
        cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
        cell.editBackView.isHidden = false
        
        switch screenType {
        case .jobDetail, .activeJobDetail:
            let jobTypeData = JobTypeData()
            cell.populateUI(title: "Job type", dataArray: [jobDetail?.result?.jobType ?? jobTypeData], cellType: .jobDetail)
            return cell
        case .openJobs:
            let jobTypeData = JobTypeData()
            cell.populateUI(title: "Job type", dataArray: [jobDetail?.result?.jobType ?? jobTypeData], cellType: .jobDetail)
            cell.editBackView.isHidden = true
            return cell
        case .jobPreview:
            cell.populateUI(title: "Job type", dataArray: model.jobType, cellType: .jobType)
            cell.editButtonClosure = { [weak self] in
                self?.goToCreateJobVC()
            }
        default:
            return DynamicHeightCollectionViewTableCell()
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    private func getSpecialisationCell(tableView: UITableView, indexPath: IndexPath) -> DynamicHeightCollectionViewTableCell {
        
        let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
        cell.isJobDetail = screenType == .jobDetail || screenType == .activeJobDetail
        cell.topConstraint.constant = 36
        cell.stackView.spacing = 15
        cell.isSelectionEnable = false
        cell.titleLabel.textColor = AppColors.themeBlue
        cell.titleLabelFont = UIFont.kAppDefaultFontBold(ofSize: 16)
        cell.extraCellSize = CGSize(width: 25, height: 25)
        cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
        cell.editBackView.isHidden = false
        
        switch screenType {
        case .jobDetail, .activeJobDetail:
            cell.populateUI(title: "Specialisations needed", dataArray: jobDetail?.result?.specializationData ?? [], cellType: .specialisationDetail)
        case .jobPreview:
            if let model = model.specialisation {
                cell.populateUI(title: "Specialisations needed", dataArray: model, cellType: .specialisation)
                cell.editButtonClosure = { [weak self] in
                    guard let self = self else  { return }
                    self.goToCreateJobVC()
                }
            }
        case .openJobs:
            cell.editBackView.isHidden = true
            cell.populateUI(title: "Specialisations needed", dataArray: jobDetail?.result?.specializationData ?? [], cellType: .specialisationDetail)
        default:
            return DynamicHeightCollectionViewTableCell()
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    private func getGridTableCell(tableView: UITableView, indexPath: IndexPath) -> GridInfoTableCell {
        
        switch screenType {
        case .jobPreview:
            let cell = tableViewOutlet.dequeueCell(with: GridInfoTableCell.self)
            var first = ""
            
                if (model.fromDate.date ?? Date()).isToday {
                    first = "Today"
                } else {
                    let daysCount = (model.fromDate.date ?? Date()).daysFrom(Date()) + 1
                    first = "\(daysCount > 0 ? daysCount : 0) days"
                }
            var second = ""
            if model.isQuoteJob {
                second = "For Quoting"
            } else {
                second = "\(model.paymentAmount.getFormattedPrice()) \(model.paymentType.tag)"
            }
            let third = model.jobLocation.locationName
            cell.populateUI(text: [first, second, third])
            return cell
        case .openJobs:
            let cell = tableViewOutlet.dequeueCell(with: GridInfoTableCell.self)
            let model = jobDetail?.result
            var first = ""
            first = CommonFunctions.getFormattedDates(fromDate: model?.fromDate?.convertToDateAllowsNil() ?? Date(), toDate: model?.toDate?.convertToDateAllowsNil())
            let second: String = model?.amount ?? "0"
            let third: String = model?.locationName ?? ""
            let forth: String = model?.duration ?? ""
            cell.populateUI(text: [first, second, third, forth])
            return cell
        default:
            return GridInfoTableCell()
        }
    }
    
    private func getMilestoneTitleCell(tableView: UITableView, indexPath: IndexPath) -> TitleLabelTableCell {
        let cell = tableView.dequeueCell(with: TitleLabelTableCell.self)
        cell.editBackView.isHidden = screenType == .openJobs
        cell.isJobDetail = screenType == .jobDetail || screenType == .activeJobDetail
        cell.titleLabel.text = "Job milestones"
        switch screenType {
        case .jobPreview, .jobDetail:
            cell.titleLabel.text = "Job milestones"
        case .openJobs:
            cell.progressBar.isHidden = false
            cell.titleLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: jobDetail?.result?.milestoneNumber ?? 0, totalMilestones: jobDetail?.result?.totalMilestones ?? 0)
        case .activeJobDetail:
            cell.editBackView.isHidden = true            
            cell.statusLabel.text = jobDetail?.result?.status?.uppercased()
            let status = jobDetail?.result?.jobStatus ?? ""            
            if status.lowercased() == "expired" || status.lowercased() == "completed" || status.lowercased() == "cancelled" || status.isEmpty || status.lowercased() == "cancelledapply" || status.lowercased() == "applied" {
                cell.statusBackView.isHidden = true
            } else {
                cell.statusBackView.isHidden = false
            }
            cell.progressBarView.isHidden = false
            let progres = Double.getDouble(jobDetail?.result?.milestoneNumber ?? 0) / Double.getDouble(jobDetail?.result?.totalMilestones ?? 0)
            if progres.isNaN {
                cell.progressBarView.progress = 0
            } else {
                cell.progressBarView.progress = CGFloat(progres)
            }
            cell.titleLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: jobDetail?.result?.milestoneNumber ?? 0, totalMilestones: jobDetail?.result?.totalMilestones ?? 0)
        default:
            break
        }
        cell.editButtonClosure = { [weak self] in
            guard let self = self else { return }
            self.goToMilestoneListingVC()
        }
        return cell
    }
    
    private func getMilestoneCell(tableView: UITableView, indexPath: IndexPath) -> MilestoneListingTableCell {
        
        let cell = tableView.dequeueCell(with: MilestoneListingTableCell.self)
        cell.countLabel.text = "\(indexPath.row)."
        ///
        switch screenType {
        case .jobPreview:
            cell.milestoneNameLabel.text = model.milestones[indexPath.row-1].milestoneName
            cell.milestoneDatesLabel.text = model.milestones[indexPath.row-1].displayDateFormat
            return cell
        case .jobDetail, .activeJobDetail:
            cell.milestoneNameLabel.text = jobDetail?.result?.jobMilestonesData![indexPath.row - 1].milestoneName
            cell.milestoneDatesLabel.text = CommonFunctions.getFormattedDates(fromDate: jobDetail?.result?.jobMilestonesData![indexPath.row-1].fromDate?.convertToDateAllowsNil(), toDate: jobDetail?.result?.jobMilestonesData![indexPath.row-1].toDate?.convertToDateAllowsNil())
            return cell
        case .openJobs:
            cell.milestoneNameLabel.text = jobDetail?.result?.jobMilestonesData![indexPath.row - 1].milestoneName
            cell.milestoneDatesLabel.text = self.jobDetail?.result?.jobMilestonesData![indexPath.row-1].fromDate?.convertToDate().toString(dateFormat: "MMM dd")
            return cell
        default:
            return MilestoneListingTableCell()
        }
    }
    
    private func getBottomButtonCell(tableView: UITableView, indexPath: IndexPath) -> BottomButtonTableCell {
        let cell = tableView.dequeueCell(with: BottomButtonTableCell.self)
        var title = ""
        if isquoteJobEdit {
             title =  "Submit" //Edit Job
        } else {
             title = model.jobId.isEmpty ? "Post  job" : "Publish  again"
        }
        cell.setTitle(title: title)
        cell.actionButtonClosure = { [weak self] in
            guard let self = self else { return }
            if self.isquoteJobEdit {
                self.viewModel.updateJobApi()
            } else {
              self.viewModel.postJobApi()
            }
        }
        return cell
    }
    
    private func getApplyJobsCell(tableView: UITableView, indexPath: IndexPath) -> ApplyJobCell {
        let cell = tableView.dequeueCell(with: ApplyJobCell.self)
        cell.bookmarkButtonWidth.constant = 0
        cell.bookmarkLeadingConstraint.constant = 0
        cell.isJobSaved = jobDetail?.result?.isSaved ?? false
        let quoteJob = jobDetail?.result?.quoteJob ?? false
        if quoteJob {
            if jobDetail?.result?.alreadyApplyQuote ?? false {
                cell.applyButton.setTitle("Quote sent".capitalizedFirst, for: .normal)
            } else {
                cell.applyButton.setTitle("Quote".capitalizedFirst, for: .normal)
            }
        } else {
            cell.applyButton.setTitle((jobDetail?.result?.appliedStatus ?? "Apply").capitalizedFirst, for: .normal)
        }
        cell.showSaveButton()
        cell.bookmarkButtonClosure = { [weak self] status in
            self?.viewModel.saveJob(status: status, jobId: self?.jobId ?? "", tradeId: self?.tradeId ?? "", specializationId: self?.specialisationId ?? "")
        }
        cell.applyButtonClosure = { [weak self] in
            if quoteJob {
                if self?.jobDetail?.result?.alreadyApplyQuote ?? false {
                    self?.checkQuoteApply(isEditQuote: true, isInvite: false)
                } else {
                    self?.checkQuoteApply(isEditQuote: false, isInvite: false)
                }
            } else {
                self?.checkApplyCell()
            }
        }
        return cell
    }
    
    func openQuoteVC(isEditQuote: Bool, isInvite: Bool) {
        let vc = AddQuoteVC.instantiate(fromAppStoryboard: .quotes)
        vc.delegate = self
        vc.isInvite = isInvite
        vc.isResubmitQuote = isEditQuote
        vc.jobDetail = jobDetail?.result
        push(vc: vc)
    }
    
    func checkApplyCell() {
        let specializations = kUserDefaults.getSpecialization()
        if let jobSpecialization = jobDetail?.result?.specializationData {
            var foundSpecialization = false
            for mySpecialization in specializations {
                for specialization in jobSpecialization {
                    if specialization.specializationId == mySpecialization {
                        foundSpecialization = true
                        break
                    }
                }
                if foundSpecialization { break }
            }
            if !foundSpecialization {
                
                AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                                     alertTitle: "This job doesn’t match your specialisation.",
                                                     alertMessage: "Do you want to apply anyway?",
                                                     acceptButtonTitle: "Apply",
                                                     declineButtonTitle: "Cancel") {
                    self.viewModel.applyJob(builderId: self.jobDetail?.result?.postedBy?.builderId ?? "", jobId: self.jobId, tradeId: self.tradeId, specializationId: self.specialisationId)
                } dismissCompletion: {
                    
                }
            } else {
                viewModel.applyJob(builderId: jobDetail?.result?.postedBy?.builderId ?? "", jobId: jobId, tradeId: tradeId, specializationId: specialisationId)
            }
        }
    }
    
    func checkQuoteApply(isEditQuote: Bool, isInvite: Bool) {
        let specializations = kUserDefaults.getSpecialization()
        if let jobSpecialization = jobDetail?.result?.specializationData {
            var foundSpecialization = false
            for mySpecialization in specializations {
                for specialization in jobSpecialization {
                    if specialization.specializationId == mySpecialization {
                        foundSpecialization = true
                        break
                    }
                }
                if foundSpecialization { break }
            }
            if !foundSpecialization, !isEditQuote {
                AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                                     alertTitle: "This job doesn’t match your specialisation.",
                                                     alertMessage: " Do you want to apply anyway?",
                                                     acceptButtonTitle: "Quote",
                                                     declineButtonTitle: "Cancel") {
                    self.openQuoteVC(isEditQuote: isEditQuote, isInvite: isInvite)
                } dismissCompletion: {
                    
                }
            } else {
                self.openQuoteVC(isEditQuote: isEditQuote, isInvite: isInvite)
            }
        }
    }
    
    private func getGridCell(tableView: UITableView, indexPath: IndexPath) -> GridCell {
        let cell = tableView.dequeueCell(with: GridCell.self)
        cell.isOnGoingJob = screenType == .activeJobDetail
        cell.job = jobDetail?.result
        return cell
    }
    
    private func getPostedByCell(tableView: UITableView, indexPath: IndexPath) -> PostedByCell {
        let cell = tableView.dequeueCell(with: PostedByCell.self)
        cell.postedUser = jobDetail?.result?.postedBy
        cell.topConstraint.constant = 30
        cell.leftConstraint.constant = 14
        cell.rightConstraint.constant = 14
        if screenType == .openJobs {
            cell.messageButton.isHidden = true
            cell.profileButton.isHidden = true
        } else {
            if screenType == .activeJobDetail {
                cell.messageButton.isHidden = false
            } else {
                cell.messageButton.isHidden = true
            }
            
            cell.profileButton.isHidden = false
            cell.profileButtonClosure = { [weak self] in
                guard let builderId = self?.jobDetail?.result?.postedBy?.builderId, let self = self else { return }
                let profileVC = BuilderProfileVC.instantiate(fromAppStoryboard: .profile)
                profileVC.jobId = self.screenType == .activeJob ? self.jobId : ""
                profileVC.jobName = self.jobDetail?.result?.jobName ?? ""
                profileVC.builderId = builderId
                self.push(vc: profileVC)
            }
            cell.messageButtonClosure = { [weak self] in
                self?.goToMessageVC()
            }
        }
        return cell
    }
    
    private func getDetailsCell(tableView: UITableView, indexPath: IndexPath) -> DetailsWithTitleTableCell {
        let cell = tableViewOutlet.dequeueCell(with: DetailsWithTitleTableCell.self)
        cell.editBackView.isHidden = false
        switch screenType {
        case .jobDetail, .activeJobDetail:
            cell.populateUI(title: "Job Description", desc: jobDetail?.result?.details ?? "N.A")
            cell.editBackView.isHidden = true
        case .jobPreview:
            cell.editBackView.isHidden = false
            cell.populateUI(title: "Job Description", desc: model.jobDescription)
            cell.editButtonClosure = { [weak self] in
                self?.goToJobDetailsVC()
            }
        case .openJobs:
            cell.editBackView.isHidden = false
            cell.populateUI(title: "Job Description", desc: jobDetail?.result?.details ?? "N.A")
        default:
            return DetailsWithTitleTableCell()
        }
        return cell
    }
    
    private func getPhotosTableCell(tableView: UITableView, indexPath: IndexPath) -> CommonCollectionViewWithTitleTableCell {
        
        let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
        cell.isJobDetail = screenType == .jobDetail || screenType == .activeJobDetail
        cell.editBackView.isHidden = false
        cell.titleLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        ///
        switch screenType {
        case .jobPreview:
            cell.editButtonClosure = { [weak self] in
                self?.goToAddMediaVC()
            }
//            let imagesArray = model.mediaImages.map({ eachModel -> (UIImage, MediaTypes, URL?) in
//
//                switch eachModel.type {
//                case .image:
//                    return (eachModel.image, eachModel.type, nil)
//                case .video:
//                    return (eachModel.image, eachModel.type, eachModel.videoUrl)
//                case .doc, .pdf:
//                    return (eachModel.image, eachModel.type, URL(string: eachModel.finalUrl))
//                }
            //            })
//            cell.imagePreviewAction = { [weak self] image in
//                guard let self = self else { return }
//                let previewVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
//                previewVC.image = image
//                self.push(vc: previewVC)
//            }
            cell.populateUI(title: "Photos & Docs", dataArray: model.mediaImages)
            /// Image Preview
            cell.imagePreviewWithUrlAction = { [weak self] image, url in
                guard let self = self else { return }
                let previewVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
                if let url = url {
                    previewVC.urlString = url.absoluteString
                }else if let image = image {
                    previewVC.image = image
                }
                self.push(vc: previewVC)
            }
            /// Docs
            cell.docPreviewAction = { [weak self] url in
                guard let self = self else { return }
                let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
                vc.url = url.absoluteString
                self.push(vc: vc)
            }
            /// Video Preview
            cell.videoPreviewAction = { [weak self] url in
                guard let self = self else { return }
                self.playTheVideo(videoUrl: url)
            }
            return cell
        case .jobDetail, .activeJobDetail:
            cell.populateUIFromUrlArray(title: "Photos", dataArray: jobDetail?.result?.photos ?? [])
            cell.docPreviewAction = { [weak self] urlString in
                guard let self = self else { return }
                let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
                vc.comingFromLocal = false
                vc.url = urlString.absoluteString
                self.push(vc: vc)
            }
            cell.photoPreviewAction = { [weak self] urlString in
                let previewVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
                previewVC.urlString = urlString
                self?.push(vc: previewVC)
            }
            cell.videoPreviewAction = { [weak self] url in
                guard let self = self else { return }
                self.playTheVideo(videoUrl: url)
            }
            return cell
        default:
            return CommonCollectionViewWithTitleTableCell()
        }
    }
    
    private func getQuestionCell(tableView: UITableView, indexPath: IndexPath) -> QuestionButtonTableCell {
        let cell = tableViewOutlet.dequeueCell(with: QuestionButtonTableCell.self)
        ///
        switch screenType {
        case .jobDetail, .activeJobDetail:
            cell.actionButton.setTitle("\(jobDetail?.result?.questionsCount ?? 0) questions", for: .normal)
            cell.actionButtonClosure = { [weak self] in
                self?.goToQuestionVC()
            }
            return cell
        case .jobPreview:
            cell.actionButton.setTitle("0 questions", for: .normal)
            return cell
        case .openJobs:
            cell.actionButton.setTitle("\(jobDetail?.result?.questionsCount ?? 0) questions", for: .normal)
            cell.actionButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToQuestionBuilderVC()
            }
            return cell
        default:
            return QuestionButtonTableCell()
        }
    }
}

