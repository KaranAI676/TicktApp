//
//  CommonJobDetails+TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import Foundation
import SafariServices
import PDFKit

extension CommonJobDetailsVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellsArray[section] {
        case .category, .grid, .jobType, .specialisation, .details, .question,.quotes, .bottomButton, .postedBy:
            return 1
        case .cancellation, .crRejection:
            return 1
        case .photos:
                return (self.jobDetail?.result?.photos?.count ?? 0 > 0) ? 1 : 0
        case .milestones:
                return (jobDetail?.result?.jobMilestonesData?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellsArray[indexPath.section] {
        case .cancellation:
            return self.cancelltationCell(tableView: tableView, indexPath: indexPath)
        case .crRejection:
            return self.crRejection(tableView: tableView, indexPath: indexPath)
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
        case .quotes:
            return self.getQuotesCell(tableView: tableView, indexPath: indexPath)
        case .milestones:
            return indexPath.row == 0 ? self.getMilestoneTitleCell(tableView: tableView, indexPath: indexPath) : self.getMilestoneCell(tableView: tableView, indexPath: indexPath)
        case .photos:
            return self.getPhotosTableCell(tableView: tableView, indexPath: indexPath)
        case .bottomButton:
            return self.getBottomBUttonCell(tableView: tableView, indexPath: indexPath)
        case .postedBy:
            return self.getPostedByCell(tableView: tableView, indexPath: indexPath)
        }
    }
}

extension CommonJobDetailsVC {

    private func cancelltationCell(tableView: UITableView, indexPath: IndexPath) -> CancellationTableCell {
        let cell = tableView.dequeueCell(with: CancellationTableCell.self)
        let cancelReason = jobDetail?.result?.rejectReasonNoteForCancelJobRequest ?? ""
        let reasonIndex = jobDetail?.result?.reasonForCancelJobRequest ?? 0
        if let cancelRequest = jobDetail?.result?.isCancelJobRequest, cancelRequest {
            if let reasonIndex = jobDetail?.result?.reasonForCancelJobRequest,
               let reason = ReasonsType.init(rawValue: reasonIndex)?.reason,
               let type: CancellationTableCell.CellType = screenType == .activeJob ? .cancelWithButtons : .cancel {
                cell.titleReason = (type: type, reason, jobDetail?.result?.reasonNoteForCancelJobRequest ?? "")
            }
        } else if !cancelReason.isEmpty || reasonIndex != 0 { //Need to change at builder side
            if let reason = ReasonsType.init(rawValue: reasonIndex)?.reason {
                cell.titleReason = (type: .cancelDecline, reason, cancelReason)
            } else {
                cell.titleReason = (type: .cancelDecline, "", cancelReason)
            }
        }
        cell.buttonClosure = { [weak self] type in
            guard let self = self else { return }
            if let jobId = self.jobDetail?.result?.jobId {
                self.handleCancelltionRequest(jobId: jobId, type: type)
            }
        }
        return cell
    }
    
    private func crRejection(tableView: UITableView, indexPath: IndexPath) -> CancellationTableCell {
        let cell = tableView.dequeueCell(with: CancellationTableCell.self)
        cell.titleReason = (type: .cr, "", jobDetail?.result?.changeRequestDeclineReason ?? "")
        return cell
    }
    
    private func getCategoryCell(tableView: UITableView, indexPath: IndexPath) -> TradeWithDescriptionTableCell {
        let cell = tableView.dequeueCell(with: TradeWithDescriptionTableCell.self)
        cell.model = (self.jobDetail?.result, screenType)
        return cell
    }
    
    private func getJobTypesCell(tableView: UITableView, indexPath: IndexPath) -> DynamicHeightCollectionViewTableCell {
        let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
        cell.titleLabel.textColor = AppColors.themeBlue
        cell.stackView.spacing = 0
        cell.isSelectionEnable = false
        cell.titleLabelFont = UIFont.kAppDefaultFontBold(ofSize: 16)
        cell.extraCellSize = CGSize(width: (36 + 6 + 12 + 15), height: 26)
        cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
        cell.editBackView.isHidden = true
        ///
        let jobTypeData = JobTypeData()
        cell.populateUI(title: "Job type", dataArray: [jobDetail?.result?.jobType ?? jobTypeData], cellType: .jobDetail)
        cell.layoutIfNeeded()
        return cell
    }
    
