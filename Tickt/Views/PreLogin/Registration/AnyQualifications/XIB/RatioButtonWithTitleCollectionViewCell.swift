//
//  ratioButtonWithTitleCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 08/03/21.
//

import UIKit

class RatioButtonWithTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var uploadedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var uploadDocumentButton: CustomRegularButton!
    
    var collectionView: UICollectionView? = nil
    var buttonClosure: ((IndexPath)->(Void))? = nil
    var deleteImageButtonAction: ((IndexPath) -> ())? = nil
    var uploadButtonAction: ((IndexPath) -> ())? = nil
        
    override func awakeFromNib() {
        super.awakeFromNib()
        congigCell()
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let collectionView = self.collectionView {
            if let index = collectionViewIndexPath(collectionView) {
                self.buttonClosure?(index)
            }
        }
    }

    @objc func uploadDocumentButtonAction(_ sender: UIButton) {
        if let collectionView = self.collectionView {
            if let index = collectionViewIndexPath(collectionView) {
                self.uploadButtonAction?(index)
            }
        }
    }
    
    @objc func deleteImageButtonAction(_ sender: UIButton) {
        if let collectionView = self.collectionView {
            if let index = collectionViewIndexPath(collectionView) {
                self.deleteImageButtonAction?(index)
            }
        }
    }

}

//MARK:- Priavte Methods
//======================
extension RatioButtonWithTitleCollectionViewCell {
    
    private func congigCell() {
        uploadDocumentButton.addTarget(self, action: #selector(uploadDocumentButtonAction(_:)), for: .touchUpInside)
        deleteImageButton.addTarget(self, action: #selector(deleteImageButtonAction(_:)), for: .touchUpInside)
    }
}
