//
//  ReviewsTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import UIKit
import Cosmos

class ReviewsTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK:- Variables
    var reviewModel: TradieProfileReviewData? {
        didSet {
            populateUI()
        }
    }
    
    //MARK:- LIfeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ReviewsTableCell {
    
    private func configUI() {
        ratingView.settings.fillMode = .half
        ratingView.settings.updateOnTouch = false
    }
}

extension ReviewsTableCell {
    
    private func populateUI () {
        guard let model = reviewModel else { return }
        profileImageView.sd_setImage(with: URL(string: model.reviewSenderImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        userNameLabel.text = model.reviewSenderName
        dateLabel.text = model.date
        ratingView.rating = model.ratings
        descriptionLabel.attributedText = model.review.getFormattedReview()
    }
}
