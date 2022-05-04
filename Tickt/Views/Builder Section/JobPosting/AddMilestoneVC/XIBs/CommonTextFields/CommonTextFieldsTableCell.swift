//
//  CommonTextFieldsTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 22/03/21.
//

import UIKit

class CommonTextFieldsTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var textFielddContainerView: UIView!
    @IBOutlet weak var textFieldTitleLabel: UILabel!
    @IBOutlet weak var textFieldTextField: UITextField!
    @IBOutlet weak var textFieldErrorLabel: UILabel!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        congifUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CommonTextFieldsTableCell {
    
    private func congifUI() {
        self.selectionStyle = .none
    }
    
    func populateUI(titleName: String, placeHolder: String) {
        textFieldTitleLabel.text = titleName
        textFieldTextField.placeholder = placeHolder
    }
}
