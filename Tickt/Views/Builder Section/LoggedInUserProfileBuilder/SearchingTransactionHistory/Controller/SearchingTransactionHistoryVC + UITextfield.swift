//
//  SearchingTransactionHistoryVC + UITextfield.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation

//MARK:- UITextField: Delegate
//============================
extension SearchingTransactionHistoryVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if !updatedText.isEmpty {
                setupUIChnages(width: 0)
                searchText = updatedText
            } else {
                setupUIChnages(width: 30)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
