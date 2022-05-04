//
//  BottomButtonsTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 20/05/21.
//

import UIKit

class BottomButtonsTableCell: UITableViewCell {

    enum ButtonTypes {
        case firstButton
        case secondButton
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    //MARK:- Variables
    var buttonClosure: ((ButtonTypes)->(Void))? = nil
    
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
        case firstButton:
            buttonClosure?(.firstButton)
        case secondButton:
            buttonClosure?(.secondButton)
        default:
            break
        }
    }
}
