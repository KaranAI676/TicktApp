//
//  AppTutorialView.swift
//  Tickt
//
//  Created by Tickt on 17/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

class AppTutorialView: UIView {
    
    enum TutorialActions {
        case previousPage
        case nextPage
        case skip
    }
    
    //MARK:- Variables
    //MARK:===========
    var tutorialData: (index: UInt, titles: [String]) = (1,[])
    var tutorialActions: ((TutorialActions) -> Void)? = nil
    var navBarContainerFrame: CGRect = CGRect.zero
    var navBarBellIconSize: CGSize = CGSize.zero
    private var floatingArrow: UIImageView?
    private var floatingLabel: UILabel?
    private var floatingStackView: UIStackView?
    private var floatingSkipButton: SkipButtonView?
    private var floatingStackViewHeightAnchor: NSLayoutConstraint?
    private var floatingArrowLeadingAnchor: NSLayoutConstraint?
    private var floatingArrowBottomAnchor: NSLayoutConstraint?
    private var floatingStackViewBottomAnchor: NSLayoutConstraint?
    private var floatingImgView: UIImageView?
    private var floatingImgViewWidth: CGFloat = 0.0
    private var bottomStackView: UIStackView?
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                        UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor]
        layer.locations = [0.11, 0.9]
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.31, b: 1.31, c: -1.31, d: 0.07, tx: 0.94, ty: -0.18))
        if !self.gradientView.isNil {
            layer.bounds = self.gradientView.bounds.insetBy(dx: -0.5*self.gradientView.bounds.size.width, dy: -0.5*self.gradientView.bounds.size.height)
            layer.position = self.gradientView.center
        }
        return layer
    }()
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var gradientView: UIView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        //#imageLiteral(resourceName: "profileCircularSelected")
        self.tutorialData.titles = [LS.addItemsAndStartEarnMoney,
                                    LS.hereWillBeAllYourBookings,
                                    LS.welcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime,
                                    LS.hereIsThePalceToChatWithOthers,
                                    LS.yourProfile,
                                    LS.checkNotificationsAndAlweysStayUpdated]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(self.gradientView == nil) {
            self.gradientLayer.bounds = self.gradientView.bounds.insetBy(dx: -0.5*self.gradientView.bounds.size.width, dy: -0.5*self.gradientView.bounds.size.height)
            self.gradientLayer.position = self.gradientView.center
        }
    }
    
    //MARK:- Functions
    //MARK:===========
    func initialSetUp() {
        if let firstIndex = self.tutorialData.titles.firstIndex(of: LS.welcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime) {
            self.tutorialData.titles[firstIndex] = LS.hi + " " + kUserDefaults.getUsername() + "," + " " + LS.welcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime
        }
        self.gradientView.backgroundColor = .clear
        self.bottomStackViewSetUp()
        self.floatingArrowSetUp()
        self.floatingStackViewSetUp()
        self.floatingImgViewSetUp()
        self.floatingSkipButtonSetUp()
        self.showTutorialPage(isLeftSide: true)
        self.addGestures(self.gradientView)
    }
    
    private func showGradient(fromTop: Bool) {
        self.gradientLayer.removeFromSuperlayer()
        if fromTop {
            self.gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        }
        else {
            self.gradientLayer.startPoint = CGPoint(x: 0.75, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.25, y: 0.5)
        }
        self.gradientView.layer.addSublayer(self.gradientLayer)
    }
    
    private func addGestures(_ view: UIView) {
        // for previous and next navigation
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tapGest)
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    private func bottomStackViewSetUp() {
        self.bottomStackView = UIStackView()
        guard let stkVw = self.bottomStackView else { return }
        stkVw.isUserInteractionEnabled = false
        stkVw.spacing = 0
        stkVw.axis = .horizontal
        stkVw.alignment = .fill
        stkVw.distribution = .fill
        stkVw.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stkVw)
        
//        let tabBarfirstItemHeight = Router.shared.tabbar?.getFrameForTabAt(index: 0)?.height ?? 48.0
//        let tabBarfirstItemHeight = 48.0
        stkVw.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stkVw.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stkVw.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        stkVw.heightAnchor.constraint(equalToConstant: tabBarfirstItemHeight).isActive = true
        stkVw.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
