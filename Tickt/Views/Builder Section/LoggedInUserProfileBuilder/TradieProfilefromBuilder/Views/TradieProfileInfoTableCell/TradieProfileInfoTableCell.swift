//
//  TradieProfileInfoTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import UIKit

class TradieProfileInfoTableCell: UITableViewCell {
    
    enum CellType {
        case tradieProfile
        case loggedInProfile
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainCOntainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var messageBackView: UIView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var buttonClosure: (()->Void)? = nil
    var editProfileClosure: (()->Void)? = nil
    var editButtonClosure: (()->Void)? = nil
    var messageButtonClosure: (()->Void)? = nil
    var model: TradieProfileResult? = nil {
        didSet {
            populateUI(.tradieProfile)
        }
    }
    var loggedInModel: BuilderProfileResult? = nil {
        didSet {
            populateUI(.loggedInProfile)
        }
    }    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case editProfileButton:
            editProfileClosure?()
        case editButton:
            editButtonClosure?()
        case messageButton:
            sender.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sender.isUserInteractionEnabled = true
            }
            messageButtonClosure?()
        default:
            buttonClosure?()
        }
    }
}

extension TradieProfileInfoTableCell {
    
    private func populateUI(_ cellType: CellType) {
        switch cellType {
        case .tradieProfile:
            guard let model = self.model else { return }
            profileImageView.sd_setImage(with: URL(string:(model.tradieImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            userNameLabel.text = model.tradieName
            if model.businessName == "" {
                subLabel.text = model.areasOfSpecialization.tradeData.first?.tradeName //Harpreet
                companyNameLabel.isHidden = true
            }else{
                companyNameLabel.isHidden = false
                companyNameLabel.text = model.areasOfSpecialization.tradeData.first?.tradeName
                subLabel.text = model.businessName ?? ""
            }
        case .loggedInProfile:
            guard let model = loggedInModel else { return }
            profileImageView.sd_setImage(with: URL(string: model.builderImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            userNameLabel.text = model.builderName
            messageButton.isHidden = true
            
            if model.companyName == "" {
                subLabel.text = model.position //Harpreet
                companyNameLabel.isHidden = true
            }else{
                companyNameLabel.isHidden = false
                companyNameLabel.text = model.companyName
                subLabel.text = model.position
            }
        }
    }
}
