//
//  TotalButtonCell.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

class TotalButtonCell:UITableViewCell {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var totalButton: UIButton!
    
    //MARK:- PROPERTIES
    //================
    
    //MARK:- CELL LIFE CYCLE
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- FUNCTIONS
    //===============
   
    
}


//MARK:- IBACTIONS
//===============
extension TotalButtonCell {
    @IBAction func totalButtonTap(_ sender: UIButton) {
   
    }
}
