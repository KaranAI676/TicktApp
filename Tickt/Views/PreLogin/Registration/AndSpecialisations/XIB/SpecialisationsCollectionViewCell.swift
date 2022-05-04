//
//  SpecialisationsCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 08/03/21.
//

import UIKit

class SpecialisationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var spelisationNameLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstrint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUIForAreaOfJobs(specializationName: String) {
        spelisationNameLabel.text = specializationName
        spelisationNameLabel.textColor = AppColors.themeBlue
        backView.backgroundColor = AppColors.backGorundWhite
    }
}
