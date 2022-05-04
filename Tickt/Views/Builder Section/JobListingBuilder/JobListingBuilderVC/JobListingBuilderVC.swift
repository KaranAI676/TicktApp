//
//  JobListingBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 16/06/21.
//

import UIKit

protocol JobListingBuilderVCDelegate: AnyObject {
    func getInvitationId(invitationModel: InvitationResultModel)
    func getCancelInvitationUpdate(isInvited: Bool)
    func getJobData(jobData: JobListingBuilderResult)
}

extension JobListingBuilderVCDelegate {
    func getInvitationId(invitationModel: InvitationResultModel) {}
    func getCancelInvitationUpdate(isInvited: Bool) {}
    func getJobData(jobData: JobListingBuilderResult) {}
}

class JobListingBuilderVC: BaseVC {
    
    enum ScreenType {
        case forLeaveVouch
        case forInvite
        case forCancelInvite
        
        var emptyDataText: String {
            switch self {
            case .forLeaveVouch:
                return "No completed job with this tradespeople"
            case .forInvite:
                return "No open jobs found"
            case .forCancelInvite:
                return "No jobs found"
            }
        }
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
        
    var tradieId: String = ""
    var delegate: JobListingBuilderVCDelegate? = nil
    var model: JobListingBuilderModel? = nil
    var viewModel = JobListingBuilderVM()
    var screenType: ScreenType = .forInvite
    var selectedJobId: String = ""
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJobs(_:)), name: NotificationName.newJobCreated, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            self.pop()
        case bottomButton:
            switch screenType {
            case .forInvite:
                if (model?.result.isEmpty ?? false) {
                    goToCreateJobVC()
                } else if let index = validate() {
                    viewModel.inviteTradie(tradieId: tradieId, jobId: model?.result[index].jobId ?? "")
                }
            case .forLeaveVouch:
                if let index = validate(), let jobData = model?.result[index] {
                    delegate?.getJobData(jobData: jobData)
                    pop()
                }
            case .forCancelInvite:
                break
            }
        default:
            break
        }
    }
}

extension JobListingBuilderVC {
    
    private func initialSetup() {
        setupTableView()
        bottomButton.isHidden = true
        bottomButton.setTitleForAllMode(title: "")
        viewModel.delegate = self
        viewModel.getJobList(tradieId: tradieId, type: screenType)
    }
    
    private func setupTableView() {
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.refreshControl = refresher
        ///
        self.tableViewOutlet.registerCell(with: MilestoneTableCell.self)
    }
    
    private func setUI() {
        switch screenType {
        case .forInvite:
            bottomButton.isHidden = false
            bottomButton.setTitleForAllMode(title: (model?.result.isEmpty ?? false) ? "Post new job" : "Invite for job")
        case .forCancelInvite:
            bottomButton.isHidden = true
        case .forLeaveVouch:
            bottomButton.setTitleForAllMode(title: "Choose  job")
            bottomButton.isHidden = (model?.result.isEmpty ?? true)
        }
    }
    
    private func goToSuccessVC() {
        delegate?.getCancelInvitationUpdate(isInvited: true)
        for i in 0..<(self.model?.result.count ?? 0) {
            model?.result[i].isSelected = false
        }
        tableViewOutlet.reloadData()
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .invitedTradieFromBuilder
        push(vc: vc)
    }
    
    private func CancelInvitation(_ index: Int) {
        
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                             alertTitle: "Invitation",
                                             alertMessage: "Are you sure want to cancel invitation?",
                                             acceptButtonTitle: "Cancel",
                                             declineButtonTitle: "Discard") {
            if let jobId = self.model?.result[index].jobId, let invitationId = self.model?.result[index].invitationId {
                self.viewModel.cancelInvite(tradieId: self.tradieId, jobId: jobId, invitationId: invitationId, index: index)
            }
        } dismissCompletion: {
            
        }    
    }
    
    private func goToCreateJobVC() {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overCurrentContext
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getJobList(tradieId: tradieId, type: screenType, pullToRefresh: true)
    }
    
    @objc private func refreshJobs(_ notification: Notification) {
        viewModel.getJobList(tradieId: tradieId, type: screenType)
//        if let userInfo = notification.userInfo, let jobModel = userInfo["model"] as? JobListingBuilderResult {
//            model?.result.append(jobModel)
//            setUI()
//            tableViewOutlet.reloadData()
//        }
    }
}

extension JobListingBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: MilestoneTableCell.self)
        cell.tableView = tableView
        cell.jobListModel = self.model?.result[indexPath.row]
        if screenType == .forCancelInvite, (model?.result[indexPath.row].isSelected ?? false) {
            cell.cancelInvitationButton.isHidden = false
        } else {
            cell.cancelInvitationButton.isHidden = true
        }
        cell.cancelButtonClosure = { [weak self] index in
            guard let self = self else { return }
            self.CancelInvitation(index.row)
        }
        ///
        cell.selectionButtonClosureWithBool = { [weak self] index, bool in
            guard let self = self else { return }
            for i in 0..<(self.model?.result.count ?? 0) {
                self.model?.result[i].isSelected = false
            }
            self.model?.result[index.row].isSelected = bool
            self.tableViewOutlet.reloadData()
        }
        return cell
    }
}

extension JobListingBuilderVC: JobListingBuilderVMDelegate {
    
    func successCancelInvite(index: Int) {
        model?.result.remove(at: index)
        tableViewOutlet.reloadData()
        if model?.result.count == 0 {
            delegate?.getCancelInvitationUpdate(isInvited: false)
        }
        model?.result.count == 0 ? showWaterMarkLabel(message: "No jobs found") : hideWaterMarkLabel()
    }
    
    func successInvite(invitationModel: InvitationResultModel) {
        delegate?.getInvitationId(invitationModel: invitationModel)
        goToSuccessVC()
    }
    
    func successGetJobs(model: JobListingBuilderModel) {
        self.model = model
        tableViewOutlet.reloadData()
        refresher.endRefreshing()
        model.result.count == 0 ? showWaterMarkLabel(message: screenType.emptyDataText) : hideWaterMarkLabel()
        
        setUI()
        if screenType == .forLeaveVouch,
           !selectedJobId.isEmpty,
           let index = model.result.firstIndex(where: { eachModel -> Bool in
            return eachModel.jobId == selectedJobId
           }) {
            self.model?.result[index].isSelected = true
            tableViewOutlet.reloadData()
        }
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        refresher.endRefreshing()
    }
}

extension JobListingBuilderVC {
    
    private func validate() -> Int? {
        
        let selectedTradieIndex = model?.result.firstIndex(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        
        if selectedTradieIndex == nil {
            CommonFunctions.showToastWithMessage("Please choose a job")
        }
        
        return selectedTradieIndex
    }
}
