//
//  UIFont+Extension.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

extension UIFont {
    
    static let widthFactor = CGFloat(1.0)//(kScreenWidth / 320) > 1.2 ? 1.2 : (kScreenWidth / 320)
    
    class func printFontFamily() {
        for family in UIFont.familyNames {
            print("Family \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("Members----\(name)")
            }
        }
    }

    static func kAppDefaultFontInterRegular(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "Inter-Regular", size: size * widthFactor)!
    }
    
    static func kAppDefaultFontRoman(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "NeueHaasDisplay-Roman", size: size * widthFactor)!
    }

    static func kAppDefaultFontBold(ofSize size: CGFloat = 16) -> UIFont {
//        return UIFont(name: "NeueHaasDisplay-Bold", size: size * widthFactor)!
        return UIFont(name: "NeueHaasDisplay-Mediu", size: size * widthFactor)!
    }
    
    static func kAppDefaultFontLight(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "NeueHaasDisplay-Light", size: size * widthFactor)!
    }
    
    static func kAppDefaultFontMedium(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "NeueHaasDisplay-Mediu", size: size * widthFactor)!
    }
            
    static func kAppDefaultFontRegular(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "NeueHaasDisplay-Light", size: size * widthFactor)!
    }
    
    static func kDMSansFontBold(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "DMSans-Bold", size: size * widthFactor)!
    }
}

extension UIFont {

    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let fd = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: fd, size: pointSize)
    }

    func italics() -> UIFont {
        return withTraits(.traitItalic)
    }

    func bold() -> UIFont {
        return withTraits(.traitBold)
    }

    func boldItalics() -> UIFont {
        return withTraits([ .traitBold, .traitItalic ])
    }
}
