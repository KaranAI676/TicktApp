//
//  SearchRevenueVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import UIKit

class SearchRevenueVC: BaseVC {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var searchField: CustomMediumField!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    var page = 1
    let viewModel = MyRevenueVM()
    var model: RevenueListResult? = nil {
        didSet {
            setupModel()
        }
    }
    var arrayOfModel = [(section: String, rows: [RevenueListData])]()
    var searchText: String = "" {
        didSet {
            viewModel.getSearchedData(searchText: searchText)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
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

    private func initialSetup() {
        setupTableView()
        showActivityLoader(false)
        cancelSearchButton.isHidden = true
        searchField.delegate = self
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: NoDataFoundTableCell.self)
        tableViewOutlet.registerCell(with: PastRevenueJobCell.self)
        tableViewOutlet.registerCell(with: ActiveRevenueJobCell.self)
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
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
            return eachModel.fromDate ?? Date().convertToString()
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
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getSearchedData(searchText: searchText)
    }
    
    func setupUIChnages(width: CGFloat) {
        setConstraints(width: width)
        if width > 0 { makeModelEmpty() }
        updateLayout()
        if width > 0 { refreshTableView() }
        showActivityLoader(width == 0)
    }
    
    func setConstraints(width: CGFloat) {
        widthConstraint.constant = width
        if width > 0 {
            searchImage.isHidden = false
            cancelSearchButton.isHidden = true
            
        } else {
            searchImage.isHidden = true
            cancelSearchButton.isHidden = false
        }
    }
    
    func makeModelEmpty() {
        searchText = ""
        searchField.text = ""
        model = nil
        arrayOfModel = []
    }
    
    func updateLayout() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }
    }
    
    func refreshTableView() {
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func showActivityLoader(_ showLoader: Bool) {
        activityIndicatorOutlet.isHidden = !showLoader
        showLoader ? activityIndicatorOutlet.startAnimating() : activityIndicatorOutlet.stopAnimating()
    }
}
