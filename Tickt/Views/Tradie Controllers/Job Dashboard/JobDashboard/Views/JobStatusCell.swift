//
//  JobStatusCell.swift
//  Tickt
//
//  Created by Admin on 12/05/21.
//

class JobStatusCell: UITableViewCell {
        
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var quoteContainerView: UIView!
    @IBOutlet weak var timeLabel: CustomRomanLabel!
    @IBOutlet weak var daysLabel: CustomRomanLabel!
    @IBOutlet weak var statusLabel: CustomBoldLabel!
    @IBOutlet weak var priceLabel: CustomRomanLabel!
    @IBOutlet weak var rateButton: CustomBoldButton!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var addressLabel: CustomRomanLabel!
    @IBOutlet weak var jobNameLabel: CustomRomanLabel!
    @IBOutlet weak var viewQuoteButton: CustomBoldButton!
    @IBOutlet weak var milestoneLabel: CustomMediumLabel!
    @IBOutlet weak var categoryNameLabel: CustomBoldLabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customProgressView: HorizontalProgressBar!
    @IBOutlet weak var viewQuoteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewTrailingConstraint: NSLayoutConstraint!
    
    var detailAction: (() -> ())?
    var viewQuoteAction: (() -> ())?
    var rateBuilderAction: (() -> ())?
    
    var activeJobs: RecommmendedJob? {
        didSet {
            timeLabel.text = CommonFunctions.getFormattedDates(fromDate: activeJobs?.fromDate?.convertToDateAllowsNil(), toDate: activeJobs?.toDate?.convertToDateAllowsNil())
            daysLabel.text = activeJobs?.timeLeft
            priceLabel.text = activeJobs?.amount
            jobNameLabel.text = activeJobs?.builderName
            addressLabel.text = activeJobs?.locationName
            categoryNameLabel.text = activeJobs?.jobName
            milestoneLabel.attributedText = getAttributedString(milestonesDone: activeJobs?.milestoneNumber ?? 0, totalMilestones: activeJobs?.totalMilestones ?? 0)
            jobImageView.sd_setImage(with: URL(string: activeJobs?.builderImage ?? ""), placeholderImage: nil)
            statusLabel.text = activeJobs?.status?.uppercased()
            let progress = Double.getDouble(activeJobs?.milestoneNumber) / Double.getDouble(activeJobs?.totalMilestones)
            if progress.isNaN {
                customProgressView.progress = CGFloat(0)
            } else {
                customProgressView.progress = CGFloat(progress)
            }
            if activeJobs?.quoteJob ?? false {
                viewQuoteHeightConstraint.constant = 35
            } else {
                viewQuoteHeightConstraint.constant = 0
            }
        }
    }
    
    
    var approvedMilestone: RecommmendedJob? {
        didSet {
            timeLabel.text = CommonFunctions.getFormattedDates(fromDate: approvedMilestone?.fromDate?.convertToDateAllowsNil(), toDate: approvedMilestone?.toDate?.convertToDateAllowsNil())
            daysLabel.text = approvedMilestone?.timeLeft
            priceLabel.text = approvedMilestone?.amount
            jobNameLabel.text = approvedMilestone?.jobName
            addressLabel.text = approvedMilestone?.locationName
            categoryNameLabel.text = approvedMilestone?.tradeName
            milestoneLabel.attributedText = getAttributedString(milestonesDone: approvedMilestone?.milestoneNumber ?? 0, totalMilestones: approvedMilestone?.totalMilestones ?? 0)
            jobImageView.sd_setImage(with: URL(string: approvedMilestone?.tradeSelectedUrl ?? ""), placeholderImage: nil)
            statusLabel.text = approvedMilestone?.status?.uppercased()
            let progress = Double.getDouble(approvedMilestone?.milestoneNumber) / Double.getDouble(approvedMilestone?.totalMilestones)
            if progress.isNaN {
                customProgressView.progress = CGFloat(0)
            } else {
                customProgressView.progress = CGFloat(progress)
            }
            if approvedMilestone?.quoteJob ?? false {
                viewQuoteHeightConstraint.constant = 35
            } else {
                viewQuoteHeightConstraint.constant = 0
            }
        }
    }

