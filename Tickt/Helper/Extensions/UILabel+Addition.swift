//
//  UILabel+Addition.swift
//  Shift Vendor
//
//  Created by Vijay on 04/07/19.
//  Copyright © 2019 Vijay. All rights reserved.
//

import UIKit

class CustomRegularLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontRegular(ofSize: size)
    }
}

class CustomRomanLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontRoman(ofSize: size)
    }
}

class CustomInterRegularLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontInterRegular(ofSize: size)
    }
}

class CustomMediumLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
}


class CustomBoldLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        font = UIFont.kAppDefaultFontBold(ofSize: size)
    }
}

@IBDesignable class InsetLabel: UILabel {

    // MARK: Variables
    //=================
    @IBInspectable var setTopInset: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var setBottomInset: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var setLeftInset: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var setRightInset: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    // MARK: Lifecycle
    //================
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: setTopInset, left: setLeftInset, bottom: setBottomInset, right: setRightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += setTopInset + setBottomInset
        intrinsicSuperViewContentSize.width += setLeftInset + setRightInset
        return intrinsicSuperViewContentSize
    }

    // MARK: Functions
    //================
    /// Method to set edge insets
    /// - Parameters:
    ///   - topInset: CGFloat value for top insets
    ///   - bottomInset: CGFloat value for bottom insets
    ///   - leftInset: CGFloat value for left insets
    ///   - rightInset: CGFloat value for right insets
    func edgeInsets(topInset: CGFloat, bottomInset: CGFloat, leftInset: CGFloat, rightInset: CGFloat) {
        setTopInset = topInset
        setBottomInset = bottomInset
        setLeftInset = leftInset
        setRightInset = rightInset
        self.setNeedsDisplay()
    }
}
