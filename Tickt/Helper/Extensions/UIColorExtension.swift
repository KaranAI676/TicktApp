//
//  UIColorExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import UIKit

extension UIColor{
    
    convenience init(r: Int, g: Int, b: Int, alpha : CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1, "Invalid alpha component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    ///Returns the color based on the given R,G,B and alpha values
    class func colorRGB(r:Int, g:Int, b:Int, alpha:CGFloat = 1)->UIColor{
        
        return UIColor(r: r, g: g, b: b, alpha: alpha)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

    ///Returns the color based on the given hex string
    class func colorHex(hexString:String) -> UIColor {
        
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
        
    }
    
    struct Green {
        static let fern = UIColor.colorHex(hexString:"0x6ABB72")
        static let mountainMeadow = UIColor.colorHex(hexString:"0x3ABB9D")
        static let chateauGreen = UIColor.colorHex(hexString:"0x4DA664")
        static let persianGreen = UIColor.colorHex(hexString:"0x2CA786")
    }
    
    struct Blue {
        static let pictonBlue = UIColor.colorHex(hexString:"0x5CADCF")
        static let mariner = UIColor.colorHex(hexString:"0x3585C5")
        static let curiousBlue = UIColor.colorHex(hexString:"0x4590B6")
        static let denim = UIColor.colorHex(hexString:"0x2F6CAD")
        static let chambray = UIColor.colorHex(hexString:"0x485675")
        static let blueWhale = UIColor.colorHex(hexString:"0x29334D")
    }
    
    struct Violet {
        static let wisteria = UIColor.colorHex(hexString:"0x9069B5")
        static let blueGem = UIColor.colorHex(hexString:"0x533D7F")
    }
    
    struct Yellow {
        static let energy = UIColor.colorHex(hexString:"0xF2D46F")
        static let turbo = UIColor.colorHex(hexString:"0xF7C23E")
    }
    
    struct Orange {
        static let neonCarrot = UIColor.colorHex(hexString:"0xF79E3D")
        static let sun = UIColor.colorHex(hexString:"0xEE7841")
    }
    
    struct Red {
        static let terraCotta = UIColor.colorHex(hexString:"0xE66B5B")
        static let valencia = UIColor.colorHex(hexString:"0xCC4846")
        static let cinnabar = UIColor.colorHex(hexString:"0xDC5047")
        static let wellRead = UIColor.colorHex(hexString:"0xB33234")
    }
    
    struct Gray {
        static let almondFrost = UIColor.colorHex(hexString:"0xA28F85")
        static let whiteSmoke = UIColor.colorHex(hexString:"0xEFEFEF")
        static let iron = UIColor.colorHex(hexString:"0xD1D5D8")
        static let ironGray = UIColor.colorHex(hexString:"0x75706B")
    }
}

extension UIColor {
    
    func generateRandomColors(_ count: Int, colorArray: [UIColor]? = nil) -> [UIColor] {
        
        var arrayValues = [UIColor]() //Set(colorArray ?? [UIColor]())
        
        if let colorArray = colorArray {
            arrayValues = colorArray
        }
        
        while arrayValues.count < count {
            let redValue = CGFloat.random(in: 0...1)
            let greenValue = CGFloat.random(in: 0...1)
            let blueValue = CGFloat.random(in: 0...1)
            arrayValues.append(UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0))
//            arrayValues.insert(UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0))
            arrayValues = arrayValues.unique()
        }
        return Array(arrayValues)
    }

}
