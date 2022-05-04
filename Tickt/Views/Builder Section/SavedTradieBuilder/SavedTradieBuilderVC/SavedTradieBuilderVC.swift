//
//  SavedTradieBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 21/06/21.
//

import UIKit

protocol SavedTradieBuilderVCDelagate: AnyObject {
    
}

class SavedTradieBuilderVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    let viewModel = SavedTradieBuilderVM()
    var delegate: SavedTradieBuilderVCDelagate? = nil
    var showSaveUnsaveButton = false
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        pop()
        disableButton(sender)
    }
}

extension SavedTradieBuilderVC {
    
    private func initialSetup() {
        setupTableView()
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        viewModel.getSavedTradies()
        NotificationCenter.default.addObserver(self, selector: #selector(getSaveTradie), name: NotificationName.refreshHomeBuilder, object: nil)

    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: TradePeopleTableCell.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.contentInset.bottom = 10
    }
    
    private func goToTradieVC(tradieId: String) {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.tradieId = tradieId
        vc.showSaveUnsaveButton = showSaveUnsaveButton
        self.push(vc: vc)
    }
    
    private func setupCount(count: Int) {
        screenTitleLabel.isHidden = count == 0
        self.screenTitleLabel.text = "Saved tradespeople(s)"
        count == 0 ? showWaterMarkLabel(message: "No saved tradespeople") : hideWaterMarkLabel()
    }
    
    @objc func getSaveTradie(_ notification: Notification) {
        if let userInfo = notification.userInfo, let tradieModel = userInfo[ApiKeys.tradieModel] as? SavedTradies, let isSaved = userInfo[ApiKeys.isSaved] as? Bool {
            let index = viewModel.model?.result.firstIndex(where: { eachModel -> Bool in
                return eachModel.tradieId == tradieModel.tradieId
            })
            
            if let index = index {
                if isSaved {
                    viewModel.model?.result.append(tradieModel)
                }else {
                    viewModel.model?.result.remove(at: index)
                }
            }else {
                viewModel.model?.result.append(tradieModel)
            }
            setupCount(count: viewModel.model?.result.count ?? 0)
            tableViewOutlet.reloadData()
        }
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getSavedTradies(showLoader: false, pullToRefresh: true)
    }
}

extension SavedTradieBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: TradePeopleTableCell.self)
        cell.tableView = tableView
        cell.titleLabel.isHidden = true
        cell.titleLabel.isHidden = !(indexPath.row == 0)
        cell.extraTradeCellSize = CGSize(width: (71), height: 32)
        cell.extraSpecCellSize = CGSize(width: (16), height: 32)
        ///
        guard let model = self.viewModel.model else { return UITableViewCell() }
        viewModel.hitPagination(index: indexPath.row)
        
        if let specialisationArray: [BuilderHomeSpecialisation] = CommonFunctions.getCountedSpecialisations(dataArray: model.result[indexPath.row].specializationData) as? [BuilderHomeSpecialisation] {
            cell.populateUI(title: "", dataArrayTrade: model.result[indexPath.row].tradeData, dataArraySpecialisation: specialisationArray)
        }
        cell.userNameLabel.text = model.result[indexPath.row].tradieName
        cell.ratingLabel.text = "\(model.result[indexPath.row].ratings), \(model.result[indexPath.row].reviews) reviews"
        
        cell.profileImageVIew.sd_setImage(with: URL(string:(model.result[indexPath.row].tradieImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        ///
        cell.buttonClosure = { [weak self] (index) in
            guard let self  = self else { return }
            if let tradieId = self.viewModel.model?.result[index.row].tradieId {
                self.goToTradieVC(tradieId: tradieId)
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
}

extension SavedTradieBuilderVC: SavedTradieBuilderVMDelegate {
    
    func success(pulToRefresh: Bool) {
        setupCount(count: self.viewModel.model?.result.count ?? 0)
        refresher.endRefreshing()
        tableViewOutlet.reloadData { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        refresher.endRefreshing()
    }
}
