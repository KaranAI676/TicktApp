//
//  CCVTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import UIKit

class CCVTableCell: UITableViewCell {

    //MARK:- IB Outelst
    /// Expiration
    @IBOutlet weak var expirationView: UIView!
    @IBOutlet weak var expirationTitleLabel: UILabel!
    @IBOutlet weak var expirationTextField: UITextField!
    /// CVV
    @IBOutlet weak var cvvView: UIView!
    
    @IBOutlet weak var cvvTitleLabel: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    
    //MARK:- Variables
    var cvvClosure: ((String)-> Void)? = nil
    var expirationClosure: ((String)-> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CCVTableCell {
    
    private func configUI() {
        setupTextFields()
        ///
        self.expirationTextField.addTarget(self, action: #selector(expirationDidChange(textfield:)), for: .editingChanged)
        self.cvvTextField.addTarget(self, action: #selector(cvvDidChange(textfield:)), for: .editingChanged)
    }
    
    private func setupTextFields() {
        cvvTextField.keyboardType = .numberPad
        expirationTextField.keyboardType = .numberPad
        ///
        cvvTextField.isSecureTextEntry = true
        cvvTextField.placeholder = "CVV"
        expirationTextField.placeholder = "MM/YY"
    }
    
    @objc private func expirationDidChange(textfield: UITextField) {
        expirationClosure?(textfield.text?.byRemovingLeadingTrailingWhiteSpaces ?? "")
    }
    
    @objc private func cvvDidChange(textfield: UITextField) {
        cvvClosure?(textfield.text?.byRemovingLeadingTrailingWhiteSpaces ?? "")
    }
}
