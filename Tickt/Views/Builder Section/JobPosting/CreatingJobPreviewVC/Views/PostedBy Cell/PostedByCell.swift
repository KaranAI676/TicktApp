//
//  PostedByCell.swift
//  Tickt
//
//  Created by Admin on 27/04/21.
//

import UIKit
import SDWebImage

class PostedByCell: UITableViewCell {
        
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewLabel: CustomRegularLabel!
    
    var profileButtonClosure: (()->())? = nil
    var messageButtonClosure: (()->())? = nil
    
    var postedUser: PostedBy? {
        didSet {
            populateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        sender == profileButton ? profileButtonClosure?() : messageButtonClosure?()
    }
}

extension PostedByCell {
    
    private func populateUI() {
        nameLabel.text = postedUser?.builderName
        let rating = postedUser?.ratings == 0.0 ? 0 : (postedUser?.ratings ?? 0)
        let review = postedUser?.reviews ?? 0
        reviewLabel.text = "\(rating), \(review) reviews"
        profileImageView.sd_setImage(with: URL(string: postedUser?.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
    }
}
