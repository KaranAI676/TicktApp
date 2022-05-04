//
//  SwipeableNavigationController.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/11/20.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class SwipeableNavigationController: UINavigationController {
    private var isPushAnimating = false
    var isSwipeEnabled = true
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushAnimating = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension SwipeableNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let _ = navigationController as? SwipeableNavigationController else { return }
           isPushAnimating = false
    }
}

extension SwipeableNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if !isSwipeEnabled {
            return isSwipeEnabled
        }
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        return viewControllers.count > 1 && isPushAnimating == false
    }
}
