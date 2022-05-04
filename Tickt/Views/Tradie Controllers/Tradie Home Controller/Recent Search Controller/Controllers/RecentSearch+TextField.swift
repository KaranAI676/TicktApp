//
//  RecentSearch+TextField.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit
import Foundation

extension RecentSearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if !updatedText.isEmpty {
                widthConstraint.constant = 0
                searchImage.isHidden = true
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
                viewModel.getSearchedJobs(searchText: updatedText.replace(string: " ", withString: "%20"))
                isSearchEnabled = true
                return true
            } else {
                searchImage.isHidden = false
                widthConstraint.constant = 30
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
                isSearchEnabled = false
                mainQueue { [weak self] in
                    self?.searchTableView.reloadData()
                }
                return true
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
