//
//  AddQualificationDocument.swift
//  Tickt
//
//  Created by Vijay's Macbook on 30/06/21.
//

import UIKit

class AddQualificationDocument: UITableViewCell {

    var addQualificationAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        addQualificationAction?()
    }
}
