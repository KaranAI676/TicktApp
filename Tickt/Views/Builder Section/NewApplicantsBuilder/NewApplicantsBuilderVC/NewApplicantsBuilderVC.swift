//
//  NewApplicantsBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 16/05/21.
//

import UIKit

protocol NewApplicantsBuilderVCDelegate: AnyObject {
    func getNewApplicantCount(count: Int)
}

class NewApplicantsBuilderVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    weak var delegate: NewApplicantsBuilderVCDelegate? = nil
    var viewModel = NewApplicantBuilderVM()
    var screenType: ScreenType = .newApplicatants
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        if screenType == .newApplicatants, let count = self.viewModel.modelNewApplicant?.result.count {
            self.delegate?.getNewApplicantCount(count: count)
        }
        self.pop()
        disableButton(sender)
    }
}


extension NewApplicantsBuilderVC {
    
    private func initialSetup() {
        self.setupUI()
        self.viewModel.delegate = self
        self.viewModel.tableViewOutlet = tableViewOutlet
        self.hitPagination()
        let _ = screenType == .newApplicatants ? self.viewModel.getNewApplicantsList() : self.viewModel.getNeedApprovalList()
        self.setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: NotificationName.refreshNewApplicant, object: nil)
    }
    
    private func hitPagination() {
        viewModel.hitPagination = { [weak self] in
            guard let self = self else { return }
            let _ = self.screenType == .newApplicatants ?
                self.viewModel.getNewApplicantsList(showLoader: false) :
                self.viewModel.getNeedApprovalList(showLoader: false)
        }
    }
    
    private func setupTableView() {
        self.tableViewOutlet.registerCell(with: JobStatusTableCell.self)
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        self.tableViewOutlet.refreshControl = refresher
    }
    
    private func setPlaceholder() {
        self.placeHolderImage.isHidden = screenType == .newApplicatants ? ((self.viewModel.modelNewApplicant?.result.count ?? 0) > 0) : ((self.viewModel.modelNeedApproval?.result.count ?? 0) > 0)
        self.tableViewOutlet.isHidden = !self.placeHolderImage.isHidden
    }
    
    private func setupUI() {
        switch screenType {
        case .newApplicatants:
            self.screenTitleLabel.text = "New applicants"
        case .needApproval:
            self.screenTitleLabel.text = "Need approval"
        default:
            break
        }
    }
    
    private func forwardButtonAction(_ index: Int) {
        switch screenType {
        case .newApplicatants:
            if let jobId = self.viewModel.modelNewApplicant?.result[index].jobId {
                self.goToPreviewDetailVC(jobId, screenType: .openJobs)
            }
        case .needApproval:
            if let jobId = self.viewModel.modelNeedApproval?.result[index].jobId {
                goToCheckApproveVC(jobId)
//                self.goToPreviewDetailVC(jobId, screenType: .activeJob)
            }
        default:
            break
        }
    }
    
    private func applicationButtonAction(_ index: Int) {
        switch screenType {
        case .newApplicatants:
            if let model = self.viewModel.modelNewApplicant?.result[index] {
                self.goToJobApplicationVC(model)
            }
        case .needApproval:
            if let jobId = self.viewModel.modelNeedApproval?.result[index].jobId {
                goToCheckApproveVC(jobId)
            }
        default:
            break
        }
    }
    
    private func goToCheckApproveVC(_ jobId: String) {
        let vc = CheckApproveBuilderVC.instantiate(fromAppStoryboard: .checkApproveBuilder)
        vc.jobId = jobId
        self.push(vc: vc)
    }
    
    private func goToPreviewDetailVC(_ jobId: String, screenType: ScreenType) {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.jobId = jobId
        vc.screenType = screenType
        push(vc: vc)
    }
    
    private func goToJobApplicationVC(_ model: NewApplicantResult) {
        let vc = OpenJobsApplicationsVC.instantiate(fromAppStoryboard: .openJobsApplications)
        var jobModel = BasicJobModel()
        jobModel.tradeName = model.tradeName
        jobModel.jobName = model.jobName
        jobModel.tradeImage = model.tradeSelectedUrl
        jobModel.jobFromDate = model.fromDate
        jobModel.jobToDate = model.toDate
        jobModel.jobId = model.jobId
        vc.jobModel = jobModel
        vc.delegate = self
        vc.isQuoteJob = model.quoteJob
        push(vc: vc)
    }
    
    private func goToJobQuotesVC(_ model: NewApplicantResult) {
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
}


extension NewApplicantsBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setPlaceholder()
        return screenType == .newApplicatants ? self.viewModel.modelNewApplicant?.result.count ?? 0 : self.viewModel.modelNeedApproval?.result.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueCell(with: JobStatusTableCell.self)
        cell.tableView = tableView
        viewModel.hitPagination(index: indexPath.row, screenType: screenType)
        
        if let model = self.viewModel.modelNewApplicant?.result[indexPath.row], screenType == .newApplicatants {
            cell.newApplicantsModel = model
        }
        
        if let model = self.viewModel.modelNeedApproval?.result[indexPath.row], screenType == .needApproval {
            cell.needApprovalModel = model
        }
        
        cell.buttonClosure = { [weak self] (type, index) in
            guard let self = self else { return }
            switch type {
            case .application:
                self.applicationButtonAction(index.row)
            case .forward:
                self.forwardButtonAction(index.row)
            case .quotes:
                if let model = self.viewModel.modelNewApplicant?.result[index.row] {
                    if model.quoteCount == 0 {
//                        self.goToJobQuotesVC(model)
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


//MARK:- Selector Methods
//=======================
extension NewApplicantsBuilderVC {
    
    @objc func pullToRefresh() {
        switch screenType {
        case .needApproval:
            self.viewModel.getNeedApprovalList(showLoader: false, isPullToRefresh: true)
        case .newApplicatants:
            self.viewModel.getNewApplicantsList(showLoader: false, isPullToRefresh: true)
        default:
            break
        }
    }
    
    @objc func refreshScreen() {
        switch screenType {
        case .needApproval:
            self.viewModel.getNeedApprovalList()
        case .newApplicatants:
            self.viewModel.getNewApplicantsList()
        default:
            break
        }
    }
}

extension NewApplicantsBuilderVC: NewApplicantBuilderVMDelegate {

    func successNeedsApproval(model: NeedApprovalBuilderModel) {
        self.refresher.endRefreshing()
        self.tableViewOutlet.reloadData()
    }
    
    func successNewApplicant() {
        self.refresher.endRefreshing()
        self.tableViewOutlet.reloadData()
    }
    
    func failure(message: String) {
        self.refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(message)
    }
}

extension NewApplicantsBuilderVC: OpenJobsApplicationsVCDelegate {
    
    func removedEmptyJob(jobId: String, status: AcceptDecline) {
        let index = self.viewModel.modelNewApplicant?.result.firstIndex(where: { eachMode -> Bool in
                return eachMode.jobId == jobId
        })
        
        if let index = index {
            self.viewModel.modelNewApplicant?.result.remove(at: index)
            self.tableViewOutlet.reloadData()
        }
    }
}

extension NewApplicantsBuilderVC: OpenJobsQuotesVCDelegate {
    
    func removedEmptyQuotes(jobId: String, status: AcceptDecline) {
//        let index = self.self.viewModel.openBuilderModel?.result.open?.firstIndex(where: { eachModel in
//            return eachModel.jobId == jobId
//        })
//
//        if let index = index {
//            self.viewModel.openBuilderModel?.result.open?.remove(at: index)
//            updateNewApplicantRemovedJob?()
//            tableViewOutlet.reloadData()
//        }
    }
}
