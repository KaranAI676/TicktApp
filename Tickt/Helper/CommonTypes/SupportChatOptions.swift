//
//  SupportChatOptions.swift
//  Tickt
//
//  Created by S H U B H A M on 26/07/21.
//

import Foundation

enum SupportOptions: Int, CaseIterable {

    case jobs = 1
    case categories = 2
    case profile = 3
    case reviews = 4
    case payments = 5
    case other = 6
    
    var optionName: String {
        switch self {
        case .jobs:
            return "Jobs"
        case .categories:
            return "Categories"
        case .profile:
            return "Profile"
        case .reviews:
            return "Reviews"
        case .payments:
            return "Payments"
        case .other:
            return "Other"
        }
    }
}


struct SupportChatOptionModel {
    
    var optionType: SupportOptions
    var isSelected: Bool = false
    
    init(type: SupportOptions) {
        optionType = type
        isSelected = false
    }
}