    var appliedJob: RecommmendedJob? {
        didSet {
            timeLabel.text = appliedJob?.time
            daysLabel.text = appliedJob?.durations
            priceLabel.text = appliedJob?.amount
            addressLabel.text = appliedJob?.locationName
            jobNameLabel.text = appliedJob?.builderName
            categoryNameLabel.text = appliedJob?.jobName
            milestoneLabel.attributedText = getAttributedString(milestonesDone: appliedJob?.milestoneNumber ?? 0, totalMilestones: appliedJob?.totalMilestones ?? 0)
            jobImageView.sd_setImage(with: URL(string: appliedJob?.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            statusLabel.text = appliedJob?.status
            let progress = Double.getDouble(appliedJob?.milestoneNumber) / Double.getDouble(appliedJob?.totalMilestones)
            if progress.isNaN {
                customProgressView.progress = CGFloat(0)
            } else {
                customProgressView.progress = CGFloat(progress)
            }
            viewQuoteButton.setTitle("Quote Sent", for: .normal)
            quoteContainerView.backgroundColor = .clear
            if appliedJob?.quoteJob ?? false {
                viewQuoteHeightConstraint.constant = 35
            } else {
                viewQuoteHeightConstraint.constant = 0
            }
        }
    }

    var completedJob: RecommmendedJob? {
        didSet {
            let isRated = completedJob?.isRated ?? false
            let status = completedJob?.status ?? ""
            if !isRated {
                if status != "CANCELLED" && status != "EXPIRED" {
                    heightConstraint.constant = 50
                } else {
                    heightConstraint.constant = 0
                }
            } else {
                heightConstraint.constant = 0
            }
            
            calendarImageView.isHidden = true
            calendarViewWidthConstraint.constant = 0
            calendarViewTrailingConstraint.constant = 0
            timeLabel.text = CommonFunctions.getFormattedDates(fromDate: completedJob?.fromDate?.convertToDateAllowsNil(), toDate: completedJob?.toDate?.convertToDateAllowsNil())
            daysLabel.text = completedJob?.status?.uppercased()
            daysLabel.font = UIFont.kAppDefaultFontBold(ofSize: 10)
            daysLabel.textColor = UIColor(hex: "#0B41A8")
            priceLabel.text = completedJob?.amount
            addressLabel.text = completedJob?.locationName
            jobNameLabel.text = completedJob?.builderName
            categoryNameLabel.text = completedJob?.jobName
            milestoneLabel.attributedText = getAttributedString(milestonesDone: completedJob?.milestoneNumber ?? 0, totalMilestones: completedJob?.totalMilestones ?? 0)
            jobImageView.sd_setImage(with: URL(string: completedJob?.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            statusLabel.isHidden = true
            let progress = Double.getDouble(completedJob?.milestoneNumber) / Double.getDouble(completedJob?.totalMilestones)
            if progress.isNaN {
                customProgressView.progress = CGFloat(0)
            } else {
                customProgressView.progress = CGFloat(progress)
            }
        }
    }
        
    func getAttributedString(milestonesDone: Int, totalMilestones: Int) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Job Milestones  \(milestonesDone) ", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(hex: "#313D48")]))
        attributedString.append(NSAttributedString(string: "of \(totalMilestones)", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontRoman(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(hex: "#313D48")]))
        return attributedString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func viewQuoteButtonAction(_ sender: UIButton) {
        viewQuoteAction?()
    }
            
    @IBAction func detailButtonAction(_ sender: UIButton) {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            if sender == rateButton {
                rateBuilderAction?()
            } else  {
                detailAction?()
            }
        }
    }        
}
