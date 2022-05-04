//
//  UITextViewExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

public extension UITextView {

    func applyLeftPadding(padding: Int) {
        textContainerInset = UIEdgeInsets(top: 10, left: CGFloat(padding), bottom: 8, right: 8)
    }
    
    func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }
    
    func scrollToTop() {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
         
    func validate() -> Bool {
        guard let text =  self.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }
}
