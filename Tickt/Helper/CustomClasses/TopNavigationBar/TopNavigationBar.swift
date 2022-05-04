//
//  TopNavigationBar.swift
//  Tickt
//
//  Created by Tickt on 28/07/20.
//  Copyright © 2020 Tickt. All rights reserved.
//
import UIKit

protocol TopNavigationBarDelegate: AnyObject {
    func didPressNavigationItem(item: TopNavigationBar.NavigationItem)
}

extension TopNavigationBarDelegate {
    func didPressNavigationItem(item: TopNavigationBar.NavigationItem) {}
}

class TopNavigationBar: UIView {
    
    enum NavigationType {
        case backButton
        case backButtonWithTitle
        case leftRightButton
        case leftRightButtonWithTitle
        case rightSearchBar
        case leftSearchBar
        case home
        case largeTitle
    }
    
    enum NavigationItem {
        case leftButton
        case rightButton
        case centreImage
        case secondRightButton
    }
    
    enum SearchBarAction {
        case didPress, didBegain, didEnd, shouldChangeText
    }
    
    //MARK:- Variables
    //================
    internal weak var delegate: TopNavigationBarDelegate?
    private var navigationType: NavigationType = .backButton
    var searchBarAction: ((_ actionType: SearchBarAction, _ searchKey: String) -> Void)? = nil
    var shouldSearchBarRedirectToNewScreen: Bool = false
    var searchBarActiveCallback: Bool = false
    var useDebounceSearching: Bool = true
    private lazy var debouncer = Debouncer(timeInterval: 0.6)
    
    //MARK:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemsContainerView: UIView!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var leftButtonContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButtonOutlet: UIButton!
    @IBOutlet weak var leftButtonHeightCons: NSLayoutConstraint!
    @IBOutlet weak var rightButtonContainerView: UIView!
    @IBOutlet weak var rightButtonOutlet: UIButton!
    @IBOutlet weak var rightButtonHeightCons: NSLayoutConstraint!
    @IBOutlet weak var rightButtonWidthCons: NSLayoutConstraint!
    @IBOutlet weak var searchBar: AppSearchBar!
    
    //LargeTitle
    @IBOutlet weak var largeTitleContainerView: UIView!
    @IBOutlet weak var largeTitleLable: UILabel!
    