//        let tabBarHeight = Router.shared.tabbar?.frame.height ?? 49.0
//        stkVw.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        
        let firstView = TutorialCircularView(frame: CGRect.zero, image: #imageLiteral(resourceName: "itemsCircularUnselected"))
        firstView.alpha = 0.0
        stkVw.addArrangedSubview(firstView)
        firstView.heightAnchor.constraint(equalTo: stkVw.heightAnchor, multiplier: 1.0).isActive = true
        firstView.widthAnchor.constraint(equalTo: stkVw.widthAnchor, multiplier: 0.2).isActive = true

        let secondView = TutorialCircularView(frame: CGRect.zero, image: #imageLiteral(resourceName: "bookingsCircularUnselected"))
        secondView.alpha = 0.0
        stkVw.addArrangedSubview(secondView)
        secondView.heightAnchor.constraint(equalTo: stkVw.heightAnchor, multiplier: 1.0).isActive = true
        secondView.widthAnchor.constraint(equalTo: stkVw.widthAnchor, multiplier: 0.2).isActive = true

        let thirdView = TutorialCircularView(frame: CGRect.zero, image: #imageLiteral(resourceName: "homeCircularSelected"))
        thirdView.alpha = 0.0
        stkVw.addArrangedSubview(thirdView)
        thirdView.heightAnchor.constraint(equalTo: stkVw.heightAnchor, multiplier: 1.0).isActive = true
        thirdView.widthAnchor.constraint(equalTo: stkVw.widthAnchor, multiplier: 0.2).isActive = true

        let fourthView = TutorialCircularView(frame: CGRect.zero, image: #imageLiteral(resourceName: "chatCircularUnselected"))
        fourthView.alpha = 0.0
        stkVw.addArrangedSubview(fourthView)
        fourthView.heightAnchor.constraint(equalTo: stkVw.heightAnchor, multiplier: 1.0).isActive = true
        fourthView.widthAnchor.constraint(equalTo: stkVw.widthAnchor, multiplier: 0.2).isActive = true

        let fifthView = TutorialCircularView(frame: CGRect.zero, image: #imageLiteral(resourceName: "profileCircularUnselected"))
        fifthView.alpha = 0.0
        stkVw.addArrangedSubview(fifthView)
        fifthView.heightAnchor.constraint(equalTo: stkVw.heightAnchor, multiplier: 1.0).isActive = true
        fifthView.widthAnchor.constraint(equalTo: stkVw.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    private func floatingArrowSetUp() {
        let image = #imageLiteral(resourceName: "bottomLeftArrow")
        self.floatingArrow = UIImageView(image: image)
        guard !self.floatingArrow.isNil, !self.bottomStackView.isNil else { return }
        self.floatingArrow!.translatesAutoresizingMaskIntoConstraints = false
        self.floatingArrow!.isUserInteractionEnabled = false
        self.addSubview(self.floatingArrow!)
        self.floatingArrow!.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.floatingArrow!.widthAnchor.constraint(equalToConstant: 19).isActive = true
        self.floatingArrowBottomAnchor = self.floatingArrow!.bottomAnchor.constraint(equalTo: self.bottomStackView!.topAnchor, constant: 5.0)
        self.floatingArrowBottomAnchor?.isActive = true
//        let arrowLeading = Router.shared.tabbar?.getFrameForTabAt(index: 0)?.width ?? 0.0 - 5
        let arrowLeading = 0.0 - 5
        self.floatingArrowLeadingAnchor = self.floatingArrow!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(arrowLeading))
        self.floatingArrowLeadingAnchor?.isActive = true
    }
    
    private func floatingStackViewSetUp() {
        self.floatingStackView = UIStackView()
        guard !self.floatingStackView.isNil, !self.floatingArrow.isNil else { return }
        self.floatingStackView!.spacing = 0
        self.floatingStackView!.axis = .horizontal
        self.floatingStackView!.alignment = .fill
        self.floatingStackView!.distribution = .fill
        self.floatingStackView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.floatingStackView!)
        let textHeight = (self.tutorialData.titles.first ?? "").textSize(withFont: UIFont.kAppDefaultFontBold(ofSize: 18.1), boundingSize: CGSize(width: UIDevice.width - 113, height: 10000)).height
        self.floatingStackView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        self.floatingStackView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        self.floatingStackViewBottomAnchor = self.floatingStackView!.bottomAnchor.constraint(equalTo: self.floatingArrow!.topAnchor, constant: -7.5)
        self.floatingStackViewBottomAnchor?.isActive = true
        self.floatingStackViewHeightAnchor = self.floatingStackView!.heightAnchor.constraint(equalToConstant: textHeight + 10)
        self.floatingStackViewHeightAnchor?.isActive = true
        self.addGestures(self.floatingStackView!)
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.font = UIFont.kAppDefaultFontBold()
        label.text = self.tutorialData.titles.first
        label.textColor = .white
        label.textAlignment = .left
        self.floatingStackView!.addArrangedSubview(label)
        label.heightAnchor.constraint(equalTo: self.floatingStackView!.heightAnchor, multiplier: 1.0).isActive = true
        
        let skipButtonView = SkipButtonView(frame: CGRect.zero)
        self.floatingStackView!.addArrangedSubview(skipButtonView)
        skipButtonView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        skipButtonView.heightAnchor.constraint(equalTo: self.floatingStackView!.heightAnchor, multiplier: 1.0).isActive = true
        skipButtonView.didTapOnButton = { [weak self] in
            self?.tutorialActions?(.skip)
        }
    }
    
    private func floatingImgViewSetUp() {
        let image = #imageLiteral(resourceName: "notificationCircular")
        self.floatingImgView = UIImageView(image: image)
        guard !self.floatingImgView.isNil else { return }
        self.floatingImgView!.translatesAutoresizingMaskIntoConstraints = false
        self.floatingImgView!.isUserInteractionEnabled = false
        self.addSubview(self.floatingImgView!)
        self.floatingImgView!.contentMode = .scaleAspectFit
        self.floatingImgView!.heightAnchor.constraint(equalToConstant: self.navBarContainerFrame.height).isActive = true
        self.floatingImgView!.widthAnchor.constraint(equalToConstant: self.navBarContainerFrame.height).isActive = true
        self.floatingImgView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.navBarContainerFrame.maxX - (self.navBarBellIconSize.width*1.06)).isActive = true
        self.floatingImgView!.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: self.navBarContainerFrame.origin.y).isActive = true
        self.floatingImgView!.isHidden = true
    }
    
    private func floatingSkipButtonSetUp() {
        self.floatingSkipButton = SkipButtonView(frame: CGRect.zero)
        guard !self.floatingSkipButton.isNil, !self.floatingImgView.isNil else { return }
        self.floatingSkipButton!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.floatingSkipButton!)
        self.floatingSkipButton!.widthAnchor.constraint(equalToConstant: 65).isActive = true
        self.floatingSkipButton!.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.floatingSkipButton!.topAnchor.constraint(equalTo: self.floatingImgView!.bottomAnchor, constant: 48.0).isActive = true
        self.floatingSkipButton!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0).isActive = true
        self.floatingSkipButton!.didTapOnButton = { [weak self] in
            self?.tutorialActions?(.skip)
        }
        self.floatingSkipButton!.isHidden = true
    }
    
    func showTutorialPage(isLeftSide: Bool) {
        if self.tutorialData.index < 1 {
            self.tutorialData.index = self.tutorialData.index + 1
            return
        }
        self.tutorialData.index = isLeftSide ? self.tutorialData.index - 1 : self.tutorialData.index + 1
        guard self.tutorialData.index < 7 else {
            self.tutorialActions?(.skip)
            return
        }
        if self.tutorialData.index == 6 {
            self.showGradient(fromTop: false)
        }
        else {
            if self.tutorialData.index == 0 {
                self.tutorialData.index = self.tutorialData.index + 1
            }
            self.showGradient(fromTop: true)
        }
        self.changeTutorialPage(index: Int(self.tutorialData.index))
    }
    
    private func changeTutorialPage(index: Int) {
        self.bottomStackView?.arrangedSubviews.forEach({$0.alpha = 0.0})
        self.bottomStackView?.arrangedSubviews[safe: index - 1]?.alpha = 1.0
        guard !self.floatingStackView.isNil else { return }
        if index == 4 || index == 5 {
            if let objView = self.floatingStackView!.arrangedSubviews.first(where: {$0.isKind(of: UILabel.self)}) {
                    objView.removeFromSuperview()
                (objView as? UILabel)?.text = self.tutorialData.titles[safe: index - 1]
                (objView as? UILabel)?.textAlignment = .right
                self.floatingStackView!.insertArrangedSubview(objView, at: 1)
            }
        } else {
            if let objView = self.floatingStackView!.arrangedSubviews.first(where: {$0.isKind(of: UILabel.self)}) {
                    objView.removeFromSuperview()
                (objView as? UILabel)?.text = self.tutorialData.titles[safe: index - 1]
                (objView as? UILabel)?.textAlignment = .left
                self.floatingStackView!.insertArrangedSubview(objView, at: 0)
            }
        }
        if let objView = self.floatingStackView!.arrangedSubviews.first(where: {$0.isKind(of: SkipButtonView.self)}) {
            objView.isHidden = index == 6
        }
        let textHeight = (self.tutorialData.titles[safe: index - 1] ?? "").textSize(withFont: UIFont.kAppDefaultFontBold(ofSize: 18.1), boundingSize: CGSize(width: UIDevice.width - 113, height: 10000)).height
        self.floatingStackViewHeightAnchor?.isActive = false
        self.floatingStackViewHeightAnchor?.constant = textHeight + 10
        self.floatingStackViewHeightAnchor?.isActive = true
        
        self.floatingImgView?.isHidden = index != 6
        self.floatingSkipButton?.isHidden = index != 6
        
        let image: UIImage
        let arrowLeading: CGFloat
        let arrowBottom: CGFloat
        let floatingStackViewBottom: CGFloat
        if index == 1 {
            image = #imageLiteral(resourceName: "bottomLeftArrow")
            let specificTabBarFrame: CGRect = CGRect.zero//Router.shared.tabbar?.getFrameForTabAt(index: index - 1) ?? CGRect.zero
            arrowLeading = specificTabBarFrame.width - 5
            arrowBottom = 5.0
            floatingStackViewBottom = -7.5
        }
        else if index == 6 {
            image = #imageLiteral(resourceName: "topRightArrow")
            let specificTabBarFrame: CGRect = CGRect.zero//Router.shared.tabbar?.getFrameForTabAt(index: index - 3) ?? CGRect.zero
            arrowLeading = specificTabBarFrame.maxX * 0.92
            let arrBottom = ((self.bottomStackView?.frame.origin.y ?? 0.0) - (self.floatingImgView?.frame.maxY ?? 0.0)*1.1)
            floatingStackViewBottom = textHeight*0.75
            arrowBottom = -arrBottom
        } else {
            image = #imageLiteral(resourceName: "bottomLeftArrow").withHorizontallyFlippedOrientation() // #imageLiteral(resourceName: "bottomRightArrow")
            let specificTabBarFrame: CGRect = CGRect.zero //Router.shared.tabbar?.getFrameForTabAt(index: index - 2) ?? CGRect.zero
            arrowLeading = specificTabBarFrame.maxX
            arrowBottom = 5.0
            floatingStackViewBottom = -7.5
        }
        
        self.floatingArrow?.image = image
        self.floatingArrowLeadingAnchor?.isActive = false
        self.floatingArrowLeadingAnchor?.constant = arrowLeading
        self.floatingArrowLeadingAnchor?.isActive = true

        self.floatingArrowBottomAnchor?.isActive = false
        self.floatingArrowBottomAnchor?.constant = arrowBottom
        self.floatingArrowBottomAnchor?.isActive = true

        self.floatingStackViewBottomAnchor?.isActive = false
        self.floatingStackViewBottomAnchor?.constant = floatingStackViewBottom
        self.floatingStackViewBottomAnchor?.isActive = true
    }
        
    //MARK:- IBActions
    //MARK:===========
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation: CGPoint = gesture.location(in: gesture.view)
        let maxLeftSide = ((self.bounds.maxX * 50) / 100) // Get 40% of Left side
        if touchLocation.x < maxLeftSide {
            self.tutorialActions?(.previousPage)
        } else {
            self.tutorialActions?(.nextPage)
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        switch direction {
            case .right:
                self.tutorialActions?(.previousPage)
            case .left:
                self.tutorialActions?(.nextPage)
            default:
                printDebug("Unrecognized Gesture Direction")
        }
    }
}

//MARK:- Extensions
//MARK:============
