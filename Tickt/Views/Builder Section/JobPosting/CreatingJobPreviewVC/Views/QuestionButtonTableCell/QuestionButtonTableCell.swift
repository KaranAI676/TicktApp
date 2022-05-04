//
//  QuestionButtonTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 30/03/21.
//

import UIKit

class QuestionButtonTableCell: UITableViewCell {

    
    //MARK:- IB Outlets
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK:- Variables
    var actionButtonClosure: (()->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.actionButtonClosure?()
    }
}
