//
//  TransactionHistoryBuilder.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import UIKit

class TransactionHistoryBuilder: BaseVC {

    //MARK:- IB Outlets
    /// Nav View
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navBackView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var totalEarningLabel: UILabel!
    @IBOutlet weak var totalCompletedJobs: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    let viewModel = TransactionHistoryVM()
    var model: TransactionHistoryResultModel? = nil {
        didSet {
            setupModel()
        }
    }
    ///
    var arrayOfModel = [(section: String, rows: [TransactionHistoryRevenueListModel])]()
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            if (kAppDelegate.totalMilestonesNonApproved ?? 0) > 1 {
                if let checkVC = navigationController?.viewControllers.first(where: { $0 is CheckApproveBuilderVC }) {
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])
                    mainQueue { [weak self] in
                        self?.navigationController?.popToViewController(checkVC, animated: true)
                    }
                } else {
                    pop()
                }
            } else {
                if let checkVC = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                    mainQueue { [weak self] in
                        self?.navigationController?.popToViewController(checkVC, animated: true)
                    }
                } else {
                    pop()
                }
            }
        case searchButton:
            goToSearchVC()
        default:
            break
        }
    }
}

extension TransactionHistoryBuilder {
    
    private func initialSetup() {
        setupTableView()
        viewModel.delegate = self
        viewModel.getTransactionHistory()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: TransactionTableCell.self)
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func goToSearchVC() {
        let vc = SearchingTransactionHistoryVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        push(vc: vc)
    }
    
    private func setupModel() {
        arrayOfModel = []
        let datesArray = self.model?.revenue?.revenueList.map({ eachModel -> (String) in
            return eachModel.fromDate
        }).unique()
        
        let _ = datesArray?.forEach({ eachModel in
            if let revenueModel = self.model?.revenue?.revenueList.filter({ eachRevenue -> Bool in
                return eachRevenue.fromDate == eachModel
            }) {
                arrayOfModel.append((CommonFunctions.getFormattedDates(fromDate: eachModel.convertToDateAllowsNil()), revenueModel))
            }
        })
        tableViewOutlet.reloadData()
    }
    
    func goToMyRevenueVC(model: TransactionHistoryRevenueListModel) {
        let vc = MyRevenueBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        vc.transactionModel = model
        push(vc: vc)
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getTransactionHistory(pullToRefresh: true)
    }
}
