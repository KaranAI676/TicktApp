//
//  SearchingTransactionHistoryVC.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import UIKit

class SearchingTransactionHistoryVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var searchField: CustomMediumField!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    //MARK:- Variables
    var viewModel = TransactionHistoryVM()
    var arrayOfModel = [(section: String, rows: [TransactionHistoryRevenueListModel])]()
    var model: TransactionHistoryResultModel? = nil {
        didSet {
            setupModel()
        }
    }
    var searchText: String = "" {
        didSet {
            viewModel.getSearchedData(searchText: searchText)
        }
    }
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
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
            disableButton(sender)
        case cancelSearchButton:
            cancelButtonAction()
        default:
            break
        }
    }
}

extension SearchingTransactionHistoryVC {
    
    private func initialSetup() {
        setupTableView()
        showActivityLoader(false)
        cancelSearchButton.isHidden = true
        searchField.delegate = self
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: NoDataFoundTableCell.self)
        tableViewOutlet.registerCell(with: TransactionTableCell.self)
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func cancelButtonAction() {
        searchField.resignFirstResponder()
        viewModel.searchTask?.cancel()
        setupUIChnages(width: 30)
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
        viewModel.getSearchedData(searchText: searchText)
    }
}
