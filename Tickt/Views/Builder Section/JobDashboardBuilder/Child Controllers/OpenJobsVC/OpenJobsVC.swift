//
//  OpenJobsVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/05/21.
//

import UIKit

//Applied Job For Tradie
class OpenJobsVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK:- Variables
    var updateDashBoardCount: ((_ new: Int, _ need: Int)->Void)? = nil
    var updateNewApplicantRemovedJob: (()->Void)? = nil
    var viewModel = JobDashboardVM()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        if kUserDefaults.isTradie() {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshJob(_:)), name: NotificationName.refreshAppliedList, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.updateDashBoardCount?(model?.result.newApplicantsCount ?? 0, model?.result.needApprovalCount ?? 0)
    }
    
    @objc func refreshJob(_ notification: Notification) {
        pullToRefresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension OpenJobsVC {
    
    private func initialSetup() {
        setupTableView()
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        paginationClosure()
        hitApi()
    }
    
    private func hitApi(showLoader: Bool = true) {
        if kUserDefaults.isTradie() {
            viewModel.getJobs(status: .applied, showLoader: showLoader)
        } else {
            viewModel.getJobs(status: .open, showLoader: showLoader)
        }
    }
    
    private func paginationClosure() {
        viewModel.hitPagination = { [weak self] in
            guard let self = self else { return }
            self.hitApi(showLoader: false)
        }
    }
    
    private func setupTableView() {
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.contentInset.bottom = 20
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.registerCell(with: JobStatusCell.self)
        tableViewOutlet.registerCell(with: JobStatusTableCell.self)
    }
    
    private func goToDetailVC(jobId: String,index:IndexPath) {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = .openJobs
        vc.delegate = self
        vc.quoteIndex = index
        vc.jobId = jobId
        push(vc: vc)
    }
    
    private func goToJobApplicationVC(_ model: OpenJobs) {
        let vc = OpenJobsApplicationsVC.instantiate(fromAppStoryboard: .openJobsApplications)
        var jobModel = BasicJobModel()
        jobModel.tradeName = model.tradeName
        jobModel.jobName = model.jobName
        jobModel.tradeImage = model.tradeSelectedUrl
        jobModel.jobFromDate = model.fromDate
        jobModel.jobToDate = model.toDate
        jobModel.jobId = model.jobId
        jobModel.quoteJob = model.quoteJob
        jobModel.quoteCount = model.quoteCount
        vc.jobModel = jobModel
        vc.delegate = self
        self.push(vc: vc)
    }
    
    private func goToJobQuotesVC(_ model: OpenJobs) {
//        let vc = OpenJobsApplicationsVC.instantiate(fromAppStoryboard: .openJobsApplications)
        let vc = QuotesListingVC.instantiate(fromAppStoryboard: .jobQuotes)
        var jobModel = BasicJobModel()
        jobModel.tradeName = model.tradeName
        jobModel.jobName = model.jobName
        jobModel.tradeImage = model.tradeSelectedUrl
        jobModel.jobFromDate = model.fromDate
        jobModel.jobToDate = model.toDate
        jobModel.jobId = model.jobId
        jobModel.quoteJob = model.quoteJob
        jobModel.quoteCount = model.quoteCount
        vc.jobModel = jobModel
        vc.delegate = self
        self.push(vc: vc)
    }
    
    func goToJobDetail(model: RecommmendedJob) {
        let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
        jobDetailVC.screenType = .activeJobDetail
        jobDetailVC.jobId = model.jobId ?? ""
        jobDetailVC.tradeId = model.tradeId ?? ""
        jobDetailVC.specialisationId = model.specializationId ?? ""
        push(vc: jobDetailVC)
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        if kUserDefaults.isTradie() {
            viewModel.getJobs(status: .applied, showLoader: false, isPullToRefresh: true)
        } else {
            viewModel.getJobs(status: .open, showLoader: false, isPullToRefresh: true)
        }
    }
}

//MARK:- UITableView Delegates
//=============================
extension OpenJobsVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kUserDefaults.isTradie() {
            return viewModel.appliedJobTradie?.result.applied.count ?? 0
        } else {
            return self.viewModel.openBuilderModel?.result.open?.count ?? 0
        }        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if kUserDefaults.isTradie() {
            let cell = tableView.dequeueCell(with: JobStatusCell.self)
            viewModel.hitPagination(index: indexPath.row, type: .applied)
            cell.selectButton.isHidden = false
            cell.appliedJob = viewModel.appliedJobTradie?.result.applied[indexPath.row]
            cell.viewQuoteAction = { [weak self] in
                self?.editQuoteVC(indexPath: indexPath)
            }
            cell.detailAction = { [weak self] in
                self?.goToJobDetail(model: (self?.viewModel.appliedJobTradie?.result.applied[indexPath.row])!)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(with: JobStatusTableCell.self)
            cell.tableView = tableView
            viewModel.hitPagination(index: indexPath.row, type: .open)
            if let model = viewModel.openBuilderModel?.result.open?[indexPath.row] {
                cell.openJobsModel = model
            }
            cell.buttonClosure = { [weak self] (buttonType, index) in
                guard let self = self else { return }
                switch buttonType {
                case .forward:
                    if let model = self.self.viewModel.openBuilderModel?.result.open?[index.row] {
                        self.goToDetailVC(jobId: model.jobId, index: indexPath)
                    }
                case .application:
                    if let model = self.self.viewModel.openBuilderModel?.result.open?[index.row] {
                        self.goToJobApplicationVC(model)
                    }
                    
                case .quotes:
                    if let model = self.self.viewModel.openBuilderModel?.result.open?[index.row] {
                        if model.quoteCount == 0{
                            CommonFunctions.showToastWithMessage("No quotes yet")
                        } else {
                            self.goToJobQuotesVC(model)
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func editQuoteVC(indexPath: IndexPath) {
        let vc = AddQuoteVC.instantiate(fromAppStoryboard: .quotes)
        vc.delegate = self
        vc.isResubmitQuote = true
        let object = viewModel.appliedJobTradie?.result.applied[indexPath.row]        
//        let data = JobDetailsData(time: nil, isSaved: false, editJob: false, jobId: object?.jobId, quoteJob: true, quoteCount: 0, status: "", toDate: "", amount: "", isInvited: false, tradeId: object?.tradeId, details: "", jobName: object?.jobName, fromDate: "", distance: 0, duration: "", jobStatus: "", tradeName: object?.tradeName, postedBy: PostedBy(reviews: 0, ratings: 0, builderId: object?.builderId, builderName: object?.builderName, builderImage: object?.builderImage), questionsCount: 0, milestoneNumber: 0, totalMilestones: 0, locationName: "", jobType: nil, isChangeRequest: false, appliedStatus: "", photos: [], alreadyApplyQuote: true, applyButtonDisplay: true, tradeSelectedUrl: object?.tradeSelectedUrl, specializationId: object?.specializationId, isCancelJobRequest: false, specializationName: object?.specializationName, reasonForCancelJobRequest: 0, reasonForChangeRequest: [], changeRequestDeclineReason: "", reasonNoteForCancelJobRequest: "", changeRequestData: [], jobMilestonesData: [], specializationData: [], rejectReasonNoteForCancelJobRequest: "")
//        vc.jobDetail = data //Maa Meri
        push(vc: vc)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.self.viewModel.openBuilderModel?.result.open?[indexPath.row] {
            self.goToDetailVC(jobId: model.jobId, index: indexPath)
        }
    }
}


//MARK:- ViewModel: Delegate
//==========================
extension OpenJobsVC: JobDashboardVMDelegate {
    
    func successAppliedTradie() {
        if viewModel.appliedJobTradie?.result.applied.count == 0 {
            showWaterMarkLabel(message: "You have not applied for any job!")
        } else {
            hideWaterMarkLabel()
        }
        NotificationCenter.default.post(name: NotificationName.refreshJobCount, object: nil, userInfo: [ApiKeys.jobCount: viewModel.appliedJobTradie?.result.newJobsCount ?? 0, ApiKeys.milestoneCount: viewModel.appliedJobTradie?.result.milestonesCount ?? 0])
        mainQueue { [weak self] in
            self?.refresher.endRefreshing()
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func successOpenBuilder() {
        refresher.endRefreshing()
        self.viewModel.openBuilderModel?.result.open?.count ?? 0 == 0 ? showWaterMarkLabel(message: "No open jobs yet!") : hideWaterMarkLabel()
        self.updateDashBoardCount?(self.self.viewModel.openBuilderModel?.result.newApplicantsCount ?? 0, self.self.viewModel.openBuilderModel?.result.needApprovalCount ?? 0)
        tableViewOutlet.reloadData()
    }
    
    func failure(message: String) {
        refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(message)
    }
}


extension OpenJobsVC: OpenJobsApplicationsVCDelegate {
    
    func removedEmptyJob(jobId: String, status: AcceptDecline) {
        let index = self.self.viewModel.openBuilderModel?.result.open?.firstIndex(where: { eachModel in
            return eachModel.jobId == jobId
        })
        
        if let index = index {
            self.viewModel.openBuilderModel?.result.open?.remove(at: index)
            updateNewApplicantRemovedJob?()
            tableViewOutlet.reloadData()
        }
    }
}


extension OpenJobsVC: OpenJobsQuotesVCDelegate {
    
    func removedEmptyQuotes(jobId: String, status: AcceptDecline) {
        let index = self.self.viewModel.openBuilderModel?.result.open?.firstIndex(where: { eachModel in
            return eachModel.jobId == jobId
        })
        
        if let index = index {
            self.viewModel.openBuilderModel?.result.open?.remove(at: index)
            updateNewApplicantRemovedJob?()
            tableViewOutlet.reloadData()
        }
    }
}

extension OpenJobsVC: OpenQuotesJobsVCDelegate, SubmitQuoteDelegate {
    func didQuoteAccepted() {
        
    }
    
    func didQuoteSubmitted() {
        pullToRefresh()
    }

    func removedQuoteJob(jobId: String, status: AcceptDecline, index: IndexPath) {
        self.viewModel.openBuilderModel?.result.open?.remove(at: index.row)
        self.tableViewOutlet.reloadData()
    }
}
