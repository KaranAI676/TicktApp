//
//  ButtonCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

import UIKit

class ButtonCell: UITableViewCell {
        
    var completeButtonAction: (()->())?
    
    @IBOutlet weak var completeButton: CustomBoldButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func completeButtonAction(_ sender: Any) {
        completeButtonAction?()
    }
}
