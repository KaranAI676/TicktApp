//
//  ReasonTypes.swift
//  Tickt
//
//  Created by S H U B H A M on 26/07/21.
//

import Foundation

enum ReasonsType: Int, CaseIterable {
    case staffShortage = 1
    case notAvailable = 2
    case delayOnOthers = 3
    case currentProjectDelay = 4
    case injury = 5
    
    var reason: String {
        switch self {
        case .staffShortage:
            return "Experiencing delays on other projects."
        case .notAvailable:
            return "Current project has taken longer than expected."
        case .delayOnOthers:
            return "Staff shortages."
        case .currentProjectDelay:
            return "Injury or unwell."
        case .injury:
            return "No longer available."
        }
    }
}

enum DisputeReason: Int, CaseIterable {
    case siteNotReady = 1
    case inadequate = 2
    case limitedResources = 3
    case materialSupply = 4
    case regulation = 5
    case currencyVerify = 6
    case lowStandard = 7
    
    var reason: String {
        switch self {
        case .siteNotReady:
            return "Site has not been prepared for works to be carried out."
        case .inadequate:
            return "Inadequate access."
        case .limitedResources:
            return "No access equipment on site as indicated in JD4"
        case .materialSupply:
            return "Materials had not been delivered and supplied by the builder as part of the JD."
        case .regulation:
            return "Tradespersons work does not be regulations or comply with the VBA."
        case .currencyVerify:
            return "Tradesperson has not supplied a Certificate of Currency for their work."
        case .lowStandard:
            return "Tradespersons work is not at an acceptable standard"
        }
    }
}

struct DisputeModel {
    
    var reasonType: DisputeReason
    var isSelected: Bool = false
    
    init(type: DisputeReason) {
        reasonType = type
        isSelected = false
    }
}


struct ReasonsModel {
    
    var reasonType: ReasonsType
    var isSelected: Bool = false
    
    init(type: ReasonsType) {
        reasonType = type
        isSelected = false
    }
}
