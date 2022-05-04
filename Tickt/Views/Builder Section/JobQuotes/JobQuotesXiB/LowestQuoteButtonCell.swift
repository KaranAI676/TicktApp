//
//  LowestQuoteButtonCell.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

class LowestQuoteButtonCell: UITableViewCell {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var quoteOrderBtn: UIButton!
    @IBOutlet weak var dropDownImage: UIImageView!
    
    //MARK:- PROPERTIES
    //================
    var tap:(()->Void)?
    
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
extension LowestQuoteButtonCell {
    @IBAction func quoteOrderBtnTap(_ sender: UIButton) {
        guard let tap = tap else { return  }
        tap()
    }
}
