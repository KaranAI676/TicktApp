//
//  SelectUserVC.swift
//  Tickt
//
//  Created by Admin on 08/03/21.
//

import UIKit

class SelectUserVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tradieButtonAction(_ sender: UIButton) {
        kUserDefaults.setValue(1, forKey: UserDefaultKeys.kuserType)
        navigateToRegistration()
        disableButton(sender)
    }
    
    @IBAction func builderButtonAction(_ sender: UIButton) {
        kUserDefaults.setValue(2, forKey: UserDefaultKeys.kuserType)
        navigateToRegistration()
        disableButton(sender)
    }
    
    func navigateToRegistration() {
        let introVC = IntroVC.instantiate(fromAppStoryboard: .onBoarding)
        push(vc: introVC)
    }
    
    func navigateToCreateAccount() {
        let vc = CreateAccountVC.instantiate(fromAppStoryboard: .registration)
        push(vc: vc)        
    }
}
