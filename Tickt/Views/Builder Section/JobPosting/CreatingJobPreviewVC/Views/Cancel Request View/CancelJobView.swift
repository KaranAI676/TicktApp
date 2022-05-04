//
//  CancelRequestView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 28/07/21.
//

import UIKit

class CancelJobView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: CustomBoldButton!
    @IBOutlet weak var cancelButton: CustomBoldButton!
    @IBOutlet weak var reasonTextView: CustomRomanTextView!
    
    var cancelRequestClosure: ((_ note: String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case doneButton:
            if validate() {
                cancelRequestClosure?(reasonTextView.text.byRemovingLeadingTrailingWhiteSpaces)
                popOut()
            }
        default:
            popOut()
        }
    }
    
    func validate() -> Bool {
        if reasonTextView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyNote)
            return false
        }
        return true
    }
}

