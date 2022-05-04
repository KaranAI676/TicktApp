//
//  JobListPopupCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 16/08/21.
//

import UIKit

class JobListPopupCell: UITableViewCell {

    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var tradeNameLabel: CustomRomanLabel!
    
    var jobDetail: JobListDetail? {
        didSet {
            jobNameLabel.text = jobDetail?.jobName
            tradeNameLabel.text = jobDetail?.tradeName
            tradeImageView.sd_setImage(with: URL(string: jobDetail?.tradeImg ?? ""), placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
