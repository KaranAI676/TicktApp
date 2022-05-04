//
//  DescriptionTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 20/05/21.
//

import UIKit

class DescriptionTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    ///
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var descriptionText: String = "" {
        didSet {
            self.descriptionLabel.text = descriptionText
        }
    }
    
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
