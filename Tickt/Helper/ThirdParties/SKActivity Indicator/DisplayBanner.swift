//
//  DisplayBanner.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Foundation

class DisplayBanner {
    static let shared = DisplayBanner()

    private var banner = TWMessageBarManager.sharedInstance()

    init() {

    }

    class func successBanner(message: String) {
        DispatchQueue.main.async {            
            TWMessageBarManager.sharedInstance().hideAll()
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: message, type: .success, duration: 1.5, statusBarHidden: false, callback: nil)
        }        
    }
    
    class func failureBanner(message: String) {
        DispatchQueue.main.async {
            TWMessageBarManager.sharedInstance().hideAll()
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: message, type: .error, duration: 1.5, statusBarHidden: false, callback: nil)
        }
    }
    
    class func infoBanner(message: String) {
        DispatchQueue.main.async {
            TWMessageBarManager.sharedInstance().hideAll()
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Info", description: message, type: .info, duration: 1.5, statusBarHidden: false, callback: nil)
        }
    }
}
