//
//  TitleLabelForNamesTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 08/07/21.
//

import UIKit

class TitleLabelForNamesTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var titleNameLabel: UILabel!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
