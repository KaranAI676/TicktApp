//
//  CommonTextfieldTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 26/05/21.
//

import UIKit

class CommonTextfieldTableCell: UITableViewCell {

    @IBOutlet weak var commonTextFiled: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var changeButton: UIButton!
    
    var tableView: UITableView? = nil
    var updateTextClosure: ((String)->Void)? = nil
    var updateTextWithIndexClosure: ((String, IndexPath)->Void)? = nil
    var buttonClosure: (()->Void)? = nil
    var buttonClosureWithIndex: ((IndexPath)->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = tableView else {
            buttonClosure?()
            return
        }
        if let index = tableViewIndexPath(tableView) {
            buttonClosureWithIndex?(index)
        }
    }
}

extension CommonTextfieldTableCell {
    
    private func configUI() {
        self.commonTextFiled.addTarget(self, action: #selector(didChange(textfield:)), for: .editingChanged)
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
