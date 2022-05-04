//
//  ApplyJobCell.swift
//  Tickt
//
//  Created by Admin on 27/04/21.
//

import UIKit

class ApplyJobCell: UITableViewCell {
        
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var applyButton: CustomBoldButton!
    @IBOutlet weak var bookmarkButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var bookmarkLeadingConstraint: NSLayoutConstraint!

    var isJobSaved = false
    var applyButtonClosure: (()->())? = nil
    var bookmarkButtonClosure: ((_ status: Bool)->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showSaveButton() {
        bookmarkButton.isSelected = kUserDefaults.isTradie() && isJobSaved
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        buttonActionHandler(sender)
    }
}

extension ApplyJobCell {
    
    private func buttonActionHandler(_ sender: UIButton) {
        switch kUserDefaults.getUserType() {
        case 1:
            if sender == bookmarkButton {
                bookmarkButtonClosure?(isJobSaved)
            } else {
                if sender.titleLabel?.text?.lowercased() == "apply" || sender.titleLabel?.text?.lowercased() == "quote" || sender.titleLabel?.text?.lowercased() == "quote sent" {
                    applyButtonClosure?()
                } else if sender.titleLabel?.text?.lowercased() == "applied" {
                    CommonFunctions.showToastWithMessage("You have already applied for this job")
                }
            }
        case 2:
            if sender == bookmarkButton {
                bookmarkButtonClosure?(isJobSaved)
            } else {
                applyButtonClosure?()
            }
        default:
            break
        }
    }
}