    private func getSpecialisationCell(tableView: UITableView, indexPath: IndexPath) -> DynamicHeightCollectionViewTableCell {
        
        let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
        cell.topConstraint.constant = 36
        cell.stackView.spacing = 15
        cell.isSelectionEnable = false
        cell.titleLabel.textColor = AppColors.themeBlue
        cell.titleLabelFont = UIFont.kAppDefaultFontBold(ofSize: 16)
        cell.extraCellSize = CGSize(width: 25, height: 25)
        cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
        cell.editBackView.isHidden = true
        ///
        cell.populateUI(title: "Specialisations needed", dataArray: jobDetail?.result?.specializationData ?? [], cellType: .specialisationDetail)
        cell.layoutIfNeeded()
        return cell
    }
    
    private func getGridTableCell(tableView: UITableView, indexPath: IndexPath) -> GridInfoTableCell {
        ///
        let cell = tableViewOutlet.dequeueCell(with: GridInfoTableCell.self)
        cell.pastJobStatus = pastJobStatus
        cell.openJobModel = (jobDetail?.result, screenType)
        return cell
    }
    
    private func getMilestoneTitleCell(tableView: UITableView, indexPath: IndexPath) -> TitleLabelTableCell {
        ///
        let cell = tableView.dequeueCell(with: TitleLabelTableCell.self)
        cell.model = (self.jobDetail?.result, screenType)
        return cell
    }
    
    private func getMilestoneCell(tableView: UITableView, indexPath: IndexPath) -> MilestoneListingTableCell {
        ///
        let cell = tableView.dequeueCell(with: MilestoneListingTableCell.self)
        cell.countLabel.text = "\(indexPath.row)."
        cell.openJobModel = (jobDetail?.result?.jobMilestonesData![indexPath.row - 1], screenType)
        return cell
    }
    
    private func getBottomBUttonCell(tableView: UITableView, indexPath: IndexPath) -> BottomButtonTableCell {
        let cell = tableView.dequeueCell(with: BottomButtonTableCell.self)
        cell.setTitle(title: "Publish  again")
        cell.actionButtonClosure = { [weak self] in
            guard let _ = self else { return }
            CommonFunctions.showToastWithMessage("Republishing: Under development")
        }
        return cell
    }
    
    private func getPostedByCell(tableView: UITableView, indexPath: IndexPath) -> PostedByCell {
        let cell = tableView.dequeueCell(with: PostedByCell.self)
        cell.postedUser = jobDetail?.result?.postedBy
        cell.topConstraint.constant = 30
        cell.leftConstraint.constant = 14
        cell.rightConstraint.constant = 14
        cell.messageButton.isHidden = true
        cell.profileButton.isHidden = true
        return cell
    }
    
    private func getDetailsCell(tableView: UITableView, indexPath: IndexPath) -> DetailsWithTitleTableCell {
        let cell = tableViewOutlet.dequeueCell(with: DetailsWithTitleTableCell.self)
        cell.model = (jobDetail?.result?.details ?? "N.A", screenType)
        return cell
    }
    
    private func getPhotosTableCell(tableView: UITableView, indexPath: IndexPath) -> CommonCollectionViewWithTitleTableCell {
        let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
        cell.editBackView.isHidden = true
        cell.titleLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        
        if let model = self.jobDetail?.result?.photos {
            cell.populateUIFromUrlsArray(title: "Photos & Docs", dataArray: model)
        }
        ///
        cell.docPreviewAction = { [weak self] urlString in
            guard let self = self else { return }
            let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
            vc.comingFromLocal = false
            vc.url = urlString.absoluteString
            self.push(vc: vc)
        }
        cell.photoPreviewAction = { [weak self] urlString in
            guard let self = self else { return }
            self.goToPreviewVC(url: urlString)
        }
        cell.videoPreviewAction = { [weak self] url in
            guard let self = self else { return }
            self.playTheVideo(videoUrl: url)
        }
        return cell
    }
    
