//
//  UISearchBar+Extension.swift
//  Tickt
//
//  Created by Admin on 23/03/21.
//

import UIKit
import Foundation

extension UISearchBar {

    func removeSearchIcon() {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.leftView = nil
        sc.leftViewMode = .never
    }

    func setTextFieldFont(font: UIFont) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else {return}
        textFieldInsideSearchBar.font = font
    }

    func setTextFieldTextColor(color: UIColor) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else {return}
        textFieldInsideSearchBar.textColor = color
    }
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }

    func setTextFieldBackgroundColor(color: UIColor) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else {return}
        textFieldInsideSearchBar.backgroundColor = color
    }
}

extension UIImage {
    static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }    
}

extension UISearchBar {
    func setSearchTextField(height: CGFloat, radius: CGFloat = 12.0) {
        let image = UIImage.getImageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        if #available(iOS 13.0, *) {
            self.searchTextField.layer.cornerRadius = radius
            self.searchTextField.clipsToBounds = true
        } else {
            if let textField = self.textField {
                textField.layer.cornerRadius = radius
                textField.clipsToBounds = true
            }
        }
    }
}

extension UISearchBar {
    var textField: UITextField? {
        func findInView(_ view: UIView) -> UITextField? {
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    return textField
                }
                else if let v = findInView(subview) {
                    return v
                }
            }
            return nil
        }
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        else {
            return findInView(self)
        }
    }
}


extension UISearchBar {
    
    func setText(color: UIColor) { if let textField = self.getTextField() { textField.textColor = color } }
    func setPlaceholderText(color: UIColor) { self.getTextField()?.setPlaceholderText(color: color) }
    func setClearButton(color: UIColor) { self.getTextField()?.setClearButton(color: color) }
    
    func setTextField(color: UIColor) {
        guard let textField = self.getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    
    func setAttributedPlaceholderText(placeHolderText: String = "Search" ,color: UIColor = UIColor.lightText, font: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 17)) {
        guard let textField = self.getTextField() else { return }
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.font: font,.foregroundColor: color])
    }

    
    func setSearchImage(color: UIColor, searchIcon: UIImage? = nil) {
        guard let imageView = self.getTextField()?.leftView as? UIImageView else { return }
        if let image = searchIcon {
//            imageView.tintColor = color
            imageView.size = CGSize(width: 32.0, height: 32.0)
            imageView.image = image
        } else {
            imageView.tintColor = color
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func changeFrameOfTecxtField(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let textfield = self.getTextField()
        textfield?.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
