//
//  UIButton+Addition.swift
//  Shift Vendor
//
//  Created by Vijay on 04/07/19.
//  Copyright © 2019 Vijay. All rights reserved.
//

import UIKit

class CustomRegularButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: size)
    }
}

class CustomInterRegularButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        titleLabel?.font = UIFont.kAppDefaultFontInterRegular(ofSize: size)
    }
}

class CustomRomanButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        titleLabel?.font = UIFont.kAppDefaultFontRoman(ofSize: size)
    }
}

class CustomMediumButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: size)
    }
}

class CustomBoldButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
        let size: CGFloat = CGFloat(tag == 0 ? 16 : tag)
        titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: size)
    }
}

extension UIButton {
//    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
//        super.addTarget(target, action: action, for: controlEvents)
//        DispatchQueue.delay(0.09) { [weak self] in
//            self?.isEnabled = false
//        }
//
//        DispatchQueue.delay(0.5) { [weak self] in
//            self?.isEnabled = true
//        }
//    }
        
}

class BookMarkButton: UIButton {
    
    enum LoaderStatus {
        case loading, notLoading
    }    
    
    //MARK:- Variables
    //================
    private var isSaved = false
    private var savedImage = UIImage.init(named: "bookmarkSelected")
    private var unSavedImage = UIImage.init(named: "ic_bookmark_unselected")
    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3
    private var loader: UIActivityIndicatorView?
    private var loaderFrame: CGRect = CGRect.zero
    var loaderStatus: LoaderStatus = .notLoading {
        didSet {
            self.activityLoaderAnimation()
        }
    }
    private var getCurrentImage: UIImage? {
        return self.isSaved ? self.savedImage : self.unSavedImage
    }
    
    //MARK:- Lifecycle
    //================
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:- Functions
    //================
    ///Methode for initial setups
    private func initialSetUp() {
        if #available(iOS 13.0, *) {
            self.activityLoaderOnButtonSetUp(loaderStyle: .medium)
        } else {
            self.activityLoaderOnButtonSetUp(loaderStyle: .gray)
        }
        self.setBookmarkState(isLiked: false)
    }
    
    /// Set Liked State of button
    /// - Parameter isLiked: Bool value for state
    func setBookmarkState(isLiked: Bool) {
        self.isSaved = isLiked
        self.setImageForAllMode(image: self.getCurrentImage)
        self.loaderStatus = .notLoading
    }
    
    ///Reverse Liked State of button
    func flipBookmarkState() {
        self.isSaved = !self.isSaved
        self.animate()
    }
    
    func updateSavedImage(img: UIImage) {
        self.savedImage = img
        self.setImageForAllMode(image: self.getCurrentImage)
    }
    
    func updateUnsavedImage(img: UIImage) {
        self.unSavedImage = img
        self.setImageForAllMode(image: self.getCurrentImage)
    }
    
    /// Forcely set in active state of button
    func setInactiveState() {
        self.isUserInteractionEnabled = false
        self.setImageForAllMode(image: self.getCurrentImage)
    }
    
    /// Forcely set active state of button
    func setActiveState() {
        self.isUserInteractionEnabled = true
    }    
    
    ///Methode to animate the button
    private func animate() {
        self.setImageForAllMode(image: self.getCurrentImage)
    }
    
    /// Method for activity loader setup
    /// - Parameters:
    ///   - loaderStyle: UIActivityIndicatorView Style for loader
    ///   - frame: CGRect for activity loader
    private func activityLoaderOnButtonSetUp(loaderStyle: UIActivityIndicatorView.Style) {
        self.loader = nil
        self.loaderFrame = self.bounds
        self.loader = UIActivityIndicatorView(frame: self.bounds)
        guard let loader = self.loader else { return }
        loader.color = AppColors.themeBlue
        loader.style = loaderStyle
        self.addSubview(loader)
        loader.isHidden = true
    }
    
    func updateLoaderFrame(frame: CGRect) {
        self.loaderFrame = frame
        self.loader?.frame = frame
    }
    
    /// Method to start activity loader animation
    private func startActivityLoader() {
        if let loader = self.loader, !loader.isAnimating {
            self.setTitleForAllMode(title: nil)
            self.setImageForAllMode(image: nil)
            loader.isHidden = false
            loader.startAnimating()
            self.isUserInteractionEnabled = false
        }
    }
    
    /// Method to stop activity loader animation
    /// - Parameters:
    ///   - title: String value of button title
    ///   - image: UIImage value for button
    private func stopActivityLoader() {
        self.setTitleForAllMode(title: nil)
        self.setImageForAllMode(image: self.getCurrentImage)
        self.loader?.stopAnimating()
        self.isUserInteractionEnabled = true
    }
    
    /// Method to start/stop activity loader animation
    /// - Parameters:
    ///   - title: String value of button title
    ///   - image: UIImage value for button
    private func activityLoaderAnimation() {
        switch self.loaderStatus {
        case .loading:
            self.startActivityLoader()
        case .notLoading:
            self.stopActivityLoader()
        }
    }
}

class LoaderButton: UIButton {
    
    enum LoaderStatus {
        case loading, notLoading
    }
    
    
    //MARK:- Variables
    //================
    private var loader: UIActivityIndicatorView?
    var loaderStatus: LoaderStatus = .notLoading {
        didSet {
            self.activityLoaderAnimation()
        }
    }
    private (set) var title: String? = nil
    private (set) var image: UIImage? = nil
    private var buttonCenter: CGPoint {
        let x = self.bounds.width/2
        let y = self.bounds.height/2
        return CGPoint(x: x, y: y)
    }
    
