//
//  PastRevenueJobCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 13/07/21.
//

import UIKit

class PastRevenueJobCell: UITableViewCell {

    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var dateLabel: CustomRomanLabel!
    @IBOutlet weak var amountLabel: CustomBoldLabel!
    @IBOutlet weak var jobNameLabel: CustomMediumLabel!
    
    var revenueModel: RevenueListData? = nil {
        didSet {
            populateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func populateUI() {
        guard let model = revenueModel else { return }
        jobImageView.sd_setImage(with: URL(string: model.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        jobNameLabel.text = model.jobName
        dateLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate?.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        amountLabel.text = model.earning
    }
}
