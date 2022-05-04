//
//  RectangularTradeCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 19/04/21.
//

import UIKit

class RectangularTradeCollectionViewCell: UICollectionViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var iconImaegView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
