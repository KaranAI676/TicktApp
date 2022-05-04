//
//  ReasonCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 01/06/21.
//

import UIKit

class ReasonCollectionViewCell: UICollectionViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Variables
    var collectionView: UICollectionView? = nil
    var buttonClosure: ((IndexPath)->Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let collectionView = collectionView else { return }
        if let index = collectionViewIndexPath(collectionView) {
            buttonClosure?(index)
        }
    }
}
