//
//  SearchRevenue+TextField.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation

extension SearchRevenueVC: UITextFieldDelegate {
    
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