    //MARK:- Lifecycle
    //================
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loader?.center = self.buttonCenter
    }
    
    //MARK:- Functions
    //================
    ///Methode for initial setups
    private func initialSetUp() {
        if #available(iOS 13.0, *) {
            self.activityLoaderOnButtonSetUp(loaderStyle: .medium)
        } else {
            self.activityLoaderOnButtonSetUp(loaderStyle: .gray)
        }
        self.title = self.titleLabel?.text
        self.image = self.imageView?.image
    }
        
    /// Forcely set in active state of button
    func setInactiveState() {
        self.isUserInteractionEnabled = false
    }
    
    /// Forcely set active state of button
    func setActiveState() {
        self.isUserInteractionEnabled = true
    }
    
    /// Method for activity loader setup
    /// - Parameters:
    ///   - loaderStyle: UIActivityIndicatorView Style for loader
    ///   - frame: CGRect for activity loader
    private func activityLoaderOnButtonSetUp(loaderStyle: UIActivityIndicatorView.Style) {
        self.layoutIfNeeded()
        self.loader = nil
        let loaderWidth: CGFloat
        if #available(iOS 13.0, *) {
            loaderWidth = loaderStyle == .large ? 37: 20
        } else {
            loaderWidth = loaderStyle == .whiteLarge ? 37: 20
        }
        self.loader = UIActivityIndicatorView()
        self.loader?.size = CGSize.init(width: loaderWidth, height: loaderWidth)
        self.loader?.center = self.buttonCenter
        guard let loader = self.loader else { return }
        loader.color = AppColors.themeBlue
        loader.style = loaderStyle
        self.addSubview(loader)
        loader.isHidden = true
    }
    
    func updateLoaderFrame(frame: CGRect) {
        self.loader?.frame = frame
    }
    
    /// Method to start activity loader animation
    private func startActivityLoader() {
        if let loader = self.loader, !loader.isAnimating {
            self.setTitleForAllMode(title: nil)
            self.setImageForAllMode(image: nil)
            loader.isHidden = false
            loader.startAnimating()
            self.isUserInteractionEnabled = false
        }
    }
    
    /// Method to stop activity loader animation
    /// - Parameters:
    ///   - title: String value of button title
    ///   - image: UIImage value for button
    private func stopActivityLoader() {
        self.setTitleForAllMode(title: self.title)
        self.setImageForAllMode(image: self.image)
        self.loader?.stopAnimating()
        self.isUserInteractionEnabled = true
    }
    
    /// Method to start/stop activity loader animation
    /// - Parameters:
    ///   - title: String value of button title
    ///   - image: UIImage value for button
    private func activityLoaderAnimation() {
        switch self.loaderStatus {
        case .loading:
            self.startActivityLoader()
        case .notLoading:
            self.stopActivityLoader()
        }
    }
}

extension UIButton {
    
    /// Method to add right image with offset
    ///
    /// - Parameter image: UIImage to set in button image.
    /// - Parameter offset: CGFloat space beetwen image and title.
    func addRightImage(image: UIImage?, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
    
    /// Method to add left image on button
    ///
    /// - Parameter image: UIImage to set in button image.
    func adjustLeftImage(image: UIImage) {
        self.tintColor = .white
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: (self.center.x/4)-10, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .center
    }
        
    ///  Method to add shadow on button
    /// - Parameter cornerRadius: CGFloat corner radius to apply on view.
    /// - Parameter color: UIColor to set in button title color.
    /// - Parameter offset: CGSize shadow size.
    /// - Parameter opacity: Float opacity of radius.
    /// - Parameter shadowRadius: CGFloat radius of shadow.
    func addShadowOnButton(cornerRadius: CGFloat? = nil, color: UIColor = UIColor.gray, offset: CGSize = CGSize.init(width: 1.0, height: 1.0), opacity: Float = 1.0, shadowRadius: CGFloat = 7.0) {
        let _cornerRadius = cornerRadius.isNil ? self.frame.height/2 : (cornerRadius ?? CGFloat.zero)
        self.addShadow(cornerRadius: _cornerRadius, color: color, offset: offset, opacity: opacity, shadowRadius: shadowRadius)
    }
    
    /// Method to revere position Of the title and image
    ///
    func reverePositionOfTitleAndImage() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    /// Method to sets the styled title to use for the normal, highlighted and selected state.
    ///
    /// - Parameter title: NSAttributedString to set in button title.
    ///
    func setAttributedTitleAllMode(title: NSAttributedString?) {
        self.setAttributedTitle(title, for: .normal)
        self.setAttributedTitle(title, for: .highlighted)
        self.setAttributedTitle(title, for: .selected)
    }
    
    /// Method to sets the title to use for the normal, highlighted and selected state.
    ///
    /// - Parameter title: String to set in button title.
    ///
    func setTitleForAllMode(title: String?) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .selected)
        self.setTitle(title, for: .focused)
        self.setTitle(title, for: .application)
//        self.setTitle(title, for: .disabled)
    }
    
    /// Method to set the title color to use for the normal, highlighted and selected state
    ///
    /// - Parameter color: UIColor to set in button title color.
    ///
    func setTitleColorForAllMode(color: UIColor?) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .focused)
        self.setTitleColor(color, for: .application)
//        self.setTitleColor(color, for: .disabled)
    }
    
    /// Method to set the image to use for the normal, highlighted and selected state.
    ///
    /// - Parameter image: UIImage to set in button image.
    ///
    func setImageForAllMode(image: UIImage?) {
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.setImage(image, for: .selected)
        self.setImage(image, for: .focused)
        self.setImage(image, for: .application)
//        self.setImage(image, for: .disabled)
    }
    
    func setFont(_ font: UIFont) {
        self.titleLabel?.font = font
    }
}
