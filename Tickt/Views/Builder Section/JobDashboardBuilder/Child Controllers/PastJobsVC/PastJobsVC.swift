//
//  PastJobsVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/05/21.
//

import UIKit

class PastJobsVC: BaseVC {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    var updateDashBoardCount: ((_ new: Int, _ need: Int)->Void)? = nil
    var viewModel = JobDashboardVM()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PastJobsVC {
    
    private func initialSetup() {
        setupTableView()
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        hitPaginationClosure()
        hitApi()
        if kUserDefaults.isTradie() {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshJob(_:)), name: NotificationName.refreshPastList, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(refreshJob(_:)), name: NotificationName.refreshReviewStatus, object: nil)
        }
    }
    
    @objc func refreshJob(_ notification: Notification) {
        pullToRefresh()
    }
    
    private func hitApi(showLoader: Bool = true) {
        if kUserDefaults.isTradie() {
            viewModel.getJobs(status: .pastTradie, showLoader: showLoader)
        } else {
            viewModel.getJobs(status: .past, showLoader: showLoader)
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
    
    private func goToDetailVC(_ jobId: String, screenType: ScreenType, status: String, republishModel: RepublishJobResult? = nil) {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = screenType
        vc.jobId = jobId
        vc.pastJobStatus = status
        vc.republishModel = republishModel
        self.push(vc: vc)
    }
    
    private func goToCreateJobVC(_ jobId: String, screenType: ScreenType, status: String, republishModel: RepublishJobResult? = nil) {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        if let model = republishModel {
            var createJobModel = CreateJobModel(model: model)
            createJobModel.jobId = jobId
            kAppDelegate.postJobModel = createJobModel
            
        }
        vc.screenType = .republishJob
        push(vc: vc)
    }
    
    private func goToRateTradieVC(jobName: String, jobData: PastJobData, tradieData: PastJobTradieData) {
        let vc = ReviewTradePeopleVC.instantiate(fromAppStoryboard: .reviewTradePeople)
        let jobData = PastJobData(jobName: jobName, data: jobData)
        vc.ratingModel = ReviewTradePeopleModel(jobName: jobName, jobData: jobData, tradieData: tradieData)
        vc.delegate = self
        self.push(vc: vc)
    }
    
    private func applicationButtonAction(model: PastJobs) {
        if let status = JobStatus.init(rawValue: model.status) {
            if (status == .expired) {
                self.viewModel.getRepublishJobDetails(jobId: model.jobId, status: status.rawValue.uppercased(), canOpenRepublish: true)
            }else {
                if let jobData = model.jobData {
                    self.goToRateTradieVC(jobName: model.jobName, jobData: jobData, tradieData: model.tradieData)
                }
            }
        }
    }
    
    private func forwardButtonAction(model: PastJobs) {
        if let status = JobStatus.init(rawValue: model.status), let screenType: ScreenType = (status == .expired) ? .pastJobsExpired : .pastJobsCompleted {
            if status == .expired {
                self.viewModel.getRepublishJobDetails(jobId: model.jobId, status: status.rawValue.uppercased())
            }else {
                self.goToDetailVC(model.jobId, screenType: screenType, status: status.rawValue.uppercased())
            }
        }
    }
    
    func goToRewiewVC(indexPath: IndexPath) {
        let status = viewModel.pastJobTradieModel?.result.completed[indexPath.row].status ?? ""
        if status != "CANCELLED" && status != "EXPIRED" {
            let reviewVC = ReviewBuilderVC.instantiate(fromAppStoryboard: .profile)
            reviewVC.jobData = viewModel.pastJobTradieModel?.result.completed[indexPath.row]
            push(vc: reviewVC)
        }
    }
    
    func hitPaginationClosure() {
        viewModel.hitPagination = { [weak self] in
            guard let self = self else { return }
            self.hitApi(showLoader: false)
        }
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        if kUserDefaults.isTradie() {
            viewModel.getJobs(status: .pastTradie, showLoader: false, isPullToRefresh: true)
        } else {
            viewModel.getJobs(status: .past, showLoader: false, isPullToRefresh: true)
        }
    }
}

extension PastJobsVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kUserDefaults.isTradie() {
            return viewModel.pastJobTradieModel?.result.completed.count ?? 0
        } else {
            return viewModel.pastJobBuilderModel?.result.past?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if kUserDefaults.isTradie() {
            let cell = tableView.dequeueCell(with: JobStatusCell.self)
            viewModel.hitPagination(index: indexPath.row, type: .pastTradie)
            cell.completedJob = viewModel.pastJobTradieModel?.result.completed[indexPath.row]
            cell.rateBuilderAction = { [weak self] in
                self?.goToRewiewVC(indexPath: indexPath)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(with: JobStatusTableCell.self)
            cell.tableView = tableView
            viewModel.hitPagination(index: indexPath.row, type: .past)
            if let model = viewModel.pastJobBuilderModel?.result.past?[indexPath.row] {
                cell.pastJobsModel = model
            }
            ///
            cell.buttonClosure = { [weak self] (buttonType, index) in
                guard let self = self else { return }
                switch buttonType {
                case .forward:
                    if let model = self.viewModel.pastJobBuilderModel?.result.past?[index.row] {
                        self.forwardButtonAction(model: model)
                    }
                case .application:
                    if let model = self.viewModel.pastJobBuilderModel?.result.past?[index.row] {
                        self.applicationButtonAction(model: model)
                    }
                case .quotes:
                    printDebug("QuotesType")
                }
            }
            return cell
        }        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if kUserDefaults.isTradie() {
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            let model = viewModel.pastJobTradieModel?.result.completed[indexPath.row]
            jobDetailVC.screenType = .activeJobDetail            
            jobDetailVC.jobId = model?.jobId ?? ""            
            push(vc: jobDetailVC)
        } else {
            if let model = self.viewModel.pastJobBuilderModel?.result.past?[indexPath.row] {
                self.forwardButtonAction(model: model)
            }
        }
    }
}

extension PastJobsVC: JobDashboardVMDelegate {
    
    func successPastJobsTradie() {
        if viewModel.pastJobTradieModel?.result.completed.count == 0 {
            showWaterMarkLabel(message: "You have not completed any job!")
        } else {
            hideWaterMarkLabel()
        }
        NotificationCenter.default.post(name: NotificationName.refreshJobCount, object: nil, userInfo: [ApiKeys.jobCount: viewModel.pastJobTradieModel?.result.newJobsCount ?? 0, ApiKeys.milestoneCount: viewModel.pastJobTradieModel?.result.milestonesCount ?? 0])
        mainQueue { [weak self] in
            self?.refresher.endRefreshing()
            self?.tableViewOutlet.reloadData()
        }
    }

    func successPastJobsBuilder() {
        self.viewModel.pastJobBuilderModel?.result.past?.count ?? 0 == 0 ? showWaterMarkLabel(message: "No past jobs yet!") : hideWaterMarkLabel()
        self.updateDashBoardCount?(self.viewModel.pastJobBuilderModel?.result.newApplicantsCount ?? 0, self.viewModel.pastJobBuilderModel?.result.needApprovalCount ?? 0)
        mainQueue { [weak self] in
            self?.refresher.endRefreshing()
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func success(model: RepublishJobResult, jobId: String, status: String, canOpenRepublish: Bool) {
        canOpenRepublish ?
            goToCreateJobVC(jobId, screenType: .pastJobsExpired, status: status, republishModel: model) :
            goToDetailVC(jobId, screenType: .pastJobsExpired, status: status, republishModel: model)
    }
    
    func failure(message: String) {
        refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(message)
    }
}

extension PastJobsVC: ReviewTradePeopleVCDelegate {
    
    func getRatedJob(id: String) {
        let index = viewModel.pastJobBuilderModel?.result.past?.firstIndex(where: { eachModel -> Bool in
            return eachModel.jobId == id
        })
        
        if let index = index {
            viewModel.pastJobBuilderModel?.result.past?[index].isRated = true
            tableViewOutlet.reloadData()
        }
    }
}
