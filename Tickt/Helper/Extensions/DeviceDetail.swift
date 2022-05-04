//
//  DeviceDetail.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/07/21.
//


import UIKit
import Foundation
import SwiftyJSON

struct DeviceDetail {
    
    /// Enum - NetworkTypes
    enum NetworkType: String {
        case _2G = "2G"
        case _3G = "3G"
        case _4G = "4G"
        case lte = "LTE"
        case wifi = "Wifi"
        case none = ""
    }
    
    //MARK:- Window Dimension
    static let WINDOW_HEIGHT = UIScreen.main.bounds.height
    static let WINDOW_WIDTH = UIScreen.main.bounds.width

    
    /// Device Model
    static var deviceModel : String {        
        return UIDevice.current.model
    }
    
    /// OS Version
    static var osVersion : String {
        return UIDevice.current.systemVersion
    }
    
    /// Platform
    static var platform : String {
        return UIDevice.current.systemName
    }
    
    /// Device Id
    static var deviceId : String {        
        return getDataFromKeyChain(key: "deviceId")
    }
    
    /// IP Address
    static var ipAddress : String? {
        
        return getWiFiAddress()
    }
    
    /// Network Type
    static var networkType : NetworkType {
        
        return getNetworkType
    }
        
    static var deviceType = 3
    static var deviceToken = "DummyToken"
    static var fcmToken = "DummyFCMToken"
    
    static func getDataFromKeyChain(key: String) -> String {
        if let udid = KeyChainManager.load(key: key) {
            let uniqueID = String(data: udid, encoding: String.Encoding.utf8)
            return uniqueID!
        } else {
            let uniqueID = KeyChainManager.createUniqueID()
            let data = uniqueID.data(using: String.Encoding.utf8)
            _ = KeyChainManager.save(key: key, data: data!)
            return uniqueID
        }
    }
    
    /// Get Network Type
    private static var getNetworkType: NetworkType {
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar"),let foregroundView = (statusBar as AnyObject).value(forKey: "foregroundView") {
            
            let subviews = (foregroundView as AnyObject).subviews
            for subView in subviews! {
                
                if subView.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                    
                    if let value = subView.value(forKey: "dataNetworkType") {
                        
                        switch JSON(value).intValue {
                        case 0: return NetworkType.none
                        case 1: return NetworkType._2G
                        case 2: return NetworkType._3G
                        case 3: return NetworkType._4G
                        case 4: return NetworkType.lte
                        case 5: return NetworkType.wifi
                        default: return NetworkType.none
                        }
                    }
                }
            }
        }
        return NetworkType.none
    }
    
    /// Get Wifi Address
    fileprivate static func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    if let name = String(validatingUTF8: (interface?.ifa_name)!), name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var addr = interface?.ifa_addr.pointee
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr!, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }

        return address
    }
    
    static func getDeviceIsIphoneXOrAbove() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return false
            case 1334:
                print("iPhone 6/6S/7/8")
                return false
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                return false
            case 2436:
                print("iPhone X/XS/11 Pro")
                return true
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                return true
            case 1792:
                print("iPhone XR/ 11 ")
                return true
            default:
                print("Unknown")
                return false
            }
        }
        return false
    }

}
