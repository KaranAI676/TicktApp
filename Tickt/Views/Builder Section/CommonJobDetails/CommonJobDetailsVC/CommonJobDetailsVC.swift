//
//  CommonJobDetailsScreen.swift
//  Tickt
//
//  Created by S H U B H A M on 21/05/21.
//

import UIKit
protocol OpenQuotesJobsVCDelegate: AnyObject {
    func removedQuoteJob(jobId: String, status: AcceptDecline,index:IndexPath)
}

class CommonJobDetailsVC: BaseVC {
    
    enum CellTypes {
        case cancellation
        case crRejection
        case grid
        case photos
        case jobType
        case details
        case category
        case postedBy
        case question
        case milestones
        case bottomButton
        case specialisation
        case quotes
    }
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    ///
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editMilestoneButton: UIButton!
    
    @IBOutlet weak var editMilestoneView: UIView!
    @IBOutlet weak var cancelJobView: UIView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    
    var jobId = ""
    var pastJobStatus: String = ""
    var jobDetail: JobDetailsModel?
    var republishModel: RepublishJobResult?
    var viewModel = CommonJobDetailsVM()
    var screenType: ScreenType = .openJobs
    var cellsArray: [CellTypes] = []
    var quoteIndex=IndexPath()
    weak var delegate:OpenQuotesJobsVCDelegate?
    
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        popUpView.popOut()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popUpView.popOut()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    @objc func refreshData() {
        delay(time: 0.7) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
        hitApi()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
            disableButton(sender)
        case editButton:
            if screenType == .openJobs {
               // if jobDetail?.result?.quoteJob ?? false{
                    viewModel.getOpenQuoteJobDetails(jobId: jobId)
                    editLabel.text = "Edit"
                    editLabel.textAlignment = .left
                    deleteLabel.text = "Delete"
                    popUpView.isHidden = false
                //}
            } else {
                if republishModel.isNil {
                    viewModel.getRepublishJobDetails(jobId: jobId)
                } else {
                    goToCreateJobVC()
                }
            }
        case editMilestoneButton:
            popUpView.popOut()
            goToCreateJobVC()
        case cancelButton:
            AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertMessage: "Are you sure you want to delete the job?", completion: {
                self.viewModel.deleteQuote(jobId: self.jobId, index: self.quoteIndex)
            })
            popUpView.popOut()
        default:
            break
        }
    }
}

