//
//  Globals.swift
//  NowCrowdApp
//
//  Created by Admin on 15/06/20.
//  Copyright © 2020 Admin2020. All rights reserved.
//

import Foundation
import UIKit
//import Mixpanel
/// Print Debug
func printDebug<T>(_ obj : T) {
    #if DEBUG
        print(obj)
    #endif
}

/// Is Simulator or Device
var isSimulatorDevice: Bool {

    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}

/// Is this iPhone X or not
func isDeviceIsIphoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136: return false
        case 1334: return false
        case 2208: return false
        case 2436: return true
        default: return false
        }
    }
    return false
}

///checking Iphone model to set navigation bar bounds
func checkIsIphoneXOrGreater() -> Bool {    
    switch UIScreen.main.nativeBounds.height {
    case 1136:
        return false
    case 1334:
        return false
    case 1920, 2208:
        return false
    case 2436:
        return true
    case 2688:
        return true
    case 1792:
        return true
    default:
        return false
    }
}
