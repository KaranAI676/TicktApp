//
//  QuotesDetailsVC.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

class QuotesDetailsVC: BaseVC {
    
    
    var showBottomButton = true
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryType: UILabel!    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    var viewModel = QuoteDetailsVM()
    var catName = ""
    var cattype = ""
    var ctImage = ""
    var jobId = ""
    var tradieId = ""
    var model: QuotesModel? {
        didSet {
            self.tableViewOutlet.reloadData {
                self.tableViewOutlet.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetUp()
    }
    
    private func initailSetUp(){
        viewModel.delegate = self
        setupTableView()
        categoryName.text = catName
        categoryType.text = cattype
        profileImage.sd_setImage(with: URL(string: ctImage), placeholderImage: nil)
        viewModel.getQuoteDetails(jobId: jobId, tradieID: tradieId, sortBy: .highestRated)
    }
    
    
    func setupTableView() {
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        self.tableViewOutlet.registerCell(with: GridCell.self)
        self.tableViewOutlet.registerCell(with: TotalButtonCell.self)
        self.tableViewOutlet.registerCell(with: QuoteDescriptionCell.self)
        self.tableViewOutlet.registerCell(with: QuotesUserCell.self)
        self.tableViewOutlet.registerCell(with: AcceptDeclineButtonCell.self)
    }
    
    func goToNextVC(status: AcceptDecline) {
        func goToSourceVC() {
            if let vc = navigationController?.viewControllers.first(where: { $0 is NewApplicantsBuilderVC }) {
                NotificationCenter.default.post(name: NotificationName.refreshNewApplicant, object: nil, userInfo: nil)
                if status == .accept {
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                }
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                if status == .accept {
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                }
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                self.pop()
            }
        }
        if status == .accept {
            goToSourceVC()
        }
    }
    
}

extension QuotesDetailsVC {
    @IBAction func backBtuuonTap(_ sender: UIButton) {
        self.pop()
    }
    
    func gotoAccountCreatedSuccessVC(screenType:ScreenType){
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = screenType
        vc.jobId = jobId
        vc.tradieId = tradieId
        push(vc: vc)
    }
}

extension QuotesDetailsVC: TableDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return model?.result?.resultData.first?.quoteItem?.count ?? 0
        case 4:
            return showBottomButton ? 2 : 0
        case 5:
            return 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = .clear
            return footerView
        }

        // set height for footer
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 20
        }
        

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableViewOutlet.dequeueCell(with: GridCell.self)
            if let model = self.model?.result?.resultData[indexPath.row]  {
                cell.populateData(data: model)
            }
            return cell
        case 1:
            let cell = tableViewOutlet.dequeueCell(with: QuotesUserCell.self)
            cell.tableView = tableView
            if let model = self.model?.result?.resultData[indexPath.row]  {
                cell.applicationModel = model
            }
            cell.buttonClosure = { [weak self] index in 
                self?.openTradieProfile(indexPath: indexPath)
            }
            cell.quotesView.isHidden = true
            return cell
        case 2:
            let cell = tableViewOutlet.dequeueCell(with: QuoteDescriptionCell.self)
            if let data = model?.result?.resultData.first?.quoteItem?[indexPath.row] {
                cell.populateUI(quoteModel: data, srno: (indexPath.row+1))
            }
            return cell
        case 3:
            let cell = tableViewOutlet.dequeueCell(with: TotalButtonCell.self)
            if let model = self.model?.result?.resultData[indexPath.row]  {
                let amount = "\(model.totalQuoteAmount)".currencyFormatting()
                cell.totalButton.setTitle("Total: \(amount)", for: .normal)
            }
            return cell
        case 4:
            let cell = tableViewOutlet.dequeueCell(with: AcceptDeclineButtonCell.self)
            if indexPath.row == 0{
                cell.setButtonTitle(index:0)
                cell.buttonTap = { [weak self] in
                    guard let _self = self else { return }
                    _self.viewModel.acceptDecline(jobId: _self.jobId, tradieId: _self.tradieId, status: .accept)

                }
            } else {
                cell.setButtonTitle(index:1)
                cell.buttonTap = { [weak self] in
                    guard let _self = self else { return }
                   // CommonFunctions.showToastWithMessage("Under Developemnt")
                    _self.viewModel.acceptDecline(jobId: _self.jobId, tradieId: _self.tradieId, status: .decline)
                }
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func openTradieProfile(indexPath: IndexPath) {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.jobId = jobId
        vc.isOpenJob = true
        vc.tradieId = tradieId
        vc.jobName = model?.result?.resultData.first?.jobName ?? ""
        vc.noOfTraidesCount = model?.result?.resultData.count ?? 0
        let jobStatus = JobStatus(rawValue: model?.result?.resultData.first?.status ?? "") ?? .cancelledJob
        vc.showSaveUnsaveButton = jobStatus != .cancelledJob
        push(vc: vc)
    }
}

extension QuotesDetailsVC: QuoteDetailsVMDelegate {
    func successAccpetDecline(status: AcceptDecline) {
        if status == .accept {
            gotoAccountCreatedSuccessVC(screenType: .quoteAccepted)
        } else {
            gotoAccountCreatedSuccessVC(screenType: .quotedecline)
        }
    }
        
    func success(data: QuotesModel) {
        model = data
        self.jobId = model?.result?.resultData.first?.jobId ?? ""
        self.tradieId = model?.result?.resultData.first?.userId ?? ""
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
