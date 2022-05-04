//
//  TradieHomeVC.swift
//  Tickt
//
//  Created by Admin on 25/03/21.
//

import UIKit
import CoreLocation

class TradieHomeVC: BaseVC {
        
    enum CellTypes {
        case topSection
        case jobs
        case recommentedJobs
        case categories
        case savedTradies
        case recommendedTradespeople
    }
        
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var badgeCountLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var searchTextField: CustomRegularField!
    
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
    var jobModel: JobModel?
    var tradeModel: TradeModel?
    var cellArray = [CellTypes]()
    var viewModel = TradieHomeVM()
    var selectedIndexOfTrade: Int? = nil
    var homeBuilderModel: BuilderHomeModel?
    var recommendedModel: RecommmendedJobModel?
    var currentLocation = CLLocationCoordinate2D(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        badgeView.makeCircular()
        badgeView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.searchModel = SearchModel()
        homeTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case notificationButton:
            let vc = NotificationBuilderVC.instantiate(fromAppStoryboard: .notificationBuilder)
            vc.refreshNotificationCount = { [weak self] count in
                guard let self = self else { return }
                if count != nil {
                    if kUserDefaults.isTradie() {
                        var oldCount = self.viewModel.recommendedModel?.result?.unreadCount ?? 0
                        oldCount -= 1
                        if oldCount < 0 {
                            oldCount = 0
                        }
                        self.viewModel.recommendedModel?.result?.unreadCount = oldCount
                        self.badgeCountLabel.text = "\(oldCount)"
                        if oldCount == 0 {
                            self.badgeView.isHidden = true
                        } else {
                            self.badgeView.isHidden = false
                        }
                    } else {
                        var oldCount = self.homeBuilderModel?.result.unreadCount ?? 0
                        oldCount -= 1
                        if oldCount < 0 {
                            oldCount = 0
                        }
                        self.homeBuilderModel?.result.unreadCount = oldCount
                        self.badgeCountLabel.text = "\(oldCount)"
                        if oldCount == 0 {
                            self.badgeView.isHidden = true
                        } else {
                            self.badgeView.isHidden = false
                        }
                    }
                } else {
                    self.viewModel.recommendedModel?.result?.unreadCount = 0
                    self.homeBuilderModel?.result.unreadCount = 0
                    self.badgeCountLabel.text = "0"
                    self.badgeView.isHidden = true
                }
            }
            push(vc: vc)
        default:
            break
        }
    }
    
    private func initialSetup() {
        
        cellArray = kUserDefaults.getUserType() == 1 ? [.topSection, .jobs, .recommentedJobs] : [.topSection, .categories, .savedTradies, .recommendedTradespeople]
        searchButton.addTarget(self, action: #selector(searchButtonAction(_:)), for: .touchUpInside)
        let placeholderText = kUserDefaults.getUserType() == 2 ? "What trade are you looking for?" : "What jobs are you after?"
        searchTextField.setAttributedPlaceholder(placeholderText: placeholderText, font: UIFont.systemFont(ofSize: 15), color: #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1))
        homeTableView.addSubview(refreshControl)
        homeTableView.register(UINib(nibName: SearchHeaderView.defaultReuseIdentifier, bundle: .main), forHeaderFooterViewReuseIdentifier: SearchHeaderView.defaultReuseIdentifier)
        homeTableView.register(UINib(nibName: ViewNearByCell.defaultReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ViewNearByCell.defaultReuseIdentifier)
        homeTableView.register(UINib(nibName: SearchListCell.defaultReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SearchListCell.defaultReuseIdentifier)
        homeTableView.register(UINib(nibName: JobTypeCell.defaultReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: JobTypeCell.defaultReuseIdentifier)
        homeTableView.registerCell(with: CommonCollectionViewWithTitleTableCell.self)
        homeTableView.registerCell(with: TradePeopleTableCell.self)
        viewModel.delegate = self
        if !kUserDefaults.isTradie() {
            viewModel.getTradeList()
            NotificationCenter.default.addObserver(self, selector: #selector(getSaveTradie), name: NotificationName.refreshHomeBuilder, object: nil)
        } else {
            viewModel.getJobTypes()
        }
        fetchCurrentLocation()
        hitPaginationClosure()
    }
    
    func goToViewAllSavedTradies() {
        let vc = SavedTradieBuilderVC.instantiate(fromAppStoryboard: .savedTradieBuilder)
        vc.showSaveUnsaveButton = true
        push(vc: vc)
    }
    
    func goToAppGuide() {
        let vc = AppGuideVC.instantiate(fromAppStoryboard: .appGuide)
        vc.homeVC = self
        vc.currentTabBar = .home
        tabBarController?.selectedIndex = TabBarIndex.home.tabValue
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func hitPaginationClosure() {
        viewModel.hitPaginationClosure = { [weak self] in
            guard let self = self else { return }
            if kUserDefaults.isTradie() {
                self.viewModel.getRecommendedJobs(location: self.currentLocation, showLoader: false, isPullToRefresh: false)
            } else {
                self.viewModel.getHomeData(location: self.currentLocation)
            }
        }
    }
    
    @objc func searchButtonAction(_ sender: UIButton) {
        switch kUserDefaults.getUserType() {
        case 1:
            let searchVC = RecentSearchVC.instantiate(fromAppStoryboard: .search)
            push(vc: searchVC)
        case 2:
            let vc = SearchingBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
            push(vc: vc)            
        default:
            break
        }
        disableButton(sender)
    }
    
    @objc func refreshData() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refreshControl.endRefreshing()
        })
        if kUserDefaults.isTradie() {
            hitAPI(location: currentLocation, isPullToRefresh: true)            
        } else {
            viewModel.getTradeList()
            hitAPI(location: currentLocation, isPullToRefresh: true)
        }
    }
    
    func fetchCurrentLocation(showAlert: Bool = true) {
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.requestLocatinPermission { [weak self] (status) in
            guard let self = self else { return }
            if !status, showAlert {
                AppRouter.openSettings(self)                
            }
        }
    }
    
    @objc func getSaveTradie(_ notification: Notification) {
        if let userInfo = notification.userInfo, let tradieModel = userInfo[ApiKeys.tradieModel] as? SavedTradies, let isSaved = userInfo[ApiKeys.isSaved] as? Bool {
            let index = homeBuilderModel?.result.savedTradespeople.firstIndex(where: { eachModel -> Bool in
                return eachModel.tradieId == tradieModel.tradieId
            })
            
            if let index = index {
                if isSaved {
                    homeBuilderModel?.result.savedTradespeople.append(tradieModel)
                }else {
                    homeBuilderModel?.result.savedTradespeople.remove(at: index)
                }
            }else {
                homeBuilderModel?.result.savedTradespeople.append(tradieModel)
            }
        }
    }
}
