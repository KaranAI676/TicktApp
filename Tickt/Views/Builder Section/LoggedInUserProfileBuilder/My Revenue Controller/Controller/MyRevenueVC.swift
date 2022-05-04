//
//  MyRevenueVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 13/07/21.
//

import UIKit

class MyRevenueVC: BaseVC {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var revenueTableView: UITableView!
    @IBOutlet weak var totalEarningLabel: CustomBoldLabel!
    @IBOutlet weak var totalCompletedJobs: CustomBoldLabel!
        
    var pageIndex = 1
    let viewModel = MyRevenueVM()
    var model: RevenueListResult? = nil {
        didSet {
            setupModel()
        }
    }
    
    var arrayOfModel = [(section: String, rows: [RevenueListData])]()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        revenueTableView.refreshControl = refresher
        revenueTableView.registerCell(with: PastRevenueJobCell.self)
        revenueTableView.registerCell(with: ActiveRevenueJobCell.self)
        revenueTableView.registerHeaderFooter(with: TitleHeaderTableView.self)        
        viewModel.delegate = self
        hitAPI()
    }
    
    func hitAPI() {
        viewModel.getRevenueService()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        default:
            let vc = SearchRevenueVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
            push(vc: vc)
        }        
    }        
    
    private func setupModel() {
        arrayOfModel = []
        let datesArray = self.model?.revenue?.revenueList.map({ eachModel -> (String) in
            return eachModel.fromDate ?? Date().convertToString()
        }).unique()
        
        let _ = datesArray?.forEach({ eachModel in
            if let revenueModel = self.model?.revenue?.revenueList.filter({ eachRevenue -> Bool in
                return eachRevenue.fromDate == eachModel
            }) {
                arrayOfModel.append((CommonFunctions.getFormattedDates(fromDate: eachModel.convertToDateAllowsNil()), revenueModel))
            }
        })
        revenueTableView.reloadData()
    }
    
    @objc func pullToRefresh() {
        pageIndex = 1
        delay(time: 2.0) { [weak self] in
            self?.refresher.endRefreshing()
        }
        viewModel.getRevenueService(page: 1, pullToRefresh: true)
    }    
}
