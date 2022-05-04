//
//  AppTutorialController.swift
//  Tickt
//
//  Created by Tickt on 17/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

class AppTutorialController: BaseVC {
    
    //MARK:- Variables
    //================
    var dissmisCompletion: (() -> Void)? = nil
    var navBarContainerFrame: CGRect = CGRect.zero
    var navBarBellIconSize: CGSize = CGSize.zero
    
    //MARK:- IBOutlets
    //================
    @IBOutlet weak var tutorialView: AppTutorialView!
    
    //MARK:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
        self.actions()
    }
    
    //MARK:- Functions
    //================
    private func initialSetUp() {
        self.tutorialView.navBarContainerFrame = self.navBarContainerFrame
        self.tutorialView.navBarBellIconSize = self.navBarBellIconSize
        self.tutorialView.initialSetUp()
    }
    
    private func actions() {
        self.tutorialView.tutorialActions = { [weak self] (actionType) in
            guard let `self` = self else { return }
            switch actionType {
            case .previousPage:
                //for prevPage -> self.tutorialView.showTutorialPage(isLeftSide: true)
                self.tutorialView.showTutorialPage(isLeftSide: false)
            case .nextPage:
                self.tutorialView.showTutorialPage(isLeftSide: false)
            case .skip:
//                self.removeFromParent
                self.dismiss(animated: false) { [weak self] in
                    self?.dissmisCompletion?()
                }
            }
        }
    }
    
    //MARK:- IBActions
    //================
}

//MARK:- Extensions
//=================
extension AppTutorialController {
    
}
