//
//  PortfolioImageCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 13/06/21.
//

import UIKit

class PortfolioImageCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var pencilIconImageView: UIImageView!
    
    //MARK:- Variable
    var collectionView: UICollectionView? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
