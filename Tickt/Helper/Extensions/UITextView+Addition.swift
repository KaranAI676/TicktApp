//
//  UITextView+Addition.swift
//  Shift Vendor
//
//  Created by Vijay on 15/07/19.
//  Copyright © 2019 Vijay. All rights reserved.
//

import UIKit

extension UITextView {
    @IBInspectable var doneAccessory: Bool {
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

class CustomBoldTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontBold(ofSize: size)
    }
}

class CustomRegularTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontRegular(ofSize: size)
    }
}

class CustomRomanTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontRoman(ofSize: size)
    }
}

class CustomInterRegularTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontInterRegular(ofSize: size)
    }
}

class CustomMediumTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
}
