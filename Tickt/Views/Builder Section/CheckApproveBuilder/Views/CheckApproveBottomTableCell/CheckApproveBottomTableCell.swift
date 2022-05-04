//
//  CheckApproveBottomTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 17/05/21.
//

import UIKit

class CheckApproveBottomTableCell: UITableViewCell {

    enum ButtonType {
        case upperForward
        case bottomForward
        case message
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topTitleView: UIView!
    @IBOutlet weak var topTitleLabel: UILabel!
    ///
    @IBOutlet weak var postedByView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: CustomBoldLabel!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var reviewLabel: CustomRegularLabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var upperForwardButton: UIButton!
    ///
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomForwardButton: UIButton!
    
    //MARK:- Variables
    var buttonClosure: ((ButtonType)->(Void))? = nil
    
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
        case messageButton:
            sender.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sender.isUserInteractionEnabled = true
            }
            self.buttonClosure?(.message)
        case upperForwardButton:
            self.buttonClosure?(.upperForward)
        case bottomForwardButton:
            self.buttonClosure?(.bottomForward)
        default:
            break
        }
    }
}
