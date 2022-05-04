//
//  ProfileTopViewTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 23/06/21.
//

import UIKit
import TTTAttributedLabel

class ProfileTopViewTableCell: UITableViewCell {

    enum ButtonType {
        case profilePreview
        case editProfile
        case viewProfile
        case completeProfile
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainCOntainerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var editProfileBUtton: UIButton!
    @IBOutlet weak var profilePreviewButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomTitleLabel: TTTAttributedLabel!
    @IBOutlet weak var progressBarView: HorizontalProgressBar!
    @IBOutlet weak var percentageLabel: UILabel!
    
    //MARK:- Variables
    var buttonClosure: ((ButtonType)-> Void)? = nil
    var model: LoggedInUserProfileResultModel? = nil {
        didSet {
            populateUI()
        }
    }
    
    //MARK:- LifeCycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttontapped(_ sender: UIButton) {
        switch sender {
        case profilePreviewButton:
            buttonClosure?(.profilePreview)
        case editProfileBUtton:
            buttonClosure?(.editProfile)
        case viewProfileButton:
            buttonClosure?(.viewProfile)
        default:
            break
        }
    }
}

extension ProfileTopViewTableCell {
    
    private func configUI() {
        if kUserDefaults.isTradie() {
            viewProfileButton.setTitle("View public profile", for: .normal)
        }
        setupAttributtedText()
    }
    
    private func setupAttributtedText() {
        bottomTitleLabel.text = kUserDefaults.getUserType() == 2 ? "Complete your profile to find tradies" : "Complete your profile to get jobs faster"
        setupPrivacyPolicyAndTermsAndConditions()
    }
    
    private func populateUI() {
        guard let model = model else { return }
        userNameLabel.text = model.userName
        userImageView.sd_setImage(with: URL(string: model.userImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        let completedCount = Int(model.profileCompleted.replace(string: "%", withString: "")) ?? 0
        CommonFunctions.setProgressBar(milestoneDone: completedCount, totalMilestone: 100, progressBarView)
        percentageLabel.text = model.profileCompleted
    }
}

//MARK:- TTTAttributedLabel & TTTAttributedLabelDelegate
//======================================================
extension ProfileTopViewTableCell: TTTAttributedLabelDelegate {
    
    func setupPrivacyPolicyAndTermsAndConditions(clickableText: String = "Complete your profile") {
        let label = bottomTitleLabel
        guard let linkString: NSString = label?.text! as? NSString else{ return }
        
        let linkAttributedString = NSAttributedString(string:linkString as String, attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 12), NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle(), NSAttributedString.Key.foregroundColor: AppColors.themeGrey])
        
          label?.setText(linkAttributedString)
        
          label?.linkAttributes = [NSAttributedString.Key.foregroundColor: AppColors.highlightedBlue, NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 12)]
       
        let secondTextString: NSRange = linkString.range(of: clickableText)
        label?.addLink(toPhoneNumber: clickableText, with: secondTextString)
        label?.delegate = self
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        buttonClosure?(.completeProfile)
    }
}
