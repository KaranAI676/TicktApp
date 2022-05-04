//
//  ActiveJobsVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/05/21.
//

import UIKit

class ActiveJobsVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK:- Variables
    var updateDashBoardCount: ((_ new: Int, _ need: Int)->Void)? = nil
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
            NotificationCenter.default.addObserver(self, selector: #selector(refreshJob(_:)), name: NotificationName.refreshActiveList, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func refreshJob(_ notification: Notification) {
        pullToRefresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ActiveJobsVC {
    
    private func initialSetup() {
        setupTableView()
        hitApi()
    }
    
    private func setupTableView() {
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.contentInset.bottom = 20
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.registerCell(with: JobStatusCell.self)
        tableViewOutlet.registerCell(with: JobStatusTableCell.self)
    }
    
    private func hitApi(showLoader: Bool = true) {
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        hitPaginationClosure()
        if kUserDefaults.isTradie() {
            viewModel.getJobs(status: .activeTradie, showLoader: showLoader)
        } else {
            viewModel.getJobs(status: .active, showLoader: showLoader)
        }
    }
    
    private func goToCheckApproveVC(_ jobId: String) {
        let vc = CheckApproveBuilderVC.instantiate(fromAppStoryboard: .checkApproveBuilder)
        vc.jobId = jobId
        self.push(vc: vc)
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
            viewModel.getJobs(status: .activeTradie, showLoader: false, isPullToRefresh: true)
        } else {
            viewModel.getJobs(status: .active, showLoader: false, isPullToRefresh: true)
        }
    }
}

extension ActiveJobsVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kUserDefaults.isTradie() {
            return viewModel.activeTradieModel?.result.active.count ?? 0
        } else {
            return viewModel.activeBuilderModel?.result.active?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if kUserDefaults.isTradie() {
            let cell = tableView.dequeueCell(with: JobStatusCell.self)
            viewModel.hitPagination(index: indexPath.row, type: .activeTradie)
            cell.activeJobs = viewModel.activeTradieModel?.result.active[indexPath.row]
            cell.viewQuoteAction = { [weak self] in
                let vc = ViewQuoteVC.instantiate(fromAppStoryboard: .quotes)
                vc.jobObject = self?.viewModel.activeTradieModel?.result.active[indexPath.row]
                self?.push(vc: vc)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(with: JobStatusTableCell.self)
            cell.tableView = tableView
            viewModel.hitPagination(index: indexPath.row, type: .active)
            if let model = viewModel.activeBuilderModel?.result.active?[indexPath.row] {
                cell.activeJobModel = model
            }
            ///
            cell.buttonClosure = { [weak self] (buttonType, index) in
                guard let self = self else { return }
                switch buttonType {
                case .forward:
                    if let model = self.viewModel.activeBuilderModel?.result.active?[index.row] {
                        self.goToCheckApproveVC(model.jobId)
                    }
                case .application:
                    if let model = self.viewModel.activeBuilderModel?.result.active?[index.row] {
                        self.goToCheckApproveVC(model.jobId)
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
            let milestoneVC = MilestoneVC.instantiate(fromAppStoryboard: .jobDashboard)
            milestoneVC.jobId = viewModel.activeTradieModel?.result.active[indexPath.row].jobId ?? ""
            MilestoneVC.recommmendedJob = viewModel.activeTradieModel?.result.active[indexPath.row] ?? RecommmendedJob()
            milestoneVC.tradeId = viewModel.activeTradieModel?.result.active[indexPath.row].tradeId ?? ""
            milestoneVC.specializationId = viewModel.activeTradieModel?.result.active[indexPath.row].specializationId ?? ""
            push(vc: milestoneVC)
        } else {
            if let model = self.viewModel.activeBuilderModel?.result.active?[indexPath.row] {
                self.goToCheckApproveVC(model.jobId)
            }
        }
    }
}

extension ActiveJobsVC: JobDashboardVMDelegate {
    
    func successActiveTradie() {
        if viewModel.activeTradieModel?.result.active.count == 0 {
            showWaterMarkLabel(message: "No active jobs yet!")
        } else {
            hideWaterMarkLabel()
        }
        NotificationCenter.default.post(name: NotificationName.refreshJobCount, object: nil, userInfo: [ApiKeys.jobCount: viewModel.activeTradieModel?.result.newJobsCount ?? 0, ApiKeys.milestoneCount: viewModel.activeTradieModel?.result.milestonesCount ?? 0])
        mainQueue { [weak self] in
            self?.refresher.endRefreshing()
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func successActiveBuilder() {
        self.viewModel.activeBuilderModel?.result.active?.count ?? 0 == 0 ? showWaterMarkLabel(message: "No active jobs yet!") : hideWaterMarkLabel()
        self.updateDashBoardCount?(self.viewModel.activeBuilderModel?.result.newApplicantsCount ?? 0, self.viewModel.activeBuilderModel?.result.needApprovalCount ?? 0)
        mainQueue { [weak self] in
            self?.refresher.endRefreshing()
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func failure(message: String) {
        refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(message)
    }
}
