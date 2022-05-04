//
//  AppSearchBar.swift
//  Tickt
//
//  Created by Tickt on 05/08/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

//MARK:- AppSearchBar
//===================
class AppSearchBar: UISearchBar {
    
    enum SearchBarType {
        case home
        case address
        case imageWithPlaceholder
    }
    
    //MARK:- Variables
    //================
    var searchBarType: SearchBarType = .address {
        didSet {
            self.searchBarSetUp()
        }
    }
    
    private var placeholderText: String = " "
    
    private var activityIndicator: UIActivityIndicatorView? {
        return self.textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return self.activityIndicator != nil
        } set {
            if newValue {
                self.setSearchIconAndTextPosition(isHidden: false)
                if self.activityIndicator.isNil {
                    let newActivityIndicator: UIActivityIndicatorView
                    if #available(iOS 13.0, *) {
                        newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    } else {
                        newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    }
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.color = AppColors.themeBlue
                    newActivityIndicator.tintColor = AppColors.themeBlue
                    newActivityIndicator.backgroundColor = UIColor.lightGray
                    self.textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = self.textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    //MARK:- Lifecycle
    //================
    override init(frame:CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
        
    //MARK:- Functions
    //================
    ///Mthod Hide Show Search Bar Loader
    func hideShowSearchBarLoader(isHidden: Bool) {
        self.setSearchIconAndTextPosition(isHidden: self.searchBarType == .address)
        self.isLoading = !isHidden
    }
        
    /// Searchbar setup
    private func setup() {
        self.customizeSearchField(height: self.bounds.height, radius: 12)
        // Color of the text field
        self.barTintColor = UIColor.white
        self.textField?.clearButtonMode = .whileEditing
        self.textField?.font = UIFont.kAppDefaultFontRegular(ofSize: 14)
        self.textField?.textColor = UIColor.lightText
        self.textField?.backgroundColor = UIColor.lightText
        // Color of the cursor (you don't need to change this if you want to stay with the default blue)
        self.tintColor = UIColor.lightText
        // Background color of you search bar
        self.backgroundImage = UIImage()
        self.barStyle = .default
        self.backgroundColor = UIColor.lightText
        self.setImage(UIImage(), for: .search, state: .normal)
        self.setImage(#imageLiteral(resourceName: "cross"), for: .clear, state: .normal)
    }
    
    private func searchBarSetUp() {
        switch self.searchBarType {
        case .home:
            self.setImage(#imageLiteral(resourceName: "Search"), for: .search, state: .normal)
            self.setPositionAdjustment(UIOffset(horizontal: 20, vertical: 0), for: .search)
            self.attributedPlaceholderSetUp(placeholderText: LS.whatDoYouWantToDo)
        case .address:
            self.attributedPlaceholderSetUp(placeholderText: LS.searchHere)
        case .imageWithPlaceholder:
            self.setImage(#imageLiteral(resourceName: "Search"), for: .search, state: .normal)
            self.setPositionAdjustment(UIOffset(horizontal: 20, vertical: 0), for: .search)
            self.attributedPlaceholderSetUp(placeholderText: self.placeholderText)
        }
        self.setNeedsDisplay()
    }
    
    func setPlaceholderText(placeholderText: String) {
        self.placeholderText = placeholderText
        self.searchBarSetUp()
    }
    
    private func customizeSearchField(height: CGFloat, radius: CGFloat) {
        UISearchBar.appearance().setSearchFieldBackgroundImage(UIImage(), for: .normal)
        guard self.textField.isNotNil else { return }
        self.textField!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textField!.heightAnchor.constraint(equalToConstant: height),
            self.textField!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.textField!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.textField!.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        ])
        self.textField!.cropCorner(radius: radius)
        self.cropCorner(radius: radius)
    }
        
    private func setSearchIconAndTextPosition(isHidden: Bool) {
        self.searchTextPositionAdjustment = UIOffset(horizontal: !isHidden ? 9 : 0, vertical: 0)
        self.setPositionAdjustment(UIOffset(horizontal: !isHidden ? 16 : 0, vertical: 0), for: .search)
    }
    
    private func attributedPlaceholderSetUp(placeholderText: String) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            switch self.searchBarType {
            case .home, .imageWithPlaceholder:
                self.searchTextPositionAdjustment = UIOffset(horizontal: 6, vertical: 0)
                self.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
            case .address:
                break
            }
            let attributedString = NSMutableAttributedString(string: placeholderText, attributes: [.font: UIFont.kAppDefaultFontRegular(ofSize: 14), .foregroundColor: UIColor.lightText])
            self.textField?.attributedPlaceholder = attributedString
        }
    }
}
