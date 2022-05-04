//
//  SwipeableController.swift
//  Tickt
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit

class SwipeableController<ChildVC: UIViewController>: UIViewController, UIGestureRecognizerDelegate {
    
    enum SwipeState {
        case close
        case cutomOffset
        case open
    }
    
    // MARK: - Configuration
    struct SwipeViewConfiguration {
        var initialState: SwipeState = .close
        fileprivate var initialOffset: CGFloat {
            switch self.initialState {
            case .open:
                return 0
            case .cutomOffset:
                return self.popUpHeight - self.midHeight
            case .close:
                return self.popUpHeight - self.offset
            }
        }
        var popUpHeight: CGFloat = 600
        var midHeight: CGFloat = 300
        var offset: CGFloat = 40
    }
    
    // MARK: - Variables
    private let configuration: SwipeViewConfiguration
    private let childViewController: ChildVC
    private var currentState: SwipeState = .close {
        didSet {
            self.scrollView?.isScrollEnabled = self.currentState == .open
        }
    }
    private let containerView = UIView()
    private var popUpViewBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var initialTouchPoint: CGPoint = CGPoint.zero
    private let scrollView: UIScrollView?
    private var isScrollingFinished: Bool = true
    ///Will change from state, to state
    var willChangePopUpState: ((_ fromState: SwipeState,_ toState: SwipeState) -> Void)? = nil
    ///Did change to state
    var didChangePopUpState: ((_ state: SwipeState) -> Void)? = nil
    ///visiblePercentageOfSheet will be from 0 to 1
    var animationBlockWhileScrolling: ((_ state: SwipeState, _ visiblePercentageOfSheet: CGFloat) -> ())? = nil
    var isStatusBarHidden: Bool = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGestureRecognizerHandler(_:)))
        gesture.delegate = self
        return gesture
    }()
    ///From 0 to 1
    private var getVisiblePercentageOfSheet: CGFloat {
        return 1 - (self.popUpViewBottomConstraint.constant/self.configuration.popUpHeight)
    }

    override var prefersStatusBarHidden: Bool {
        self.isStatusBarHidden
    }
    
    // MARK: - Initialization
    public init(childViewController: ChildVC, swipeViewConfiguration: SwipeViewConfiguration) {
        self.childViewController = childViewController
        if childViewController.view.isKind(of: UIScrollView.self) {
            self.scrollView = childViewController.view as? UIScrollView
        } else if let scrollView = childViewController.view.subviews.first(where: {$0.isKind(of: UIScrollView.self)}) as? UIScrollView {
            self.scrollView = scrollView
        } else {
            self.scrollView = nil
        }
        self.configuration = swipeViewConfiguration
        self.currentState = self.configuration.initialState
        super.init(nibName: nil, bundle: nil)
        self.initializeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeViews() {
        self.view.addSubview(containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: self.configuration.popUpHeight).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.popUpViewBottomConstraint = self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.configuration.initialOffset)
        self.popUpViewBottomConstraint.isActive = true
        self.containerView.addGestureRecognizer(self.panGesture)

        self.childViewController.view.removeFromSuperview()
        self.childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.childViewController.willMove(toParent: self)
        self.addChild(self.childViewController)
        self.childViewController.didMove(toParent: self)
        self.containerView.addSubview(self.childViewController.view)
        
        self.childViewController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.childViewController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        self.childViewController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        self.childViewController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
    }
    
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        self.scrollView?.isScrollEnabled = false
//        if self.isScrollingFinished {
//            self.willChangePopUpState?(self.currentState)
//            self.isScrollingFinished = false
//        }
        let touchPoint = sender.location(in: self.containerView.window)
        let velocity = sender.velocity(in:  self.containerView)
        switch sender.state {
        case .possible:
            printDebug(sender.state)
        case .began:
            self.initialTouchPoint = touchPoint
        case .changed:
            let touchPointDiffY = self.initialTouchPoint.y - touchPoint.y
            switch self.currentState {
            case .close:
                let bottomPoint = (self.configuration.popUpHeight - self.configuration.offset)
                if touchPointDiffY > 0 {
                    if self.popUpViewBottomConstraint.constant.magnitude > self.configuration.offset {
                        self.popUpViewBottomConstraint.constant = bottomPoint - touchPointDiffY
                        self.animationBlockWhileScrolling?(self.currentState, self.getVisiblePercentageOfSheet)
                    } else {
                        self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint, withDuration: 0.15)
                    }
                }
            case .cutomOffset:
                if touchPointDiffY > 0 {
                    if self.popUpViewBottomConstraint.constant.magnitude > self.configuration.offset {
                        self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.midHeight - touchPointDiffY
                        self.animationBlockWhileScrolling?(self.currentState, self.getVisiblePercentageOfSheet)
                    } else {
                        self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint, withDuration: 0.15)
                    }
                } else {
                    self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.midHeight - touchPointDiffY
                    self.animationBlockWhileScrolling?(self.currentState, self.getVisiblePercentageOfSheet)
                }
            case .open:
                if touchPointDiffY < 0 {
                    self.popUpViewBottomConstraint.constant = -touchPointDiffY
                    self.animationBlockWhileScrolling?(self.currentState, self.getVisiblePercentageOfSheet)
                }
            }
        case .ended:
            self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint)
        case .cancelled:
            self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint)
        case .failed:
            printDebug(sender.state)
        @unknown default:
            break
        }
    }
    
    ///Call to use Pan Gesture Final Animation
    private func panGestureFinalAnimation(velocity: CGPoint, touchPoint: CGPoint, withDuration: TimeInterval = 0.5) {
        let visiblePercentageOfSheet = self.getVisiblePercentageOfSheet
        if visiblePercentageOfSheet > 0.8 {
            self.bottomSheetAnimationCompletion(nextState: .open, withDuration: withDuration)
        }  else if visiblePercentageOfSheet > 0.45 {
            self.bottomSheetAnimationCompletion(nextState: .cutomOffset, withDuration: withDuration)
        } else {
            self.bottomSheetAnimationCompletion(nextState: .close, withDuration: withDuration)
        }
        /*
         //Bottom Direction
         if velocity.y < 0 {
         }
         //Up Direction
         else {
         }
         */
    }
    
    ///Call to open Bottom sheet
    private func bottomSheetAnimationCompletion(nextState: SwipeState, withDuration: TimeInterval) {
        self.willChangePopUpState?(self.currentState , nextState)
        UIView.animate(withDuration: withDuration, animations: { [weak self] in
            guard let `self` = self else { return }
            switch nextState {
            case .close:
                self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.offset
            case .cutomOffset:
                self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.midHeight
            case .open:
                self.popUpViewBottomConstraint.constant = 0.0
            }
            self.view.layoutIfNeeded()
        }) { [weak self] (true) in
            guard let `self` = self else { return }
            self.currentState = nextState
            self.isScrollingFinished = true
            self.didChangePopUpState?(nextState)
        }
    }
        
    //MARK: Gesture recognition
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = self.scrollView, gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) else { return true }
        if self.currentState != .open {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        return scrollView.contentOffset.y <= 0
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = self.scrollView else { return true }
        let pointInChildScrollView = self.containerView.convert(self.initialTouchPoint, to: scrollView).y - scrollView.contentOffset.y
        let velocity = self.panGesture.velocity(in: self.panGesture.view?.superview)
        guard pointInChildScrollView > 0, pointInChildScrollView < scrollView.bounds.height else {
            return true
        }
        guard abs(velocity.y) > abs(velocity.x), scrollView.contentOffset.y <= 0 else { return false }
        
        if velocity.y < 0 {
            return self.currentState != .open
        } else {
            return true
        }
    }
}

