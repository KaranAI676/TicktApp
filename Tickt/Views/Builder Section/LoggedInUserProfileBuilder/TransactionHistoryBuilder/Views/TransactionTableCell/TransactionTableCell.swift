//
//  TransactionTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import UIKit

class TransactionTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var activeBackView: UIView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var transationModel: TransactionHistoryRevenueListModel? = nil {
        didSet {
            populateUI()
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TransactionTableCell {
    
    private func populateUI() {
        guard let model = transationModel else { return }
        profileImageView.sd_setImage(with: URL(string: model.tradieImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        jobNameLabel.text = model.jobName
        dateLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        priceLabel.text = model.earning
        ///
        if let jobStatus = JobStatus.init(rawValue: model.status.uppercased()), jobStatus == .active {
            activeLabel.text = jobStatus.rawValue.capitalized
            activeBackView.isHidden = false
            dateLabel.isHidden = true
        } else {
            activeBackView.isHidden = true
            dateLabel.isHidden = false
        }
    }
}