    //MARK:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    //MARK:- Functions
    //================
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopNavigationBar", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.backgroundColor = .clear
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.initialSetUps()
    }
    
    private func initialSetUps() {
        if kUserDefaults.getAccessToken().isEmpty {
            let height = (45/812)*UIDevice.height > 40 ? 40 : (45/812)*UIDevice.height
            self.leftButtonHeightCons.constant = height
            self.rightButtonHeightCons.constant = height
        }
        self.containerView.backgroundColor = .clear
        //Temp Changes //HomeController
        self.searchBar.isHidden = (self.delegate as? UIViewController).isNil
        self.rightButtonContainerView.isHidden = true
        self.titleLabel.isHidden = true
        self.largeTitleContainerView.isHidden = true
    }
    
    func configureUI(imageUrl: String = CommonStrings.emptyString, title: String = CommonStrings.emptyString, leftButtonImage: UIImage? = #imageLiteral(resourceName: "backIcon") ,rightButtonImage: UIImage? = nil, rightButtonTitle: String? = nil, navigationType: NavigationType, delegate: TopNavigationBarDelegate?) {
        self.navigationType = navigationType
        self.delegate = delegate
        switch navigationType {
        case .backButton:
            self.configBackButtonNavUI(image: leftButtonImage)
        case .rightSearchBar:
            self.configRightSearchBarNavUI(image: leftButtonImage)
        case .leftRightButton:
            self.configLeftRightButtonNavUI(leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, rightButtonTitle: rightButtonTitle)
        case .leftRightButtonWithTitle:
            self.configLeftRightButtonWithTitleNavUI(title: title, leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, rightButtonTitle: rightButtonTitle)
        case .backButtonWithTitle:
            self.configBackButtonWithTitle(title: title, leftButtonImage: leftButtonImage)
        case .leftSearchBar:
            self.configLeftSearchBarNavUI(image: rightButtonImage)
        case .home:
            self.configHomeSearchBarNavUI(image: #imageLiteral(resourceName: "notificationWithWhiteBackground"))
        case .largeTitle:
            self.configLargeTitle(title: title)
        }
    }
    
    private func configBackButtonNavUI(image: UIImage?) {
        self.rightButtonContainerView.isHidden = true
        self.searchBar.isHidden = true
        self.leftButtonOutlet.setImageForAllMode(image: image)
    }
    
    private func configLeftRightButtonNavUI(leftButtonImage: UIImage? = #imageLiteral(resourceName: "backIcon") ,rightButtonImage: UIImage?, rightButtonTitle: String?) {
        self.rightButtonContainerView.isHidden = false
        self.searchBar.isHidden = true
        self.leftButtonOutlet.setImageForAllMode(image: leftButtonImage)
        self.rightButtonOutlet.setImageForAllMode(image: rightButtonImage)
        self.rightButtonOutlet.setTitleForAllMode(title: rightButtonTitle)
        if rightButtonImage.isNil {
            self.rightButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            self.rightButtonOutlet.contentHorizontalAlignment = .right
        }
    }
    
    private func configLeftRightButtonWithTitleNavUI(title: String, leftButtonImage: UIImage? = #imageLiteral(resourceName: "backIcon") ,rightButtonImage: UIImage?, rightButtonTitle: String?) {
        self.rightButtonContainerView.isHidden = false
        self.searchBar.isHidden = true
        self.leftButtonOutlet.setImageForAllMode(image: leftButtonImage)
        self.rightButtonOutlet.setImageForAllMode(image: rightButtonImage)
        self.rightButtonOutlet.setTitleForAllMode(title: rightButtonTitle)
        if rightButtonImage.isNil {
            self.rightButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            self.rightButtonOutlet.contentHorizontalAlignment = .right
        }
        self.titleLabel.isHidden = false
        self.titleLabel.text = title
    }
    
    private func configRightSearchBarNavUI(image: UIImage?) {
        self.rightButtonContainerView.isHidden = true
        self.searchBar.isHidden = false
        self.searchBar.delegate = self
        self.hideShowSearchBarLoader(isHidden: true)
        self.leftButtonOutlet.setImageForAllMode(image: image)
    }
    
    private func configLeftSearchBarNavUI(image: UIImage?) {
        self.rightButtonContainerView.isHidden = false
        self.leftButtonContainerView.isHidden = true
        self.searchBar.isHidden = false
        self.searchBar.delegate = self
        self.hideShowSearchBarLoader(isHidden: true)
        self.leftButtonOutlet.setImageForAllMode(image: image)
    }

    private func configHomeSearchBarNavUI(image: UIImage?) {
        self.rightButtonContainerView.isHidden = false
        self.leftButtonContainerView.isHidden = true
        self.searchBar.isHidden = false
        self.searchBar.searchBarType = .home
        self.searchBar.delegate = self
        self.hideShowSearchBarLoader(isHidden: true)
        self.rightButtonOutlet.setImageForAllMode(image: image)
    }
    
    private func configBackButtonWithTitle(title: String, leftButtonImage: UIImage?) {
        self.configBackButtonNavUI(image: leftButtonImage)
        self.titleLabel.isHidden = false
        self.titleLabel.text = title
    }
    
    private func configLargeTitle(title: String) {
        self.itemsContainerView.isHidden = true
        self.largeTitleContainerView.isHidden = false
        self.largeTitleLable.text = title
    }
    
    ///Mthod Hide Show Search Bar Loader
    func hideShowSearchBarLoader(isHidden: Bool) {
        self.searchBar.hideShowSearchBarLoader(isHidden: isHidden)
    }
    
    func addTextToSearchBar(_ text: String) {
        self.searchBar.text = text
        self.searchBarAction?(.shouldChangeText, text)
    }
        
    //MARK:- IBActions
    //================
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case self.leftButtonOutlet:
            self.delegate?.didPressNavigationItem(item: .leftButton)
        case self.rightButtonOutlet:
            self.delegate?.didPressNavigationItem(item: .rightButton)
        default:
            return
        }
    }
}

//MARK:- UISearchBarDelegate
//MARK:=====================
extension TopNavigationBar: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if self.shouldSearchBarRedirectToNewScreen || self.searchBarActiveCallback {
            self.searchBarAction?(.didPress, searchBar.text ?? "")
        }
        return !self.shouldSearchBarRedirectToNewScreen
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarAction?(.didBegain, searchBar.text ?? "")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarAction?(.didEnd, searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !text.canBeConverted(to: String.Encoding.ascii) || text.containsEmoji() {
            return false
        }
        
        let currentText = searchBar.text ?? CommonStrings.emptyString
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let finalText = currentText.replacingCharacters(in: stringRange, with: text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if finalText.isEmpty || finalText == CommonStrings.whiteSpace || finalText == CommonStrings.dot {
            return false
        }
        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let finalText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        self.searchBarAction?(.shouldChangeText, finalText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !self.useDebounceSearching {
            self.searchBarAction?(.shouldChangeText, searchText)
            return
        }
        self.debouncer.startTimer()
        self.debouncer.completion = { [weak self] in
            guard self.isNotNil else { return }
            self!.searchBarAction?(.shouldChangeText ,searchText)
        }
    }
}
