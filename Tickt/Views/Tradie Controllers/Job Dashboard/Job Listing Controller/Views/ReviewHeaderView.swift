//
//  ReviewHeaderCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 07/07/21.
//

import FloatRatingView

class ReviewHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var editButton: CustomBoldButton!
    @IBOutlet weak var reviewLabel: CustomRomanLabel!
    @IBOutlet weak var replyButton: CustomBoldButton!
    @IBOutlet weak var dateLabel: CustomRegularLabel!
    @IBOutlet weak var deleteButton: CustomBoldButton!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyButtonHeightConstraint: NSLayoutConstraint!
    
    var allReviewData: AllReviewData? {
        didSet {
            userImage.sd_setImage(with: URL(string: allReviewData?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            nameLabel.text = allReviewData?.name
            dateLabel.text = allReviewData?.date
            starRatingView.rating = allReviewData?.rating ?? 0
            reviewLabel.attributedText = allReviewData?.review.getFormattedReview()
        }
    }
    
    var editButtonAction: (()->())?
    var replyButtonAction: (()->())?
    var deleteButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        switch sender {
        case editButton:
            editButtonAction?()
        case replyButton:
            replyButtonAction?()
        case deleteButton:
            deleteButtonAction?()
        default:
            break
        }
    }    
}
