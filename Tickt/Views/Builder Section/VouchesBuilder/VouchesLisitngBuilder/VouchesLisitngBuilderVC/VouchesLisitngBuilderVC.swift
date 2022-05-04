//
//  VouchesLisitngBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 19/06/21.
//

import UIKit

class VouchesLisitngBuilderVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var continueBackView: UIView!
    
    //MARK:- Variables
    var tradieId: String = ""
    ///
    var delegate: LeaveVouchBuilderVCDelegate? = nil
    var viewModel = VouchesLisitngBuilderVM()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
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
        case continueButton:
            goToLeaveVouch()
        default:
            break
        }
        disableButton(sender)
    }
}

extension VouchesLisitngBuilderVC {
    
    private func initialSetup() {
        setupTableView()
        setupBottomButtons()
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        hitPagination()
        viewModel.getVouchesList(tradieId: tradieId)
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: VoucherTableCell.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func goToLeaveVouch() {
        let vc = LeaveVouchBuilderVC.instantiate(fromAppStoryboard: .vouchesBuilder)
        vc.tradieId = tradieId
        vc.delegate = self
        push(vc: vc)
    }
    
    func previewDoc(_ url: String) {
        if url.isValidUrl(url) {
            let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
            vc.comingFromLocal = false
            vc.url = url
            push(vc: vc)
        }else {
            CommonFunctions.showToastWithMessage("Error while loading...")
        }
    }
    
    private func setupBottomButtons() {
        if !kUserDefaults.isTradie() {
            tableViewOutlet.contentInset.bottom = (35 + 58 + 20) /// Bottom + buttonHeight + top
        } else {
            continueBackView.isHidden = true
            tableViewOutlet.contentInset.bottom = 0
        }
    }
    
    private func setupCount(count: Int) {
        screenTitleLabel.isHidden = count == 0
        self.screenTitleLabel.text = "\(count) \(count > 1 ? "Vouches" : "Vouch")"
        count == 0 ? showWaterMarkLabel(message: "No vouch found") : hideWaterMarkLabel()
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getVouchesList(tradieId: tradieId, showLoader: false, pullToRefresh: true)
    }
    
    func hitPagination() {
        viewModel.hitPagination = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getVouchesList(tradieId: self.tradieId, showLoader: false)
        }
    }
}

extension VouchesLisitngBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model?.result.voucher.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: VoucherTableCell.self)
        cell.tableView = tableView
        cell.vouchesData = viewModel.model?.result.voucher[indexPath.row]
        viewModel.hitPagination(index: indexPath.row)
        ///
        cell.openRecommendedClosure = { [weak self] index in
            guard let self = self else { return }
            self.previewDoc(self.viewModel.model?.result.voucher[index.row].recommendation ?? "")
        }
        return cell
    }
}

extension VouchesLisitngBuilderVC: VouchesLisitngBuilderVMDelegate {
    
    func success() {
        setupCount(count: viewModel.model?.result.totolVouches ?? 0)
        tableViewOutlet.reloadData()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}

extension VouchesLisitngBuilderVC: LeaveVouchBuilderVCDelegate {
    
    func getNewlyAddedVouch(model: TradieProfileVouchesData) {
        delegate?.getNewlyAddedVouch(model: model)
        self.viewModel.model?.result.voucher.insert(model, at: 0)
        setupCount(count: self.viewModel.model?.result.voucher.count ?? 0)
        tableViewOutlet.reloadData()
    }
}
