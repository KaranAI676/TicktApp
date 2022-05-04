//
//  CustomTextField.swift
//  Tickt
//
//  Created by S H U B H A M on 17/03/21.
//

import UIKit
import Foundation

protocol CustomTextViewDelegate: AnyObject {    
    func getPassword(password: String)
}

class CustomTextView: UITextView {
    
    //MARK:- Variables
    var textViewText: String = ""
    var placeHoldertext: String = "password"
    var isSecureEntry: Bool = true
    var rightViewHeight: CGFloat = 20
    var topPadding: CGFloat = 8
    weak var passDelegate: CustomTextViewDelegate? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        self.delegate = self
        self.setupTextView()
        self.setRightViewMode()
    }
    
    @objc private func buttonTapped(button: UIButton) {
        button.isSelected = !button.isSelected
        self.isSecureEntry = button.isSelected
        self.textViewDidChange(self)
    }
}

//MARK:- Private Methods
//======================
extension CustomTextView {
    
    private func setupTextView() {
        isScrollEnabled = true
        self.keyboardType = .asciiCapable
        self.textContainer.maximumNumberOfLines = 1
        self.contentInset.right = rightViewHeight
        self.contentInset.top = topPadding
        self.font = AppFonts.NeueHaasDisplayMediu.withSize(16)
        self.text = placeHoldertext
        self.textColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8588235294, alpha: 1)
    }
    
    private func setRightViewMode() {
        let button = UIButton(frame: CGRect(x: self.bounds.width - 20, y: ((self.bounds.height - rightViewHeight)/2) - topPadding, width: rightViewHeight, height: rightViewHeight))
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "closed"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "visibility1"), for: .normal)
        button.isSelected = self.isSecureEntry
        self.addSubview(button)
    }
}

//MARK:- UITextView Delegate
//==========================
extension CustomTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let text = textView.text {
            textView.text = text.byRemovingLeadingTrailingWhiteSpaces
            if text == placeHoldertext {
                textView.text = ""
                self.textColor = AppColors.themeBlue
            }else {
                textViewDidChange(textView)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            textView.text = text.byRemovingLeadingTrailingWhiteSpaces
            if text == "" {
                textView.text = placeHoldertext
                textView.font = AppFonts.NeueHaasDisplayMediu.withSize(16)
                textView.textColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8588235294, alpha: 1)
            }else {
                textViewDidChange(textView)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.isSecureEntry {
            self.attributedText = CommonFunctions.getTextWithImage(image: #imageLiteral(resourceName: "passwordTick"), font: AppFonts.NeueHaasDisplayBold.withSize(12), count: textViewText.count)
        }else {
            textView.text = textViewText
        }
        passDelegate?.getPassword(password: textViewText)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        guard let inputMode = textView.textInputMode else {
            return false
        }
        
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        
        if text.isEmpty {
            self.textViewText = (self.textViewText as NSString).replacingCharacters(in: range, with: "")
        }else {
            self.textViewText.append(contentsOf: text)
        }
        return true
    }
}
