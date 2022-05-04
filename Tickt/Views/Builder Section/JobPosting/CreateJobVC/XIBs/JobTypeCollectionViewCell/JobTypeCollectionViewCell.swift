//
//  JobTypeCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 23/03/21.
//

import UIKit

class JobTypeCollectionViewCell: UICollectionViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var spelisationNameLabel: UILabel!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
}

extension JobTypeCollectionViewCell {
    
    private func configCell() {
       // self.backView.cropCorner(radius: 6)
    }
    
    func populateUI(image: UIImage, title: String) {
        self.imageViewOutlet.image = image
        self.spelisationNameLabel.text = title
    }
}
