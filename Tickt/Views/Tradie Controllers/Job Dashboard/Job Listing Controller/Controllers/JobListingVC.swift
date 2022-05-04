//
//  JobListingVC.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//

class JobListingVC: BaseVC {
    
    enum ScreenTypee {
        case newJob
        case allJobs
        case savedjobs
        case allReviews
        case newMilestone
        case loggedInBuilder
    }
    
    @IBOutlet weak var titleLabel: CustomBoldLabel!    
    @IBOutlet weak var jobTableView: UITableView!
            
    var pageIndex = 1
    var builderId = ""
    var allJobsCount = 0
    var allReviewsCount = 0
    let viewModel = JobListingVM()    
    var screenType: ScreenTypee = .newJob
    
    var isMyProfile = false
    
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        jobTableView.refreshControl = refreshControl
        viewModel.delegate = self
        viewModel.tableViewOutlet = jobTableView
        hitPaginationClosure()
        switch screenType {
        case .newJob:
            titleLabel.text = "New job(s)"
            jobTableView.registerCell(with: SearchListCell.self)
            viewModel.getNewJobs(isPullToRefresh: false)
        case .allJobs:
            jobTableView.backgroundColor = .clear
            titleLabel.text = "\(allJobsCount) job(s)"
            jobTableView.registerCell(with: SearchListCell.self)
            viewModel.getBuildersJobs(isPullToRefresh: false, builderId: builderId)
        case .allReviews:
            view.backgroundColor = .white
            titleLabel.text = "\(allReviewsCount) reviews"
            jobTableView.registerCell(with: ReviewCell.self)
            jobTableView.registerCell(with: ReviewReplyCell.self)
            jobTableView.registerHeaderFooter(with: ReviewHeaderView.self)
            jobTableView.estimatedSectionHeaderHeight = 300
            jobTableView.sectionHeaderHeight = UITableView.automaticDimension
            viewModel.getBuildersReviews(isPullToRefresh: false, builderId: builderId)
        case .newMilestone:
            titleLabel.text = "Approved milestone"
            jobTableView.registerCell(with: JobStatusCell.self)
            viewModel.getApprovedMilestones(isPullToRefresh: false)
        case .loggedInBuilder:
            titleLabel.text = "\(allJobsCount) job(s)"
            jobTableView.registerCell(with: SearchListCell.self)
            jobTableView.backgroundColor = .clear
            viewModel.getLoggedInBuilderJobs()
        case .savedjobs:
            view.backgroundColor = UIColor(hex: "#F6F7F9")
            jobTableView.backgroundColor = UIColor(hex: "#F6F7F9")
            titleLabel.text = "Saved job(s)"
            jobTableView.registerCell(with: SearchListCell.self)
            viewModel.getSavedJobs(isPullToRefresh: false)
        }
    }
    
    private func hitPaginationClosure() {
        viewModel.hitPaginationClosure = { [weak self] in
            guard let self = self else { return }
            switch self.screenType {
            case .newJob:
                self.viewModel.getNewJobs(showLoader: false, isPullToRefresh: false)
            case .allJobs:
                self.viewModel.getBuildersJobs(showLoader: false, isPullToRefresh: false, builderId: self.builderId)
            case .savedjobs:
                self.viewModel.getSavedJobs(showLoader: false, isPullToRefresh: false)
            case .allReviews:
                self.viewModel.getBuildersReviews(showLoader: false, isPullToRefresh: false, builderId: self.builderId)
            case .newMilestone:
                self.viewModel.getApprovedMilestones(showLoader: false, isPullToRefresh: false)
            case .loggedInBuilder:
                self.viewModel.getLoggedInBuilderJobs(showLoader: false)
            }
        }
    }
    
    @objc func refreshData() {
        pageIndex = 1        
        switch screenType {
        case .newJob:
            viewModel.getNewJobs(showLoader: false, isPullToRefresh: true)
        case .allJobs:            
            viewModel.getBuildersJobs(showLoader: false, isPullToRefresh: true, builderId: builderId)
        case .allReviews:
            viewModel.getBuildersReviews(showLoader: false, isPullToRefresh: true, builderId: builderId)
        case .newMilestone:
            viewModel.getApprovedMilestones(showLoader: false, isPullToRefresh: true)
        case .loggedInBuilder:
            viewModel.getLoggedInBuilderJobs(showLoader: false, isPullToRefresh: true)
        case .savedjobs:
            viewModel.getSavedJobs(showLoader: false, isPullToRefresh: true)
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        pop()
    }
    
    func goToDetailVC(_ jobId: String, screenType: ScreenType, status: String, republishModel: RepublishJobResult? = nil) {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = screenType
        vc.jobId = jobId
        vc.pastJobStatus = status
        vc.republishModel = republishModel
        self.push(vc: vc)
    }
}
