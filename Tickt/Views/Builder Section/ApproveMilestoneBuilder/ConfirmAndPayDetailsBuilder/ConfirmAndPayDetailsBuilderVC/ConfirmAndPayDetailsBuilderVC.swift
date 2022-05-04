//
//  ConfirmAndPayBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 17/06/21.
//

import UIKit

class ConfirmAndPayDetailsBuilderVC: BaseVC {

    enum CellArray {
        case title
        case hoursWorked
        case hourlyRate
        case milestoneAmount
        case TaxGST
        case platformFees
        case total
        
        var title: String {
            switch self {
            case .title:
                return "Milestone payment details"
            case .hoursWorked:
                return "Hours worked"
            case .hourlyRate:
                return "Hourly rate"
            case .milestoneAmount:
                return "Milestone Amount"
            case .TaxGST:
                return "GST"
            case .platformFees:
                return "Platform fees"
            case .total:
                return "Total"
            }
        }
        
        var bgColor: UIColor {
            switch self {
            case .title, .hoursWorked, .hourlyRate, .milestoneAmount, .TaxGST, .platformFees, .total:
                return #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .title, .total:
                return #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
            default:
                return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            }
        }
        
        var font: UIFont {
            switch self {
            case .title, .total:
                return UIFont.kAppDefaultFontBold(ofSize: 16)
            default:
                return UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    enum SeactionArray {
        case paymentDetails
        case bankDetails
    }
    
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: CustomBoldLabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var payButton: CustomBoldButton!
    
    //MARK:- Variables
    var paymentDetailModel = ApproveDeclineMilestoneModel()
    ///
    var viewModel = ConfirmAndPayDetailsBuilderVM()
    var sectionArray: [SeactionArray] = [.paymentDetails]
    var cellArray = [CellArray]()
    var recentCard: CardListResultModel? = nil
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
            pop()
        case payButton:
            goToPayVC()
        default:
            break
        }
    }
}

extension ConfirmAndPayDetailsBuilderVC {
    
    private func initialSetup() {
        navTitleLabel.text = paymentDetailModel.jobName
        setupTableView()
        viewModel.delegate = self
        viewModel.getRecentCard()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: PaymentDetailTableCell.self)
        tableViewOutlet.registerCell(with: BankDetailTableCell.self)
        ///
        tableViewOutlet.refreshControl = refresher
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func goToPayVC(recentCard: String = "") {
        let vc = ConfirmAndPayPaymentBuilderVC.instantiate(fromAppStoryboard: .approveMilestoneBuilder)
        paymentDetailModel.paymentMethods = recentCard
        vc.paymentDetailModel = paymentDetailModel
        vc.delegate = self
        push(vc: vc)
    }
    
    @objc func pullToRefresh() {
        CommonFunctions.delay(delay: 2.0, closure: {
            self.refresher.endRefreshing()
        })
        viewModel.getRecentCard()
    }
}


extension ConfirmAndPayDetailsBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .paymentDetails:
            return getCellArray().count
        case .bankDetails:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .paymentDetails:
            let cell = tableView.dequeueCell(with: PaymentDetailTableCell.self)
            cell.populateUI(cellArray[indexPath.row])
            ///
            switch cellArray[indexPath.row] {
            case .title:
                cell.rightLabel.text = cellArray[indexPath.row].title
            case .hoursWorked:
                cell.rightLabel.text = paymentDetailModel.milestoneData.hoursWorked
            case .hourlyRate:
                let text = paymentDetailModel.milestoneData.hourlyRate.replace(string: "$", withString: "")
                cell.rightLabel.text = text.getFormattedPrice()
            case .milestoneAmount:
                let text = paymentDetailModel.milestoneData.milestoneAmount.replace(string: "$", withString: "")
                cell.rightLabel.text = text.getFormattedPrice()
            case .TaxGST:
                cell.rightLabel.text = paymentDetailModel.milestoneData.taxes
            case .platformFees:
                let text = paymentDetailModel.milestoneData.platformFees.replace(string: "$", withString: "")
                cell.rightLabel.text = text.getFormattedPrice()
            case .total:
                let text = paymentDetailModel.milestoneData.total.replace(string: "$", withString: "")
                cell.rightLabel.text = text.getFormattedPrice()
            }
            return cell
        case .bankDetails:
            let cell = tableView.dequeueCell(with: BankDetailTableCell.self)
            cell.tableView = tableView
            cell.model = recentCard
            cell.forwardButton.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section] {
        case .bankDetails:
            goToPayVC(recentCard: recentCard?.cardId ?? "")
        default:
            break
        }
    }
}

extension ConfirmAndPayDetailsBuilderVC {
    
    private func getCellArray() -> [CellArray] {
        
        cellArray = [.title]
        
        if !paymentDetailModel.milestoneData.hoursWorked.isEmpty {
            cellArray.append(.hoursWorked)
        }
        
        if !paymentDetailModel.milestoneData.hourlyRate.isEmpty {
            cellArray.append(.hourlyRate)
        }
        
        if !paymentDetailModel.milestoneData.milestoneAmount.isEmpty {
            cellArray.append(.milestoneAmount)
        }
        
        if !paymentDetailModel.milestoneData.taxes.isEmpty {
            cellArray.append(.TaxGST)
        }
        
        if !paymentDetailModel.milestoneData.platformFees.isEmpty {
            cellArray.append(.platformFees)
        }
        
        if !paymentDetailModel.milestoneData.total.isEmpty {
            cellArray.append(.total)
        }
        
        return cellArray
    }
}

extension ConfirmAndPayDetailsBuilderVC: ConfirmAndPayDetailsBuilderVMDelegate {
    
    func didSuccessRecentCard(model: CardListResultModel) {
        recentCard = model
        sectionArray = [.paymentDetails, .bankDetails]
        tableViewOutlet.reloadData()
        refresher.endRefreshing()
    }
    
    func failure(message: String) {
        refresher.endRefreshing()
    }
}

extension ConfirmAndPayDetailsBuilderVC: ConfirmAndPayPaymentBuilderVCDelegate {
    
    func getDeletedCard(cardId: String) {
        if cardId == recentCard?.cardId {
            recentCard = nil
            sectionArray = [.paymentDetails]
            tableViewOutlet.reloadData()
        }
    }
}
