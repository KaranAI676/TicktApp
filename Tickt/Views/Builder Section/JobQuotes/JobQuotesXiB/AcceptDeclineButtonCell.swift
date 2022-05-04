//
//  AcceptDeclineButtonCell.swift
//  Tickt
//
//  Created by Admin on 15/09/21.
//

import UIKit

class AcceptDeclineButtonCell:UITableViewCell {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var buttonOutlet: UIButton!
    
    //MARK:- PROPERTIES
    //================
    var buttonTap:(()->Void)?
    
    //MARK:- CELL LIFE CYCLE
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- FUNCTIONS
    //===============
    func setButtonTitle(index:Int){
        if index == 0{
            buttonOutlet.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9019607843, blue: 0, alpha: 1)
            buttonOutlet.setTitle("Accept Quote", for: .normal)
        }else{
            buttonOutlet.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            buttonOutlet.setTitle("Decline Quote", for: .normal)
        }
    }
}


//MARK:- IBACTIONS
//===============
extension AcceptDeclineButtonCell {
    @IBAction func buttonTap(_ sender: UIButton) {
        guard let buttonTap = buttonTap else { return  }
        buttonTap()
    }
}