protocol SwipeableViewDelegate: AnyObject {
    
    ///Page view start scrolling
    func pageViewStartScroll (_ state: SwipeableView.SwipeState)

    ///Will change from state to state
    func willChangeState (_ fromState: SwipeableView.SwipeState,_ toState: SwipeableView.SwipeState)
    
    ///Did change to state
    func didChangeState (_ state: SwipeableView.SwipeState)
    
    ///visiblePercentageOfSheet will be from 0 to 1
    func pageViewDidScroll (_ state: SwipeableView.SwipeState, _ visiblePercentageOfSheet: CGFloat)
}

extension SwipeableViewDelegate {
    func pageViewStartScroll (_ state: SwipeableView.SwipeState) {}
    func willChangeState (_ fromState: SwipeableView.SwipeState,_ toState: SwipeableView.SwipeState) {}
    func didChangeState (_ state: SwipeableView.SwipeState) {}
    func pageViewDidScroll (_ state: SwipeableView.SwipeState, _ visiblePercentageOfSheet: CGFloat) {}
}

class SwipeableView: UIView {
    
    enum SwipeState {
        case close
        case customOffset
        case open
    }
    
    // MARK: - Configuration
    struct SwipeViewConfiguration {
        var initialState: SwipeState = .close
        fileprivate var initialOffset: CGFloat {
            switch self.initialState {
            case .open:
                return 0
            case .customOffset:
                return self.popUpHeight - self.midHeight
            case .close:
                return self.popUpHeight - self.offset
            }
        }
        var popUpHeight: CGFloat = 600
        var midHeight: CGFloat = 300
        var offset: CGFloat = 40
    }
    
