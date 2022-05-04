//
//  UITextFieldExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import UIKit

extension UITextField {
    
    ///Sets and gets if the textfield has secure text entry
    var isSecureText:Bool {
        get{
            return self.isSecureTextEntry
        }
        set{
            let font = self.font
            self.isSecureTextEntry = newValue
            if let text = self.text{
                self.text = ""
                self.text = text
            }
            self.font = nil
            self.font = font
            self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        }
    }
    
    // STOP SPECIAL CHARACTERS
    //===========================
    func stopSpecialCharacters() {
        let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@"
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = (text!.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        
        if text != filtered {
            text?.removeLast()
        }
    }
    
    // SET IMAGE TO LEFT VIEW
    //=========================
    func setImageToLeftView(img : UIImage, size: CGSize?) {
        
        self.leftViewMode = .always
        let leftImage = UIImageView(image: img)
        self.leftView = leftImage
        
        leftImage.contentMode = UIView.ContentMode.center
        if let imgSize = size {
            self.leftView?.frame.size = imgSize
        } else {
            self.leftView?.frame.size = CGSize(width: 50, height: self.frame.height)
        }
        leftImage.frame = self.leftView!.frame
    }
    
    // SET IMAGE TO RIGHT VIEW
    //=========================
    func setImageToRightView(img : UIImage, size: CGSize?) {
        
        self.rightViewMode = .always
        let rightImage = UIImageView(image: img)
        self.rightView = rightImage
        
        rightImage.contentMode = UIView.ContentMode.center
        if let imgSize = size {
            self.rightView?.frame.size = imgSize
        } else {
            self.rightView?.frame.size = CGSize(width: 20, height: self.frame.height)
        }
        rightImage.frame = self.rightView!.frame
    }
    
    // SET BUTTON TO RIGHT VIEW
    //=========================
    func setButtonToRightView(btn : UIButton, selectedImage : UIImage?, normalImage : UIImage?, size: CGSize?, mode: UITextField.ViewMode = UITextField.ViewMode.always) {
        
        self.rightViewMode = .always
        self.rightView = btn
        
        btn.isSelected = false
        
        if let selectedImg = selectedImage { btn.setImage(selectedImg, for: .selected) }
        if let unselectedImg = normalImage { btn.setImage(unselectedImg, for: .normal) }
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: btn.intrinsicContentSize.width+10, height: 40)
			self.rightView?.frame.origin.y = 0
//            self.rightView?.frame = CGRect(x: 100, y: 100, width: btn.intrinsicContentSize.width+10, height: 40)

        }
    }
    
    // SET VIEW TO RIGHT VIEW
    //=========================
    func setViewToRightView(view : UIView, size: CGSize?) {
        
        self.rightViewMode = .always
        self.rightView = view
        
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: view.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }
    
    /// CREATE DATE PICKER
    //=========================
    func createDatePicker(start: Date?, end: Date?, current: Date, didSelectDate: @escaping ((Date) -> Void)) {
        var datePicker = UIDatePicker()
        
        // DatePicker
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: UIDevice.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.minimumDate = start
        datePicker.maximumDate = end
        datePicker.setDate(current, animated: false)
        self.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain) { (_) in
            
            self.text = datePicker.date.toString(dateFormat: "MM-dd-yyyy")
//            toString(dateFormat: )
            self.resignFirstResponder()
            
            didSelectDate(datePicker.date)
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain) { (_) in
            self.resignFirstResponder()
        }
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    func setupPasswordTextField() {
        self.keyboardType = .asciiCapable
        self.isSecureTextEntry = self.isSecureText
        
        let showButton = UIButton()
        showButton.addTarget(self, action: #selector(self.showButtonTapped(_:)), for: .touchUpInside)
        self.setButtonToRightView(btn: showButton, selectedImage: #imageLiteral(resourceName: "visibility1"), normalImage: #imageLiteral(resourceName: "closed"), size: CGSize(width: 20, height: 15), mode: .always)
    }
    
    func setupNormalTextField() {
        self.keyboardType = .asciiCapable
    }
    
    /// Show Button Tapped
    @objc private func showButtonTapped(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.isSecureText = !self.isSecureText
    }
    
    func setupTextField() {
        self.autocapitalizationType = .words
    }
}

//MARK:- Time Picker
//==================
extension UITextField {
    
    enum TimeFormat: String {
        case _24 = "en_GB"
        case _12 = "en_US"
    }
    
    //MARK:-CREATE TIME PICKER
    //=========================
    func createTimePicker(timeFormat: TimeFormat = ._12, didSelectDate: @escaping ((String, Int64) -> Void)) {
        
        var datePicker = UIDatePicker()
        // DatePicker
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: UIDevice.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.time
        let locale = timeFormat == ._12 ? TimeFormat._12.rawValue : TimeFormat._24.rawValue
        datePicker.locale = NSLocale(localeIdentifier: locale) as Locale
        self.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain) { (_) in
            self.text = datePicker.date.toString(dateFormat: Date.DateFormat.hhmm.rawValue)
            self.resignFirstResponder()
            
            let dateFormat = timeFormat == ._12 ? Date.DateFormat.hhmma.rawValue : Date.DateFormat.hhmm.rawValue
            didSelectDate(datePicker.date.toString(dateFormat: dateFormat), datePicker.date.toTimeStampInt64)
        }

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain) { (_) in
            self.resignFirstResponder()
        }
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


//MARK:- Create DATE AND TIME PICKER
//==================================
extension UITextField {
    
    //MARK:-CREATE DATE AND TIME PICKER
    //=========================
    func createDateTimePicker(start: Date?, end: Date?, current: Date, didSelectDate: @escaping ((Date) -> Void)) {
        
        var datePicker = UIDatePicker()
        // DatePicker
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: UIDevice.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = start
        datePicker.maximumDate = end
        datePicker.setDate(current, animated: false)
        self.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain) { (_) in
            
//            self.text = datePicker.date.toString(dateFormat: Date.DateFormat.EEEMMMhhmm.rawValue)
            self.resignFirstResponder()
            didSelectDate(datePicker.date)
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain) { (_) in
            self.resignFirstResponder()
        }
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}

private var maxLengths = [UITextField: Int]()
extension UITextField {
    //MARK:- Maximum length
        @IBInspectable var maxLength: Int {
            get {
                guard let length = maxLengths[self] else {
                    return 100
                }
                return length
            }
            set {
                maxLengths[self] = newValue
                addTarget(self, action: #selector(fixMax), for: .editingChanged)
            }
        }
        @objc func fixMax(textField: UITextField) {
            let text = textField.text
            textField.text = text?.safelyLimitedTo(length: maxLength)
        }
}


extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func safelyLimitedFrom(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

