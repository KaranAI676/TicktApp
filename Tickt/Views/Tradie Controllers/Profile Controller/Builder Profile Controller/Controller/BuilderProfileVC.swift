//
//  BuilderProfileVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

class BuilderProfileVC: BaseVC {
        
    enum CellTypes {
        case area
        case jobs
        case about
        case detail
        case review
        case portfolio
    }
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var jobId = ""
    var jobName = ""
    var builderId = ""
    var profileModel: ProfileModel?
    var cellArray: [CellTypes] = []
    var headerTitles: [String] = []
    var photosArray: [String]? = nil
    let viewModel = BuilderProfileVM()
    
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
        profileTableView.registerCell(with: ReviewCell.self)
        profileTableView.registerCell(with: SearchListCell.self)
        profileTableView.registerCell(with: SingleLabelCell.self)
        profileTableView.registerCell(with: ProfileDetailCell.self)
        profileTableView.registerCell(with: PortfolioTableCell.self)
        profileTableView.registerCell(with: DynamicCollectionView.self)
        profileTableView.registerCell(with: CommonCollectionViewTableCell.self)
        profileTableView.registerHeaderFooter(with: SearchHeaderView.self)
        profileTableView.registerHeaderFooter(with: ProfileFooterView.self)
        profileTableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        viewModel.delegate = self
        profileTableView.refreshControl = refreshControl
        hitAPI()
    }
    
    func hitAPI() {
        viewModel.getBuilderProfile(isPullToRefresh: true, builderId: builderId)
    }
    
    @objc func refreshData() {
        viewModel.getBuilderProfile(isPullToRefresh: false, builderId: builderId)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        pop()
    }
}
