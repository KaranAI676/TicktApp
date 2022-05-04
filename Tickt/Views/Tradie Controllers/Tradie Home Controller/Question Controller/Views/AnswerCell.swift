//
//  AnswerCell.swift
//  Tickt
//
//  Created by Admin on 06/05/21.
//

import UIKit
import SDWebImage

class AnswerCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var dateLabel: CustomRegularLabel!
    @IBOutlet weak var answerLabel: CustomRomanLabel!
    
    var answer: AnswerData? {
        didSet {
            dateLabel.text = answer?.createdAt
            nameLabel.text = (answer?.sender_user_type == 1) ? answer?.tradie.first?.firstName : answer?.builder.first?.firstName
            answerLabel.text = answer?.answer
            let image = (answer?.sender_user_type == 1) ? answer?.tradie.first?.user_image : answer?.builder.first?.user_image
            userImage.sd_setImage(with: URL(string: image ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
}
