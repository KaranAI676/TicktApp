//
//  TitleHeaderCollectionView.swift
//  Tickt
//
//  Created by S H U B H A M on 27/04/21.
//

import UIKit

class TitleHeaderCollectionView: UICollectionReusableView {
    
    //MARK:- IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
