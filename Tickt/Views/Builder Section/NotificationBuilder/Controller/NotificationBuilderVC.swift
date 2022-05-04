//
//  NotificationBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 18/07/21.
//

import UIKit

class NotificationBuilderVC: BaseVC {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var readAllButton: CustomBoldButton!
    
    //MARK:- Variables
    var refreshNotificationCount: ((_ count: Int?)->())?
    var viewModel = NotificationBuilderVM()
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
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        default:
            viewModel.pageNo = 1
            viewModel.readAllNotification(showLoader: false, pullToRefresh: false)
        }
    }
}

extension NotificationBuilderVC {
    
    private func initialSetup() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        viewModel.getNotifications()
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: NotificationTableCell.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getNotifications(showLoader: false, pullToRefresh: true)
    }
}
