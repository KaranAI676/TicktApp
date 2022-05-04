//
//  UITextField+Addition.swift
//  Shift Vendor
//
//  Created by Vijay on 15/07/19.
//  Copyright © 2019 Vijay. All rights reserved.
//

import UIKit

extension Bool {
    var negated: Bool { !self }
}

extension StringProtocol {
    func separate(every stride: Int = 4, from start: Int = 0, with separator: Character = " ") -> String {
        .init(enumerated().flatMap { $0 != 0 && ($0 == start || $0 % stride == start) ? [separator, $1] : [$1]})
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, from start: Int = 0, every n: Int) {
        var distance = count
        for index in indices.dropFirst(start).reversed() {
            distance -= 1
            guard distance % n == start && index != startIndex else { continue }
            insert(contentsOf: separator, at: index)
        }
    }
}

class CustomPhoneField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
    
    override func didMoveToWindow() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        text?.removeAll{ !("0"..."9" ~= $0 || $0 == "+") }
        text?.insert(separator: " ", from: 0, every: 3)
        print(text ?? "")
    }
}

class CustomBsbField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        textColor = AppColors.themeBlue
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
    
    override func didMoveToWindow() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        text?.removeAll{ !("0"..."9" ~= $0 || $0 == "+") }
        text?.insert(separator: "-", from: 0, every: 3)
        print(text ?? "")
    }
}


class CustomABNField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
    
    override func didMoveToWindow() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        text?.removeAll{ !("0"..."9" ~= $0 || $0 == "+") }
        text?.insert(separator: " ", from: 2, every: 3)
        print(text ?? "")
    }
}

class CustomCardNumnberField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
    
    override func didMoveToWindow() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        text?.removeAll{ !("0"..."9" ~= $0 || $0 == "+") }
        text?.insert(separator: " ", from: 3, every: 4)
        print(text ?? "")
    }
}

class CustomBoldField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontBold(ofSize: size)
    }
}


class CustomRegularField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontRegular(ofSize: size)
    }
}


class CustomMediumField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
}

class CustomRomanField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontRoman(ofSize: size)
    }
}

class CustomInterRegularField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontInterRegular(ofSize: size)
    }
}


extension UITextField {
    
    func setAttributedPlaceholder(placeholderText: String, font: UIFont, color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                   attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
    }
    
    func applyLeftPadding(padding: Int) {
        let paddingView = UIView.init(frame: CGRect(x: 0,y:0,width: padding,height: Int(self.frame.size.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setLeftImage(imageName: String, width: CGFloat = 25) {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        leftImage.clipsToBounds = true
        containerView.addSubview(leftImage)
        leftImage.image = UIImage(named: imageName)
        leftImage.contentMode = .center
        leftImage.center = containerView.center
        leftViewMode = .always
        leftView = containerView
    }
    
    func setRightImage(imageName: String, width: CGFloat = 25) {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        rightImage.clipsToBounds = true
        rightImage.image = UIImage(named: imageName)
        rightImage.contentMode = .center
        containerView.addSubview(rightImage)
        rightImage.center = containerView.center
        rightViewMode = .always
        rightView = containerView
    }
    
    @IBInspectable var doneAccessory: Bool {
        get {
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
        inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        resignFirstResponder()
    }
}