    // MARK: - Variables
    private var configuration = SwipeViewConfiguration.init()
    private var currentState: SwipeState = .close {
        didSet {
            self.scrollView?.isScrollEnabled = self.currentState == .open
        }
    }
    weak var delegate: SwipeableViewDelegate?
    private var popUpViewBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var popUpViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var initialTouchPoint: CGPoint = CGPoint.zero
    private weak var scrollView: UIScrollView?
    private var isScrollingFinished: Bool = true
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGestureRecognizerHandler(_:)))
        gesture.delegate = self
        return gesture
    }()
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapGestureRecognizerHandler(_:)))
        gesture.delegate = self
        return gesture
    }()
    ///From 0 to 1
    private var getVisiblePercentageOfSheet: CGFloat {
        return 1 - (self.popUpViewBottomConstraint.constant/self.configuration.popUpHeight)
    }
    var getCurrentState: SwipeState {
        self.currentState
    }
    
    // MARK: - Initialization
    func setup(bottomConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint, conflictScrollView: UIScrollView? = nil, swipeViewConfiguration: SwipeViewConfiguration) {
        self.popUpViewBottomConstraint = bottomConstraint
        self.popUpViewHeightConstraint = heightConstraint
        self.scrollView = conflictScrollView
        self.configuration = swipeViewConfiguration
        self.currentState = self.configuration.initialState
        self.finalSetup()
    }
    
    private func finalSetup() {
        self.popUpViewBottomConstraint.constant = self.configuration.initialOffset
        self.popUpViewBottomConstraint.isActive = true
        self.popUpViewHeightConstraint.constant = self.configuration.popUpHeight
        self.popUpViewHeightConstraint.isActive = true
        self.addGestureRecognizer(self.panGesture)
        self.addGestureRecognizer(self.tapGesture)
    }
    
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        self.scrollView?.isScrollEnabled = false
        if self.isScrollingFinished {
            self.delegate?.pageViewStartScroll(self.currentState)
            self.isScrollingFinished = false
        }
        let touchPoint = sender.location(in: self.window)
        let velocity = sender.velocity(in:  self)
        switch sender.state {
        case .possible:
            printDebug(sender.state)
        case .began:
            self.initialTouchPoint = touchPoint
        case .changed:
            let touchPointDiffY = self.initialTouchPoint.y - touchPoint.y
            switch self.currentState {
            case .close:
                let bottomPoint = (self.configuration.popUpHeight - self.configuration.offset)
                if touchPointDiffY > 0 {
                    if self.popUpViewBottomConstraint.constant.magnitude > self.configuration.offset {
                        self.popUpViewBottomConstraint.constant = bottomPoint - touchPointDiffY
                        self.delegate?.pageViewDidScroll(self.currentState, self.getVisiblePercentageOfSheet)
                    } else {
                        self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint, withDuration: 0.15)
                    }
                }
            case .customOffset:
                if touchPointDiffY > 0 {
                    if self.popUpViewBottomConstraint.constant.magnitude > self.configuration.offset {
                        self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.midHeight - touchPointDiffY
                        self.delegate?.pageViewDidScroll(self.currentState, self.getVisiblePercentageOfSheet)
                    } else {
                        self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint, withDuration: 0.15)
                    }
                } else {
                    self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.midHeight - touchPointDiffY
                    self.delegate?.pageViewDidScroll(self.currentState, self.getVisiblePercentageOfSheet)
                }
            case .open:
                if touchPointDiffY < 0 {
                    self.popUpViewBottomConstraint.constant = -touchPointDiffY
                    self.delegate?.pageViewDidScroll(self.currentState, self.getVisiblePercentageOfSheet)
                }
            }
        case .ended:
            self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint)
        case .cancelled:
            self.panGestureFinalAnimation(velocity: velocity, touchPoint: touchPoint)
        case .failed:
            printDebug(sender.state)
        @unknown default:
            break
        }
    }
    
    @IBAction func tapGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if self.currentState == .close {
            self.delegate?.pageViewStartScroll(self.currentState)
            self.isScrollingFinished = false
            self.changeSheetState(nextState: .open, isAnimated: true)
        }
    }
    
    ///Call to use Pan Gesture Final Animation
    private func panGestureFinalAnimation(velocity: CGPoint, touchPoint: CGPoint, withDuration: TimeInterval = 0.5) {
        let visiblePercentageOfSheet = self.getVisiblePercentageOfSheet
        let midValueOfMaxAndMidHeight = (self.configuration.popUpHeight + self.configuration.midHeight)/(2.0*self.configuration.popUpHeight)
        let midValueOfMidAndOffsetHeight = (self.configuration.midHeight + self.configuration.offset)/(2.0*self.configuration.popUpHeight)
        if visiblePercentageOfSheet > midValueOfMaxAndMidHeight {
            self.bottomSheetAnimationCompletion(nextState: .open, withDuration: withDuration)
        }  else if visiblePercentageOfSheet > midValueOfMidAndOffsetHeight {
            self.bottomSheetAnimationCompletion(nextState: .customOffset, withDuration: withDuration)
        } else {
            self.bottomSheetAnimationCompletion(nextState: .close, withDuration: withDuration)
        }
        /*
         //Bottom Direction
         if velocity.y < 0 {
         }
         //Up Direction
         else {
         }
         */
    }
    
    ///Call to open Bottom sheet
    private func bottomSheetAnimationCompletion(nextState: SwipeState, withDuration: TimeInterval) {
        self.delegate?.willChangeState(self.currentState, nextState)
        UIView.animate(withDuration: withDuration, animations: { [weak self] in
            guard let `self` = self else { return }
            switch nextState {
            case .close:
                self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.offset
            case .customOffset:
                self.popUpViewBottomConstraint.constant = self.configuration.popUpHeight - self.configuration.midHeight
            case .open:
                self.popUpViewBottomConstraint.constant = 0.0
            }
            self.superview?.layoutIfNeeded()
        }) { [weak self] (true) in
            guard let `self` = self else { return }
            self.currentState = nextState
            self.isScrollingFinished = true
            self.delegate?.didChangeState(nextState)
        }
    }
    
    func changeSheetState(nextState: SwipeState, isAnimated: Bool) {
        self.bottomSheetAnimationCompletion(nextState: nextState, withDuration: isAnimated ? 0.33 : 0.0)
    }
}
 
//MARK: Gesture recognition
extension SwipeableView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = self.scrollView, gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) else { return true }
        if self.currentState != .open {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        return scrollView.contentOffset.y <= 0
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) && self.currentState == .close { return true }
        guard let scrollView = self.scrollView else { return true }
        let pointInChildScrollView = self.convert(self.initialTouchPoint, to: scrollView).y - scrollView.contentOffset.y
        let velocity = self.panGesture.velocity(in: self.panGesture.view?.superview)
        guard pointInChildScrollView > 0, pointInChildScrollView < scrollView.bounds.height else {
            return true
        }
        guard abs(velocity.y) > abs(velocity.x), scrollView.contentOffset.y <= 0 else { return false }
        
        if velocity.y < 0 {
            return self.currentState != .open
        } else {
            return true
        }
    }
}
