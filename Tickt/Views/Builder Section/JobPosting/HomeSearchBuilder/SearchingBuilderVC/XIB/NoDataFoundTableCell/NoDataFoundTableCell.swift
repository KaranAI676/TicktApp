//
//  NoDataFoundTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 27/04/21.
//

import UIKit

class NoDataFoundTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var placeHolderImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
