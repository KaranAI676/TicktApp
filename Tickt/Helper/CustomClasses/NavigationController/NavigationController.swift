//
//  NavigationController.swift
//  Tickt
//
//  Created by S H U B H A M on 27/07/21.
//

import Foundation

class NavigationController: UINavigationController {

    override var shouldAutorotate : Bool {
        return false
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade// .slide : .fade
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        self.interactivePopGestureRecognizer?.isEnabled = !kUserDefaults.getAccessToken().isEmpty
        self.interactivePopGestureRecognizer?.delegate = self
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
