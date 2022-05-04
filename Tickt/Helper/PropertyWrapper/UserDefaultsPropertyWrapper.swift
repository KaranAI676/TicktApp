//
//  UserDefaultsPropertyWrapper.swift
//  Tickt
//
//  Created by Tickt on 20/11/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value : Codable> {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            // Read value from UserDefaults
            guard let data = storage.value(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)
                storage.setValue(data, forKey: key)
            }
        }
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

struct UserDefaultWrapper<T: Codable> {

    struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }

    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data
                else { return defaultValue }
            let value = try? JSONDecoder().decode(Wrapper<T>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                let data = try JSONEncoder().encode(Wrapper(wrapped:newValue))
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                printDebug(error)
            }
        }
    }
}
