//
//  PaymentDetail+TextField.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//

import Foundation

extension PaymentDetailVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEdit
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == accountNumberField {
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumeric, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 20)
        } else if textField == bsbNumberField {
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 7)
        } else {
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphabets, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 25)
        }
    }
}
