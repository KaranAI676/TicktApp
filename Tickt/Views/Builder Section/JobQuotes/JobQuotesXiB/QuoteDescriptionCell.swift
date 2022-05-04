//
//  QuoteDescriptionCell.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

class QuoteDescriptionCell: UITableViewCell {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var itemValue: UILabel!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var price: UILabel!
    
    //MARK:- PROPERTIES
    //================
//    var quoteModel: QuoteItem? {
//        didSet {
//            populateUI()
//        }
//    }
    
    //MARK:- CELL LIFE CYCLE
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- FUNCTIONS
    //===============
    func populateUI(quoteModel:QuoteItem,srno:Int){
        itemValue.text = "\(srno)"
        discription.text = quoteModel.description
        let amount = "\(quoteModel.totalAmount)".currencyFormatting()
        price.text = amount
    }
    
    func populateUIK(des:String,amount:String,srno:Int){
        itemValue.text = "\(srno)"
        discription.text = des
        price.text = amount
    }
}


//MARK:- IBACTIONS
//===============
extension QuoteDescriptionCell {
    
}
