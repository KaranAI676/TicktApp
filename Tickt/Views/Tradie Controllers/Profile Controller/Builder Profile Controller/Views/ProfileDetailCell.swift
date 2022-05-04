//
//  ProfileDetailCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

import UIKit

class ProfileDetailCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var ratingLabel: CustomBoldLabel!
    @IBOutlet weak var jobCountLabel: CustomBoldLabel!
    @IBOutlet weak var userNameLabel: CustomBoldLabel!
    @IBOutlet weak var designationLabel: CustomRomanLabel!
    @IBOutlet weak var companyNameLabel: CustomRomanLabel!
    @IBOutlet weak var reviewCountLabel: CustomRomanLabel!
    
    var messageButtonAction: (()->())?
    
    var profileDetail: ProfileResult? {
        didSet {
            designationLabel.text = profileDetail?.position
            userNameLabel.text = profileDetail?.builderName
            companyNameLabel.text = profileDetail?.companyName
            ratingLabel.text = "\(profileDetail?.ratings ?? 0)"
            reviewCountLabel.text = "\(profileDetail?.reviewsCount ?? 0) reviews"
            jobCountLabel.text = "\(profileDetail?.jobCompletedCount ?? 0)"
            userImageView.sd_setImage(with: URL(string: profileDetail?.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        messageButtonAction?()
    }
}
