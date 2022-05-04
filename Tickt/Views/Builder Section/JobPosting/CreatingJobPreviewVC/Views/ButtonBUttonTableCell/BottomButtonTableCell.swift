//
//  ButtonBUttonTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 30/03/21.
//

import UIKit

class BottomButtonTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK:- Variables
    var actionButtonClosure: (()->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.actionButtonClosure?()
        self.disableButton(sender)
    }
}

extension BottomButtonTableCell {
    
    func setTitle(title: String) {
        self.actionButton.setTitle(title, for: .normal)
        self.actionButton.setTitle(title, for: .selected)
    }
}
