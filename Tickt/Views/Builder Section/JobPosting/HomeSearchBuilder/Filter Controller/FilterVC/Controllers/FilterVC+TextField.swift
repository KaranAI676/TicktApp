//
//  FilterVC+TextField.swift
//  Tickt
//
//  Created by Admin on 03/05/21.
//

import UIKit

extension FilterVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces {
            let newText = text.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
            if newText.isEmpty || (newText.count == 1 && newText == CommonStrings.dot) {
                textField.text = CommonStrings.emptyString
                filterData.price = newText
            } else {
                textField.text = CommonStrings.dollar + newText
                filterData.price = newText
            }
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.byRemovingLeadingTrailingWhiteSpaces
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? CommonStrings.emptyString
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText == "0" || updatedText == "$0" || updatedText == "$." {
            return false
        }
        
        let dollarRemovedCurrentText = currentText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
        let dollarRemovedUpdatedTrxt = updatedText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
        
        /// This block of code used to restrict the user, Once the price entered of Six digits. eg: 123456
//        if dollarRemovedUpdatedTrxt.count > 6 && !(dollarRemovedCurrentText.contains(CommonStrings.dot)) {
//            return false
//        }
        /// This block of code used to handle the decimal part of the price. eg: 12345.12
        if dollarRemovedUpdatedTrxt.isValidPrice {
            return true
        } else {
            if dollarRemovedUpdatedTrxt.last == "." || dollarRemovedCurrentText.last == "." {
                if string == CommonStrings.emptyString {
                    return true
                } else {
                    if string == "." {
                        return !currentText.contains(CommonStrings.dot)
                    }
                }
            }
            else { return false }
        }
        return true
    }
}
