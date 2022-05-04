//
//  JobStatusTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 06/05/21.
//

import UIKit

class JobStatusTableCell: UITableViewCell {

    enum ButtonTypes {
        case forward
        case application
        case quotes
    }
    
    enum CellType {
        case openJob
        case pastJob
        case activeJob
        case newApplicants
        case needApproval
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    ///
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameSubTitleLabel: UILabel!
    @IBOutlet weak var forwardButtonView: UIView!
    @IBOutlet weak var forwardButton: UIButton!
    ///
    @IBOutlet weak var gridView: UIView!
    /// First
    @IBOutlet weak var firstGridView: UIView!
    @IBOutlet weak var firstGridImageView: UIImageView!
    @IBOutlet weak var firstGridLabel: UILabel!
    /// Second
    @IBOutlet weak var secondGridView: UIView!
    @IBOutlet weak var secondGridImageView: UIImageView!
    @IBOutlet weak var secondGridLabel: UILabel!
    /// Third
    @IBOutlet weak var thirdGridView: UIView!
    @IBOutlet weak var thirdGridImageView: UIImageView!
    @IBOutlet weak var thirdGridLabel: UILabel!
    /// Forth
    @IBOutlet weak var forthGridView: UIView!
    @IBOutlet weak var forthGridLabel: UILabel!
    ///
    @IBOutlet weak var upperProgressBarView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var progressView: HorizontalProgressBar!
    @IBOutlet weak var negationImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var milestoneCountLabel: UILabel!
    @IBOutlet weak var applicationButton: UIButton!
    
    //MARK:- Variables
    var buttonClosure: ((ButtonTypes, IndexPath)->())? = nil
    var isQuoteJob:Bool=false
    var tableView: UITableView? = nil
    ///
    var openJobsModel: OpenJobs? = nil {
        didSet {
            self.populateUI(.openJob)
        }
    }
    var pastJobsModel: PastJobs? = nil {
        didSet {
            self.populateUI(.pastJob)
        }
    }
    var activeJobModel: ActiveJobs? = nil {
        didSet {
            self.populateUI(.activeJob)
        }
    }
    var newApplicantsModel: NewApplicantResult? = nil {
        didSet {
            self.populateUI(.newApplicants)
        }
    }
    var needApprovalModel: NeedApprovalModeResult? = nil {
        didSet {
            self.populateUI(.needApproval)
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = self.tableView else { return }
        switch sender {
        case forwardButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.forward, index)
            }
        case applicationButton:
            if isQuoteJob{
                if let index = tableViewIndexPath(tableView) {
                    self.buttonClosure?(.quotes, index)
                }
            }else{
                if let index = tableViewIndexPath(tableView) {
                    self.buttonClosure?(.application, index)
                }
            }
        default:
            break
        }
    }
}

extension JobStatusTableCell {
    
