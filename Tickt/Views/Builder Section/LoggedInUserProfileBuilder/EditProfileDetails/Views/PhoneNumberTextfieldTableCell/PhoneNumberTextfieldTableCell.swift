//
//  PhoneNumberTextfieldTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 05/07/21.
//

import UIKit

class PhoneNumberTextfieldTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var countryCodeTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var updateTextClosure: ((String)->Void)? = nil
    var updateTextWithIndexClosure: ((String, IndexPath)->Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PhoneNumberTextfieldTableCell {
    
    private func configUI() {
        countryCodeTextfield.text = "+61"
        countryCodeTextfield.isUserInteractionEnabled = false
        self.phoneNumberTextfield.addTarget(self, action: #selector(didChange(textfield:)), for: .editingChanged)
    }
    
    @objc private func didChange(textfield: UITextField) {
        guard let tableView = tableView else {
            updateTextClosure?(textfield.text?.byRemovingLeadingTrailingWhiteSpaces ?? "")
            return
        }
        if let index = tableViewIndexPath(tableView) {
            updateTextWithIndexClosure?(textfield.text?.byRemovingLeadingTrailingWhiteSpaces ?? "", index)
        }
    }
}
