//
//  ChangeRequestCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 02/07/21.
//

import UIKit

class ChangeRequestCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: CustomBoldLabel!
    @IBOutlet weak var acceptButton: CustomBoldButton!
    @IBOutlet weak var declineButton: CustomBoldButton!
    @IBOutlet weak var changeRequestLabel: CustomRomanLabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var acceptButtonAction: (()->())?
    var declineButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.addShadow(shadowColor: .gray, shadowOffset: CGSize(width: 1.5, height: 1.5), shadowOpacity: 0.23, shadowRadius: 1.3)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case acceptButton:
            acceptButtonAction?()
        default:
            declineButtonAction?()
        }
    }    
}
