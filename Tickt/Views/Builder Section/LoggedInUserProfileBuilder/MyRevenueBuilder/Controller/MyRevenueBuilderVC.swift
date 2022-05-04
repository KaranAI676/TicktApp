//
//  MyRevenueBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import UIKit

class MyRevenueBuilderVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav View
    @IBOutlet weak var navBackView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backButton: UIButton!
    /// topDetail View
    @IBOutlet weak var topDetailView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activeLabelBackView: UIView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: CustomBoldLabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    let viewModel = MyRevenueBuilderVM()
    var model: MyRevenueBuilderResultModel? = nil
    var transactionModel = TransactionHistoryRevenueListModel()
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
        pop()
    }
}

extension MyRevenueBuilderVC {
    
    private func initialSetup() {
        setupJobDetailView()
        setupTableView()
        viewModel.delegate = self
        viewModel.getRevenueDetail(jobId: transactionModel.jobId)
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: RevenueDetailTableCell.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func setupJobDetailView() {
        profileImageView.sd_setImage(with: URL(string: transactionModel.tradieImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        jobNameLabel.text = transactionModel.jobName
        dateLabel.text = CommonFunctions.getFormattedDates(fromDate: transactionModel.fromDate.convertToDateAllowsNil(), toDate: transactionModel.toDate?.convertToDateAllowsNil())
        priceLabel.text = transactionModel.earning
        if let jobStatus = JobStatus.init(rawValue: transactionModel.status.uppercased()), jobStatus == .active {
            activeLabel.text = jobStatus.rawValue.capitalized
            activeLabelBackView.isHidden = false
            dateLabel.isHidden = true
        } else {
            activeLabelBackView.isHidden = true
            dateLabel.isHidden = false
        }
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getRevenueDetail(jobId: transactionModel.jobId, pullToRefresh: true)
    }
}
