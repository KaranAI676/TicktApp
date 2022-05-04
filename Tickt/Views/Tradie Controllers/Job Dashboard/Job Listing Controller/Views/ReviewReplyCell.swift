//
//  ReviewReplyCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 08/07/21.
//

import FloatRatingView

class ReviewReplyCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var editButton: CustomBoldButton!
    @IBOutlet weak var dateLabel: CustomRegularLabel!
    @IBOutlet weak var reviewLabel: CustomRomanLabel!
    @IBOutlet weak var deleteButton: CustomBoldButton!
    @IBOutlet weak var editHieght: NSLayoutConstraint!
      
    var editButtonAction: (()->())?
    var deleteButtonAction: (()->())?
    
    var replyData: ReplyData? {
        didSet {
            if replyData?.isModifiable ?? false {
                editHieght.constant = 40
            } else {
                editHieght.constant = 0
            }
            userImage.sd_setImage(with: URL(string: replyData?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            nameLabel.text = replyData?.name
            dateLabel.text = replyData?.date
            reviewLabel.text = replyData?.reply
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case editButton:
            editButtonAction?()
        default:
            deleteButtonAction?()
        }
    }    
}