    func populateUI(_ cellType: CellType) {
        self.configGridView(cellType)
        switch cellType {
        case .openJob:
            guard let model = self.openJobsModel else { return }
            self.firstGridLabel.text = model.amount
            self.secondGridLabel.text = model.total
            self.thirdGridLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
            self.forthGridLabel.text = model.timeLeft
            self.userNameLabel.text = model.tradeName
            self.userNameSubTitleLabel.text = model.jobName
            self.profileImageView.sd_setImage(with: URL(string:(model.tradeSelectedUrl)), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            self.statusLabel.attributedText = model.status.uppercased().setLineSpacing(2.5)
            self.milestoneCountLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: model.milestoneNumber, totalMilestones: model.totalMilestones)
            self.setProgressBar(milestoneDone: model.milestoneNumber, totalMilestone: model.totalMilestones)
            if model.quoteJob {
                isQuoteJob = true
                var title = ""
                if model.quoteCount == 0 {
                    title = " 0 Quotes"
                } else if model.quoteCount > 1 {
                    title = "\(model.quoteCount) Quotes"
                } else{
                    title = "\(model.quoteCount) Quote"
                }
                self.applicationButton.setTitle(title, for: .normal)
                self.applicationButton.isHidden = false
            } else {
                isQuoteJob = false
                self.applicationButton.setTitle("Application", for: .normal)
                self.applicationButton.isHidden = !model.isApplied
            }
        case .pastJob:
            ///
            guard let model = self.pastJobsModel  else { return }
            self.firstGridLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
            self.secondGridLabel.text = model.amount
            self.thirdGridLabel.text = model.locationName
            self.forthGridLabel.text = model.status.uppercased()
            self.userNameLabel.text = model.tradeName
            self.userNameSubTitleLabel.text = model.jobName
            self.profileImageView.sd_setImage(with: URL(string:(model.jobData?.tradeSelectedUrl ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            self.milestoneCountLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: model.milestoneNumber, totalMilestones: model.totalMilestones)
            self.setProgressBar(milestoneDone: model.milestoneNumber, totalMilestone: model.totalMilestones)
            ///
            self.applicationButton.isHidden = (JobStatus.cancelled.rawValue == model.status.uppercased()) || model.isRated
            let buttontitle: String = (JobStatus.expired.rawValue == model.status.uppercased()) ? "Publish again" : "Rate tradesperson"
            let buttonImage: UIImage? = (JobStatus.expired.rawValue == model.status.uppercased()) ? nil : #imageLiteral(resourceName: "darkStart")
            self.applicationButton.setTitle(buttontitle, for: .normal)
            self.applicationButton.setTitle(buttontitle, for: .selected)
            self.applicationButton.setImage(buttonImage, for: .normal)
            self.applicationButton.setImage(buttonImage, for: .selected)
        case .activeJob:
            guard let model = self.activeJobModel  else { return }
            self.firstGridLabel.text = model.amount
            self.secondGridLabel.text = model.total
            self.thirdGridLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
            self.forthGridLabel.text = model.timeLeft
            self.userNameLabel.text = model.tradeName
            self.userNameSubTitleLabel.text = model.jobName
            ///
            self.profileImageView.sd_setImage(with: URL(string:(model.tradeSelectedUrl)), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            ///
            self.statusLabel.attributedText = model.status.uppercased().setLineSpacing(2.5)
            self.milestoneCountLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: model.milestoneNumber, totalMilestones: model.totalMilestones)
            self.setProgressBar(milestoneDone: model.milestoneNumber, totalMilestone: model.totalMilestones)
            ///
            self.applicationButton.setTitle("Approve", for: .normal)
            if model.milestoneNumber == 0 {
                self.applicationButton.isHidden = true
            } else if let approvalCount = model.approvalCount, approvalCount > 5 {
                self.applicationButton.isHidden = true
            } else {
                self.applicationButton.isHidden = false
            }
            self.applicationButton.isHidden = !(model.needApproval ?? false)
            
        case .newApplicants:
            guard let model = self.newApplicantsModel else { return }
            self.firstGridLabel.text = model.amount
            self.secondGridLabel.text = model.total
            self.thirdGridLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
            self.forthGridLabel.text = model.timeLeft
            ///
            self.userNameLabel.text = model.tradeName
            self.userNameSubTitleLabel.text = model.jobName
            self.profileImageView.sd_setImage(with: URL(string:(model.tradeSelectedUrl)), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            
            if model.quoteJob {
                isQuoteJob = true
//                var title = ""
//                if model.quoteCount == 0{
//                    title = " 0 Quotes"
//                }else if model.quoteCount > 1{
//                    title = "\(model.quoteCount) Quotes"
//                }else{
//                    title = "\(model.quoteCount) Quote"
//                }
                self.applicationButton.setTitle("Applications", for: .normal)
            } else {
                isQuoteJob = false            
                self.applicationButton.setTitle("Application", for: .normal)
            }
            
        case .needApproval:
            guard let model = self.needApprovalModel else { return }
            self.firstGridLabel.text = model.amount
            self.secondGridLabel.text = model.total
            self.thirdGridLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
            self.forthGridLabel.text = model.timeLeft
            ///
            self.userNameLabel.text = model.tradeName
            self.userNameSubTitleLabel.text = model.jobName
            self.statusLabel.attributedText = model.status.uppercased().setLineSpacing(2.5)
            self.milestoneCountLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: model.milestoneNumber, totalMilestones: model.totalMilestones)
            self.profileImageView.sd_setImage(with: URL(string:(model.tradeSelectedUrl)), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            self.setProgressBar(milestoneDone: model.milestoneNumber, totalMilestone: model.totalMilestones)
            self.applicationButton.setTitle("Approve", for: .normal)
            self.applicationButton.isHidden = !(model.needApproval ?? false)
        }
    }
    
    private func configGridView(_ cellType: CellType) {
        switch cellType {
        case .openJob:
            break
        case .newApplicants:
            self.upperProgressBarView.isHidden = true
            self.progressView.isHidden = true
        case .activeJob, .needApproval:
            if let statusString = self.activeJobModel?.status.uppercased(),
               let status = JobStatus(rawValue: statusString) {
                setStatusImage(status: status, imageView: negationImageView)
            } else if let statusString = self.needApprovalModel?.status.uppercased(),
               let status = JobStatus(rawValue: statusString) {
                setStatusImage(status: status, imageView: negationImageView)
            } else {
                negationImageView.isHidden = true
            }
        case .pastJob:
            self.firstGridImageView.image = #imageLiteral(resourceName: "calendar")
            self.secondGridImageView.image = #imageLiteral(resourceName: "dollar")
            self.thirdGridImageView.image = #imageLiteral(resourceName: "place")
            self.thirdGridLabel.numberOfLines = 1
            self.secondGridImageView.isHidden = false
            self.secondGridLabel.textAlignment = .left
            self.secondGridLabel.font = UIFont.systemFont(ofSize: 14)
            self.forthGridLabel.textAlignment = .left
            self.forthGridLabel.font = UIFont.kAppDefaultFontBold(ofSize: 10)
            self.forthGridLabel.textColor = #colorLiteral(red: 0.0431372549, green: 0.2549019608, blue: 0.6588235294, alpha: 1)
            ///
            self.applicationButton.setFont(UIFont.kAppDefaultFontBold(ofSize: 14))
            self.applicationButton.setImage(#imageLiteral(resourceName: "darkStart"), for: .normal)
            self.applicationButton.setImage(#imageLiteral(resourceName: "darkStart"), for: .selected)
            self.applicationButton.imageEdgeInsets.left = -20
            ///
            self.statusLabel.isHidden = true
        }
    }
    
    private func setProgressBar(milestoneDone: Int, totalMilestone: Int) {
        let progress = totalMilestone <= 0 ? 0 : Double.getDouble(milestoneDone) / Double.getDouble(totalMilestone)
        if progress.isNaN {
            progressView.progress = 0
        } else {
            progressView.progress = CGFloat(progress)
        }
    }
    
    private func setStatusImage(status: JobStatus, imageView: UIImageView) {
        imageView.isHidden = false
        switch status {
        case .approved:
            imageView.image = #imageLiteral(resourceName: "tick-Approved")
        case .needApproval:
            imageView.image = #imageLiteral(resourceName: "exclamation")
        default:
            imageView.isHidden = true
        }
    }
}
