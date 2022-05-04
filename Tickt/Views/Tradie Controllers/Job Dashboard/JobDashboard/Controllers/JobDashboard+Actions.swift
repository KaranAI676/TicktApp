//
//  JobDashboard+Actions.swift
//  Tickt
//
//  Created by Admin on 12/05/21.
//

import Foundation

extension JobDashboardVC {
    
    func activeBtnAction(goToVC: Bool = false) {
        setupTheButtonsState(sender: activeButton)
        if goToVC {
            if pageViewController?.selectedViewController === activeJobVC { return }
            pageViewController?.selectViewController(activeJobVC, direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func openBtnAction(goToVC: Bool = false) {
        setupTheButtonsState(sender: openButton)
        if goToVC {
            if pageViewController?.selectedViewController === openJobVC { return }
            pageViewController?.selectViewController(openJobVC, direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pastBtnAction(goToVC: Bool = false) {
        setupTheButtonsState(sender: pastButton)
        if goToVC {
            if pageViewController?.selectedViewController === pastJobVC { return }
            pageViewController?.selectViewController(pastJobVC, direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupTheButtonsState(sender: UIButton) {
        let _ = buttonsArray.map({ button in
            if button === sender {
                button.alpha = 1.0
                button.titleLabel?.textColor = .white
                button.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 18)
            } else {
                button.alpha = 0.5
                button.titleLabel?.textColor = AppColors.appGrey
                button.titleLabel?.font = UIFont.kAppDefaultFontRoman(ofSize: 18)
            }
        })
    }
    
    func disableButtons(sender: UIButton) {
        sender.isEnabled = false
        CommonFunctions.delay(delay: 0.3, closure: {
            sender.isEnabled = true
        })
    }
}
