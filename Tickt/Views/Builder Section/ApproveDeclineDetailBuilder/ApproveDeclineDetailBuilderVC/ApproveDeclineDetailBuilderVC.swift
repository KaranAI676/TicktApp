//
//  ApproveDeclineDetailBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 19/05/21.
//

import UIKit

class ApproveDeclineDetailBuilderVC: BaseVC {

    enum SectionType {
        ///
        case description
        case photos
        case workedHours
        case bottomButtons
        ///
        var title: String {
            switch self {
            case .description:
                return "Description"
            case .photos, .bottomButtons:
                return ""
            case .workedHours:
                return "Hours worked in this milestone"
            }
        }
        var height: CGFloat {
            switch self {
            case .description, .workedHours:
                return 30
            case .photos, .bottomButtons:
                return CGFloat.leastNonzeroMagnitude
            }
        }
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    ///
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var subScreenLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var canDecline = false
    var paymentDetailModel = ApproveDeclineMilestoneModel()
    ///
    var model: ApproveDeclineDetailBuilderModel? = nil
    var sectionArray = [SectionType]()
    var viewModel = ApproveDeclineBuilderVM()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.pop()
        disableButton(sender)
    }
}

extension ApproveDeclineDetailBuilderVC {
    
    private func initialSetup() {
        navTitleLabel.text = paymentDetailModel.jobName
        subScreenLabel.text = paymentDetailModel.milestoneData.milestoneName
        setupTableView()
        viewModel.delegate = self
        viewModel.getJobDetails(jobId: paymentDetailModel.jobId, milestoneId: paymentDetailModel.milestoneData.milestoneId)
    }
    
    private func setupTableView() {
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        ///
        tableViewOutlet.registerCell(with: BottomButtonsTableCell.self)
        tableViewOutlet.registerCell(with: DescriptionTableCell.self)
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
    }
    
    private func goToConfirmPayPaymentVC() {
        if paymentDetailModel.milestoneData.milestoneStatus == .declined || paymentDetailModel.milestoneData.milestoneStatus == .approved {
            pop()
            return
        }
        let vc = ConfirmAndPayDetailsBuilderVC.instantiate(fromAppStoryboard: .approveMilestoneBuilder)
        vc.paymentDetailModel = paymentDetailModel
        push(vc: vc)
    }
    
    private func goToDeclineMilestone() {
        let vc = DeclineMilestoneBuilderVC.instantiate(fromAppStoryboard: .declineMilestoneBuilder)
        vc.jobName = paymentDetailModel.jobName
        vc.milestoneId = paymentDetailModel.milestoneData.milestoneId
        vc.jobId = paymentDetailModel.jobId
        push(vc: vc)
    }
}

extension ApproveDeclineDetailBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///
        switch  sectionArray[indexPath.section] {
        case .photos:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            let urlArray = self.model?.result.images?.map({$0.link})
            cell.photoUrlsModel = urlArray
            cell.imageTapped = { [weak self] _, index in
                guard let self = self else { return }
                let previewVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
                previewVC.urlString = self.model?.result.images?[index.row].link ?? ""
                self.push(vc: previewVC)
            }
            cell.layoutIfNeeded()
            return cell
        case .description:
            let cell = tableView.dequeueCell(with: DescriptionTableCell.self)
            cell.descriptionText = self.model?.result.description ?? ""
            return cell
        case .workedHours:
            let cell = tableView.dequeueCell(with: DescriptionTableCell.self)
            var suffix = "hours"
            if let timeComponentes = model?.result.hoursWorked?.split(separator: ":"), timeComponentes.count > 1, let hours = Int(timeComponentes.first ?? "") {
                suffix = hours > 1 ? "hours" : "hour"
            }
            cell.descriptionText = (self.model?.result.hoursWorked ?? "") + " \(suffix)"
            return cell
        case .bottomButtons:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            if paymentDetailModel.milestoneData.milestoneStatus == .declined || paymentDetailModel.milestoneData.milestoneStatus == .approved {
                cell.secondButton.isHidden = true
                cell.firstButton.setTitleForAllMode(title: "OK")
            } else if !canDecline {
                cell.secondButton.isHidden = true
            }
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                switch type {
                case .firstButton:
                    self.goToConfirmPayPaymentVC()
                case .secondButton:
                    self.goToDeclineMilestone()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = sectionArray[section].title
        if sectionArray[section] == .workedHours {
            header.headerLabel.font = UIFont.kAppDefaultFontBold(ofSize: 14)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}

extension ApproveDeclineDetailBuilderVC {
    
    private func getSectionArray() {
        
        var sectionArray: [SectionType] = []
        
        guard let model = self.model else { return }
        ///
        if (model.result.images?.count ?? 0) > 0 {
            sectionArray.append(.photos)
        }
        
        if !(model.result.description ?? "").isEmpty  {
            sectionArray.append(.description)
        }
        
        if !(model.result.hoursWorked ?? "").isEmpty {
            sectionArray.append(.workedHours)
        }
        sectionArray.append(.bottomButtons)
        self.sectionArray = sectionArray
    }
}

extension ApproveDeclineDetailBuilderVC: ApproveDeclineBuilderVMDelegate {
    
    func success(model: ApproveDeclineDetailBuilderModel) {
        self.model = model
        getSectionArray()
        self.tableViewOutlet.reloadData()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
