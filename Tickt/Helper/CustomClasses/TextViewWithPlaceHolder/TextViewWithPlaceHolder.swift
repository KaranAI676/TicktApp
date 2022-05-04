//
//  TextViewWithPlaceHolder.swift
//  Tickt
//
//  Created by Tickt on 12/07/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TextViewWithPlaceHolder: UITextView {
    
    //MARK:- Variables
    //=================
    @IBInspectable var placeholderTextColor: UIColor = UIColor.lightGray
    @IBInspectable var customPlaceholder: String = CommonStrings.emptyString
    
    override var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK:- LifeCycle
    //=================
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override func draw(_ rect: CGRect) {
        if text!.isEmpty && !self.customPlaceholder.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : font!,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : placeholderTextColor,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue)  : paragraphStyle]
            self.customPlaceholder.draw(in: placeholderRectForBounds(bounds: bounds), withAttributes: attributes)
        }
        super.draw(rect)
    }

    
    //MARK:- Functions
    //=================
    /// Method to setup ui
    private func setUp() {
        //        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.textChanged(notification:)),
                                               name: Notification.Name("UITextViewTextDidChangeNotification"),
                                               object: nil)
    }
    
    /// Method to return rect for placehoder text
    /// - Parameter bounds: text container bounds in CGRect
    /// - Returns: CGRect the final container rect
    private func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var x = contentInset.left
        var y = self.centerY - 9
        let w = frame.size.width - contentInset.left - contentInset.right
        let h: CGFloat = 18
        
        if let style = self.typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            x += style.headIndent
            y += style.firstLineHeadIndent
        }
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    //MARK:- Actions
    //===============
    @objc func textChanged(notification: NSNotification) {
        setNeedsDisplay()
    }
}


protocol PlaceholderTextViewDelegate: UITextViewDelegate {}

class PlaceholderTextView: UIView {
    
    // Accessors
    var text: String? {
        didSet {
            self.textView.text = text
            self.textViewDidChange(self.textView)
            self.updateHeight()
        }
    }

    var placeholderFont: UIFont? = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            self.placeholderLabel.font = placeholderFont
            self.updateHeight()
        }
    }
    override var tintColor: UIColor? {
        didSet {
            self.textView.tintColor = tintColor
            self.placeholderLabel.tintColor = tintColor
        }
    }
    var placeholder: String? {
        didSet {
            self.placeholderLabel.text = placeholder
        }
    }
    var placeholderTextColor: UIColor = UIColor.lightText  {
        didSet {
            self.placeholderLabel.textColor = placeholderTextColor
        }
    }
    var allowsNewLines: Bool = true
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.font = UIFont.kAppDefaultFontRegular(ofSize: 14)
        textView.textColor = UIColor.lightText
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.backgroundColor = .clear
        label.font = self.textView.font
        label.textColor = self.placeholderTextColor
        label.text = self.placeholder
        return label
    }()
    
    weak var delegate: PlaceholderTextViewDelegate?
    private var heightConstraint = NSLayoutConstraint()
    private var initialHeight: CGFloat = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.updateHeight(animated: false)
    }
    
    private func commonInit() {
        self.addSubview(self.textView)
        self.addSubview(self.placeholderLabel)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.textView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.placeholderLabel.fillSuperview(padding: UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16))
        self.initialHeight = self.bounds.height
        self.updateHeight(animated: false)
    }
    
    func initialSetUp(text: String, placeholder: String, heightConstraint: NSLayoutConstraint) {
        self.heightConstraint = heightConstraint
        self.heightConstraint.isActive = true
        self.initialHeight = heightConstraint.constant
        self.textView.text = text
        self.placeholderLabel.text = placeholder
        self.updateHeight(animated: false)
    }
        
    func updateHeight(animated: Bool = true) {
        let maxSize = CGSize(width: self.frame.size.width, height: .greatestFiniteMagnitude)
        let textViewSize = self.textView.sizeThatFits(maxSize)
        let maxHeight = ceil(CGFloat.maximum(textViewSize.height, self.initialHeight))
        self.heightConstraint.constant = max(maxHeight, self.initialHeight)
        IQKeyboardManager.shared.reloadLayoutIfNeeded()
        UIView.animate(withDuration: animated ? 0.33 : 0.0) {
            self.layoutIfNeeded()
        }
    }
    
    func setText(_ text: String, animated: Bool = true) {
        self.textView.text = text
        self.textViewDidChange(self.textView)
        self.updateHeight(animated: animated)
    }
}

extension PlaceholderTextView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let safeDelegate = self.delegate {
            return safeDelegate.textViewShouldBeginEditing?(textView) ?? true
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.placeholderLabel.alpha = self.textView.text.isEmpty ? 1 : 0
        self.updateHeight()
    }

    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textViewDidChange?(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let containsNewLines = text.rangeOfCharacter(from: .newlines)?.isEmpty == .some(false)
        guard !containsNewLines || self.allowsNewLines else { return false }
        return true
    }

}
