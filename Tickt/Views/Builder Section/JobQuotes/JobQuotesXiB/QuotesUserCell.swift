//
//  QuotesUserCell.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

class QuotesUserCell: UITableViewCell {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var userinfoView: UIView!
    @IBOutlet weak var quotesView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: CustomBoldLabel!
    @IBOutlet weak var reviewNumbers: CustomRegularLabel!
    @IBOutlet weak var quoteBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK:- PROPERTIES
    //================
    var buttonClosure: ((IndexPath)->Void)? = nil
    var tableView: UITableView? = nil
    var applicationModel: QuoteList? {
        didSet {
            populateUI()
        }
    }
    
    
    //MARK:- CELL LIFE CYCLE
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        quoteBtn.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- FUNCTIONS
    //===============
    
}

extension QuotesUserCell {
    
    private func populateUI() {
        guard  let model = self.applicationModel else { return }
        userName.text = model.tradieName
        let rating = model.rating.rounded(toPlaces: 2)
        reviewNumbers.text = "\(rating), \(model.reviewCount) reviews"
        userImage.sd_setImage(with: URL(string: model.tradieImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        ///
        if model.totalQuoteAmount == 0 {
            quoteBtn.setTitle("Quotes", for: .normal)
        } else {
            let amount = "\(model.totalQuoteAmount)".currencyFormatting()
            quoteBtn.setTitle("Quotes: \(amount)", for: .normal)
        }        
        statusLabel.text = model.status.uppercased()
    }
}


//MARK:- IBACTIONS
//===============
extension QuotesUserCell {
    @IBAction func nextButtonTap(_ sender: UIButton) {
        guard  let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            self.buttonClosure?(index)
        }
    }
    
    @IBAction func quotesBtnTap(_ sender: UIButton) {
        
    }
    
}
