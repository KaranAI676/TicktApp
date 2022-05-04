//
//  Loader.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

class Loader {    
    class func show(message: String = "") {
        DispatchQueue.main.async {
            SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
            SKActivityIndicator.spinnerColor(AppColors.themeBlue)
            SKActivityIndicator.show(message, userInteractionStatus: false)
        }
    }
    
    class func hide() {
        DispatchQueue.main.async {
            SKActivityIndicator.dismiss()
        }
    }
}
