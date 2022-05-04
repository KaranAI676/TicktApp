//
//  ReviewCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

import FloatRatingView

class ReviewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var dateLabel: CustomRegularLabel!
    @IBOutlet weak var reviewLabel: CustomRomanLabel!
    @IBOutlet weak var replyButton: CustomBoldButton!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var buttonButtonHeight: NSLayoutConstraint!
    
    var review: ReviewData? {
        didSet {
            userImage.sd_setImage(with: URL(string: review?.reviewSenderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            nameLabel.text = review?.reviewSenderName
            dateLabel.text = review?.date
            reviewLabel.text = review?.review
            starRatingView.rating = review?.ratings ?? 0
        }
    }
    
    var allReviewData: AllReviewData? {
        didSet {
            userImage.sd_setImage(with: URL(string: allReviewData?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            nameLabel.text = allReviewData?.name
            dateLabel.text = allReviewData?.date
            reviewLabel.text = allReviewData?.review
            starRatingView.rating = allReviewData?.rating ?? 0            
        }
    }

    var replyButtonClosure: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func replyButtonAction(_ sender: UIButton) {
        replyButtonClosure?()
    }
}
