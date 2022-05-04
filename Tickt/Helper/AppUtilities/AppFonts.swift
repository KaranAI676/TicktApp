//
//  AppFonts.swift
//  NowCrowdApp
//
//  Created by Admin on 15/06/20.
//  Copyright © 2020 Admin2020. All rights reserved.
//
import Foundation
import UIKit


enum AppFonts: String {    
    case NeueHaasDisplayBlackItalic = "NeueHaasDisplayBlackItalic"
    case NeueHaasDisplayBold = "NeueHaasDisplayBold"
    case NeueHaasDisplayBoldItalic = "NeueHaasDisplayBoldItalic"
    case NeueHaasDisplayLight = "NeueHaasDisplayLight"
    case NeueHaasDisplayLightItalic = "NeueHaasDisplayLightItalic"
    case NeueHaasDisplayMediu = "NeueHaasDisplayMediu"
    case NeueHaasDisplayMediumItalic = "NeueHaasDisplayMediumItalic"
    case NeueHaasDisplayRoman = "NeueHaasDisplayRoman"
    case NeueHaasDisplayRomanItalic = "NeueHaasDisplayRomanItalic"
    case NeueHaasDisplayThin = "NeueHaasDisplayThin"
    case NeueHaasDisplayThinItalic = "NeueHaasDisplayThinItalic"
    case NeueHaasDisplayXThin = "NeueHaasDisplayXThin"
    case NeueHaasDisplayXThinItalic = "NeueHaasDisplayXThinItalic"
    case NeueHaasDisplayXXThin = "NeueHaasDisplayXXThin"
    case NeueHaasDisplayXXThinItalic = "NeueHaasDisplayXXThinItalic"
    case NeueHaasDisplayBlack = "NeueHaasDisplayBlack"
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
}
