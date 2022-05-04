//
//  ProfileOptionTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 23/06/21.
//

import UIKit

class ProfileOptionTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionNameLabel: UILabel!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
