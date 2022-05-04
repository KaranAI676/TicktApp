//
//  SearchListCell.swift
//  Tickt
//
//  Created by Admin on 25/03/21.
//

import UIKit
import SDWebImage

class SearchListCell: UITableViewCell {
    
    var detailAction: (() -> ())?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var jobNameLabel: CustomRegularLabel!
    @IBOutlet weak var categoryNameLabel: CustomBoldLabel!
    
    var job: RecommmendedJob? {
        didSet {
            timeLabel.text = job?.time
            priceLabel.text = job?.amount
            daysLabel.text = job?.durations
            addressLabel.text = job?.locationName
            descriptionLabel.text = job?.jobDescription
            viewLabel.text = "\(job?.viewersCount ?? 0)"
            commentLabel.text = "\(job?.questionsCount ?? 0)"
            if kUserDefaults.isTradie() {
                jobImageView.sd_setImage(with: URL(string: job?.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
                jobNameLabel.text = job?.builderName
                categoryNameLabel.text = job?.jobName
            } else {
                jobImageView.sd_setImage(with: URL(string: job?.tradeSelectedUrl ?? ""), placeholderImage: nil)
                jobNameLabel.text = job?.jobName
                categoryNameLabel.text = job?.tradeName
            }
        }
    }
    
    var loggedInModel: JobpostedDataModel? {
        didSet {
            guard let model = loggedInModel else { return }
            timeLabel.text = model.time
            priceLabel.text = model.amount
            daysLabel.text = model.durations
            jobNameLabel.text = model.jobName
            addressLabel.text = model.locationName
            categoryNameLabel.text = model.tradeName
            descriptionLabel.text = model.jobDescription
            viewLabel.text = "\(model.viewersCount)"
            commentLabel.text = "\(model.questionsCount)"
            jobImageView.sd_setImage(with: URL(string: model.tradeSelectedUrl), placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        jobImageView.makeCircular()
        containerView.addShadow(shadowColor: .lightGray, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.4, shadowRadius: 2)
    }
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            detailAction?()
        }
    }        
}
