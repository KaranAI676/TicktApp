//
//  JobQuotesCell.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

class JobQuotesCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet weak var quoteButton: UIButton!
    
    //MARK:- Variables
    var actionButtonClosure: (()->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   }

//MARK:- IB Actions
extension JobQuotesCell{
    @IBAction func quoteButtonTap(_ sender: UIButton) {
        self.actionButtonClosure?()
    }
}
