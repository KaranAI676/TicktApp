//
//  MilestoneListingTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 31/03/21.
//

import UIKit

class TitleLabelTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var editBackView: UIView!
    @IBOutlet weak var editButton: UIButton!
//    @IBOutlet weak var approvalView: UIView!
    
    @IBOutlet weak var statusBackView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: CustomBoldLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBarView: HorizontalProgressBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var isJobDetail: Bool? {
        didSet {
            editButton.isHidden = isJobDetail ?? false
        }
    }
    
    var model: (data: JobDetailsData?, screenType: ScreenType)? = nil {
        didSet {
            if let screenType = model?.screenType {
                self.populateUI(screenType)
            }
        }
    }
    
    var republishModel: CreateJobModel? {
        didSet {
            self.populateUI(.pastJobsExpired)
        }
    }
    
    var editButtonClosure: (()->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.editButtonClosure?()        
    }
}

extension TitleLabelTableCell {
    
    private func populateUI(_ screenType: ScreenType) {
        self.updateUI(screenType)
        guard let model = self.model?.data else { return }
        ///
        switch screenType {
        case .openJobs:
            self.titleLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: model.milestoneNumber ?? 0, totalMilestones: model.totalMilestones ?? 0, forDetail: true)
            CommonFunctions.setProgressBar(milestoneDone: model.milestoneNumber ?? 0, totalMilestone: model.totalMilestones ?? 0, progressBarView)
        case .activeJob:
            self.titleLabel.attributedText = CommonFunctions.getAttributedText(milestonesDone: model.milestoneNumber ?? 0, totalMilestones: model.totalMilestones ?? 0, forDetail: true)
            statusLabel.text = model.status?.uppercased()
            statusBackView.isHidden = model.status?.uppercased() == "REQUEST ACCEPTED"
            CommonFunctions.setProgressBar(milestoneDone: model.milestoneNumber ?? 0, totalMilestone: model.totalMilestones ?? 0, progressBarView)
        case .pastJobsCompleted:
            self.titleLabel.text = "Job milestones"
            self.statusLabel.text = model.status?.uppercased()
            CommonFunctions.setProgressBar(milestoneDone: model.milestoneNumber ?? 0, totalMilestone: model.totalMilestones ?? 0, progressBarView)
        case .pastJobsExpired:
            self.titleLabel.text = "Job milestones"
        default:
            break
        }
    }
    
    private func updateUI(_ screenType: ScreenType) {
        switch screenType {
        case .openJobs:
            self.editBackView?.isHidden = true
            self.progressBarView.isHidden = false
        case .pastJobsCompleted:
            self.editBackView?.isHidden = true
            self.progressBarView.isHidden = false
            self.statusBackView.isHidden = true
            self.titleLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        case .activeJob:
            self.editBackView?.isHidden = true
            self.progressBarView.isHidden = false
            self.statusBackView.isHidden = false
        case .pastJobsExpired:
            self.editBackView?.isHidden = true
            self.progressBarView.isHidden = true
            self.statusBackView.isHidden = true
        default:
            break
        }
    }
}
