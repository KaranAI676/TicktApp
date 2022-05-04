//
//  Photo+TextField.swift
//  Tickt
//
//  Created by Vijay's Macbook on 07/06/21.
//

import Foundation

extension PhotoVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.count <= 200 {
            countLabel.text = "\(currentText.count)/200"
        }
        return updatedText.count <= 200
    }
}