    private func getQuestionCell(tableView: UITableView, indexPath: IndexPath) -> QuestionButtonTableCell {
        let cell = tableViewOutlet.dequeueCell(with: QuestionButtonTableCell.self)
        ///
        cell.actionButton.setTitle("\(jobDetail?.result?.questionsCount ?? 0) questions", for: .normal)
        cell.actionButtonClosure = { [weak self] in
            guard let self = self else { return }
            self.goToQuestionBuilderVC()
        }
        return cell
    }
    
    private func getQuotesCell(tableView: UITableView, indexPath: IndexPath) -> JobQuotesCell {
        let cell = tableViewOutlet.dequeueCell(with: JobQuotesCell.self)
        ///
        var quoteCount = 0
        if screenType == .openJobs {
            var quoteTitle = ""
            quoteCount = jobDetail?.result?.quoteCount ?? 0
            if quoteCount == 0 {
                quoteTitle = "0 Quotes"
            }else if quoteCount > 1{
                quoteTitle = "\(quoteCount) Quotes"
            }else{
                quoteTitle = "\(quoteCount) Quote"
            }
            
            cell.quoteButton.setTitle(quoteTitle, for: .normal)
        } else {
            cell.quoteButton.setTitle("View quote", for: .normal)
        }
        
        cell.actionButtonClosure = { [weak self] in
            guard let self = self else { return }
            if self.screenType == .openJobs {
                if quoteCount == 0 {
                    CommonFunctions.showToastWithMessage("No quotes yet")
                }else{
                    self.goToJobQuotesVC()
                }
            } else {
                self.openQuoteListing()
            }
        }
        return cell
    }
    
    func openQuoteListing() {
        let tradieId = jobDetail?.result?.quote?.first?.tradieId ?? ""
        let vc = QuotesDetailsVC.instantiate(fromAppStoryboard: .jobQuotes)
        vc.showBottomButton = false
        vc.catName = jobDetail?.result?.tradeName ?? ""
        vc.cattype = jobDetail?.result?.jobName ?? ""
        vc.ctImage = jobDetail?.result?.tradeSelectedUrl ?? ""
        vc.jobId = jobId
        vc.tradieId = tradieId
        if !tradieId.isEmpty {
            push(vc: vc)
        } else { // For Testing.
            CommonFunctions.showToastWithMessage("Something went wrong!")
        }
    }
}

extension CommonJobDetailsVC {
    
    func getCellArray() -> [CellTypes] {
        
        var cellArray: [CellTypes] = []
            
        let cancelReason = jobDetail?.result?.rejectReasonNoteForCancelJobRequest ?? ""
        let reasonIndex = jobDetail?.result?.reasonForCancelJobRequest ?? 0
        
        if pastJobStatus.uppercased() == JobStatus.cancelled.rawValue {
            if !cancelReason.isEmpty || reasonIndex != 0 {
                cellArray.append(.cancellation)
            }
        } else if screenType == .activeJob {
            if let cancelRequest = jobDetail?.result?.isCancelJobRequest, cancelRequest {
                cellArray.append(.cancellation)
            } else if !cancelReason.isEmpty || reasonIndex != 0 {
                cellArray.append(.cancellation)
            }
        }
      
        if screenType == .activeJob,
           let crRejection = jobDetail?.result?.changeRequestDeclineReason, !crRejection.isEmpty {
            cellArray.append(.crRejection)
        }
        
        switch screenType {
        case .openJobs:
            if jobDetail?.result?.quoteJob ?? false {
                cellArray.append(contentsOf: [.category, .grid, .jobType, .specialisation, .details, .question, .quotes, .milestones, .photos, .postedBy])
            } else {
                cellArray.append(contentsOf: [.category, .grid, .jobType, .specialisation, .details, .question,  .milestones, .photos, .postedBy])
            }
        case .pastJobsCompleted:
            cellArray.append(contentsOf: [.category, .grid, .jobType, .specialisation, .details, .question, .milestones, .photos, .postedBy])
        case .activeJob:
            cellArray.append(contentsOf: [.category, .grid, .jobType, .specialisation, .details, .question, .milestones, .photos, .quotes,.postedBy])
        case .pastJobsExpired:
            cellArray.append(contentsOf: [.category, .grid, .jobType, .specialisation, .details, .question, .milestones, .photos])
        default:
            break
        }
        return cellArray
    }
}
