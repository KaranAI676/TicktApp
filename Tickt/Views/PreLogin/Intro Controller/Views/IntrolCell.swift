//
//  IntrolCell.swift
//  Tickt
//
//  Created by Admin on 08/03/21.
//

import UIKit

class IntrolCell: UICollectionViewCell {
    
    @IBOutlet weak var introImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        introImageView.contentMode = .scaleToFill
    }
}
