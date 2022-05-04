//
//  TradeSpecTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 23/05/21.
//

import UIKit

class TradeSpecTableCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- Variables
    var model: tradeSpecial? {
        didSet {
            self.populateUI()
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension TradeSpecTableCell {    
    private func populateUI() {
        guard let model = self.model else { return }
        nameLabel.text = model.name
        imageBackView.isHidden = model.type == .specialisation
        mainContainerView.backgroundColor = model.type == .specialisation ? #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9803921569, alpha: 1) : #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        imageView.sd_setImage(with: URL(string: model.image), placeholderImage: nil)
    }
}
