//
//  PaymentDetailTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 17/06/21.
//

import UIKit

class PaymentDetailTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstariant: NSLayoutConstraint!
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PaymentDetailTableCell {
    
    func populateUI (_ cellType: ConfirmAndPayDetailsBuilderVC.CellArray) {
        leftLabel.text = cellType.title
        leftLabel.textColor = cellType.textColor
        rightLabel.textColor = cellType.textColor
        leftLabel.font = cellType.font
        rightLabel.font = cellType.font
        containerView.backgroundColor = cellType.bgColor
        rightLabel.isHidden = cellType == .title
        if cellType == .title {
            topConstraint.constant = 24
        }
        if cellType == .total {
            bottomConstariant.constant = 24
        }
    }
}
