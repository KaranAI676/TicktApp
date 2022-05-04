//
//  RevenueMilestoneCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 13/07/21.
//

import UIKit

class RevenueMilestoneCell: UITableViewCell {

    @IBOutlet weak var dashView: DashView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var dateLabel: CustomRomanLabel!
    @IBOutlet weak var amountLabel: CustomMediumLabel!
    @IBOutlet weak var photoEvidenceLabel: CustomRomanLabel!
    @IBOutlet weak var milestoneNameLabel: CustomMediumLabel!
    
    var milestone: Milestone? {
        didSet {
            milestoneNameLabel.text = milestone?.milestoneName
            photoEvidenceLabel.isHidden = !(milestone?.isPhotoevidence ?? false)
            photoEvidenceLabel.text = (milestone?.isPhotoevidence ?? false) ?  "Photo evidence required" : ""
            dateLabel.text = CommonFunctions.getFormattedDates(fromDate: milestone?.fromDate.convertToDateAllowsNil(), toDate: milestone?.completedAt?.convertToDateAllowsNil())
            amountLabel.text = milestone?.milestoneEarning
            if let status = JobStatus(rawValue: milestone?.status ?? "") {
                if status == .paymentApproved {
                    statusButton.setImage(#imageLiteral(resourceName: "icCheck"), for: .normal)
                } else {
                    statusButton.setImage(#imageLiteral(resourceName: "checkBoxUnselected"), for: .normal)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDashView(color: UIColor, isShow: Bool) {
        dashView.isHidden = !isShow
        (dashView.layer.sublayers?.first as? CAShapeLayer)?.strokeColor = color.cgColor
    }
    
    func setFontColor(status: Bool) {
        if status { //Fade
            dateLabel.textColor = UIColor(hex: "#748092")
            milestoneNameLabel.textColor = UIColor(hex: "#748092")
            photoEvidenceLabel.textColor = UIColor(hex: "#748092")
        } else { //Original
            dateLabel.textColor = UIColor(hex: "#313D48")
            milestoneNameLabel.textColor = UIColor(hex: "#161D4A")
            photoEvidenceLabel.textColor = UIColor(hex: "#313D48")
        }
    }
}
