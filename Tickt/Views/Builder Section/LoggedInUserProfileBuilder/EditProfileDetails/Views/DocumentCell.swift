//
//  DocumentCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 30/06/21.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var documentNameLabel: CustomMediumLabel!
    
    var deleteButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        deleteButtonAction?()
    }    
}