extension CommonJobDetailsVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        if screenType == .openJobs {
            editButton.isHidden = false
        }else{
            editButton.isHidden = !(screenType == .pastJobsExpired)
        }
        popUpView.alpha = 0
        setupTableView()
        hitApi()
    }
    
    func hitApi() {
        viewModel.getOpenJobDetails(jobId: jobId)
    }
    
    func setupTableView() {
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        ///
        tableViewOutlet.addSubview(refreshControl)
        tableViewOutlet.registerCell(with: GridCell.self)
        tableViewOutlet.registerCell(with: ApplyJobCell.self)
        tableViewOutlet.registerCell(with: PostedByCell.self)
        tableViewOutlet.registerCell(with: GridInfoTableCell.self)
        tableViewOutlet.registerCell(with: TitleLabelTableCell.self)
        tableViewOutlet.registerCell(with: BottomButtonTableCell.self)
        tableViewOutlet.registerCell(with: CancellationTableCell.self)
        tableViewOutlet.registerCell(with: QuestionButtonTableCell.self)
        tableViewOutlet.registerCell(with: JobQuotesCell.self)
        tableViewOutlet.registerCell(with: DetailsWithTitleTableCell.self)
        tableViewOutlet.registerCell(with: MilestoneListingTableCell.self)
        tableViewOutlet.registerCell(with: TradeWithDescriptionTableCell.self)
        tableViewOutlet.registerCell(with: DynamicHeightCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewWithTitleTableCell.self)
    }
    
    private func setupPopupView() {
        guard let model = jobDetail else {
            popUpView.isHidden = true
            return
        }
        if screenType == .openJobs {
            editButton.isHidden = false
        } else {
            cancelJobView.isHidden = !(JobStatus.init(rawValue: model.result?.status ?? "") == .active)
        }
    }
    
    private func goToCreateJobVC() {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        if let model = republishModel {
            var createJobModel = CreateJobModel(model: model)
            createJobModel.jobId = jobId
            kAppDelegate.postJobModel = createJobModel
            
        }
        if screenType == .openJobs { //jobDetail?.result?.quoteJob ?? false{
            vc.screenType = .editQuoteJob
        }else{
            vc.screenType = .republishJob
        }
        push(vc: vc)
    }
    
    func goToQuestionBuilderVC() {
        let vc = QuestionListingBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.jobId = jobDetail?.result?.jobId ?? ""
        vc.jobName = jobDetail?.result?.jobName ?? ""
        vc.isJobExpired = screenType == .pastJobsExpired || screenType == .pastJobsCompleted
        push(vc: vc)
    }
    
    func goToJobQuotesVC() {
        //    let vc = OpenJobsApplicationsVC.instantiate(fromAppStoryboard: .openJobsApplications)
        let vc = QuotesListingVC.instantiate(fromAppStoryboard: .jobQuotes)
        var jobModel = BasicJobModel()
        jobModel.tradeName = jobDetail?.result?.tradeName ?? ""
        jobModel.jobName = jobDetail?.result?.jobName ?? ""
        jobModel.tradeImage = jobDetail?.result?.tradeSelectedUrl ?? ""
        jobModel.jobFromDate = jobDetail?.result?.fromDate ?? ""
        jobModel.jobToDate = jobDetail?.result?.toDate ?? ""
        jobModel.jobId = jobDetail?.result?.jobId ?? ""
        jobModel.quoteJob = jobDetail?.result?.quoteJob ?? true
        jobModel.quoteCount = jobDetail?.result?.quoteCount ?? 0
        vc.jobModel = jobModel
        push(vc: vc)
    }
    
    func goToPreviewVC(url: String) {
        let previewVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
        previewVC.urlString = url
        push(vc: previewVC)
    }
    
    func goToNextVC() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
            mainQueue { [weak self] in
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            pop()
        }
    }
    
    private func showDeclineView() {
        let declineView = DeclineRequestView.instantiate(fromAppStoryboard: .jobPosting)
        declineView.modalPresentationStyle = .overCurrentContext
        declineView.declineRequestClosure = { [weak self] note in
            guard let self = self else { return }
            if let jobId = self.jobDetail?.result?.jobId {
                self.viewModel.acceptRejectCancelRequest(jobId: jobId, status: .decline, note: note)
            }
        }
        present(declineView, animated: true, completion: nil)
    }
    
    func handleCancelltionRequest(jobId: String, type: CancellationTableCell.ButtonTypes) {
        switch type {
        case .accept:
            AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure, you want to end this job?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
                self.viewModel.acceptRejectCancelRequest(jobId: jobId, status: (type == .accept) ? .accept : .decline)
            } dismissCompletion: { }
        case .reject:
            showDeclineView()
        }
    }
}

extension CommonJobDetailsVC: CommonJobDetailsVMDelegate {
    //MARK:- DELETE QUOTE DELEGATE
    func deleteJob(status: Bool, index: IndexPath) {
        if status{
            delegate?.removedQuoteJob(jobId: jobId, status: .accept, index: index)
            pop()
        }else{
            CommonFunctions.showToastWithMessage("Error")
        }
    }
        
    func republishSuccess(model: RepublishJobResult) {
        republishModel = model
        if screenType == .openJobs { //jobDetail?.result?.quoteJob ?? false {
            popUpView.popIn()
        } else {
            goToCreateJobVC()
        }
    }
    
    func cancelRequestSuccess(status: AcceptDecline) {
        let quoteJob = jobDetail?.result?.quoteJob ?? false
        if quoteJob {
            switch status {
            case .accept:
                let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
                vc.screenType = .quoteClose
                vc.jobId = jobId
                vc.tradieId = jobDetail?.result?.quote?.first?.tradieId ?? ""
                push(vc: vc)
            case .decline:
                jobDetail?.result?.isCancelJobRequest = false
                cellsArray = getCellArray()
                tableViewOutlet.reloadData()
            }
        } else {
            goToNextVC()
        }
    }
    
    func openJobDetails(model: JobDetailsModel) {
        jobDetail = model
        let canEditJob = model.result?.editJob ?? false
        if (model.result?.quoteCount ?? 0 > 0) || (model.result?.isInvited ?? false) || !canEditJob {
            print("dont show pencil icon because tradie is envoled")
        } else {
            setupPopupView()
        }
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.cellsArray = self.getCellArray()
            self.tableViewOutlet.reloadData {
                self.tableViewOutlet.reloadData()
            }
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
