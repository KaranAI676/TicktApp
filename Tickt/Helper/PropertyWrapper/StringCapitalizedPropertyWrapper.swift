//
//  PropertyWrapper.swift
//  Tickt
//
//  Created by Tickt on 20/11/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import Foundation

@propertyWrapper
struct Capitalized {
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}
