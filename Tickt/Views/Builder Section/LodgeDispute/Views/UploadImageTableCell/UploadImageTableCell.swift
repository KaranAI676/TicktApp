//
//  UploadImageTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import UIKit

class UploadImageTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
