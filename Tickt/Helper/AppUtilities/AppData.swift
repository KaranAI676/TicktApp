//
//  AppData.swift
//  Tickt
//
//  Created by Admin on 22/03/21.
//

import Foundation

struct AppData {
    @UserDefaultsBacked(key: CodingKeys.preLoginTutorialDisplayed.rawValue, defaultValue: false)
    static var preLoginTutorialDisplayed: Bool
    @UserDefaultsBacked(key: CodingKeys.postLoginTutorialDisplayed.rawValue, defaultValue: nil)
    static var postLoginTutorialDisplayed: Bool?
//    @UserDefaultsBacked(key: CodingKeys.userModel.rawValue, defaultValue: UserModel())
//    static var userModel: UserModel {
//        didSet {
//            UserModel.main = userModel
//        }
//    }
    @UserDefaultsBacked(key: CodingKeys.accessToken.rawValue, defaultValue: "")
    static var accessToken: String
    @UserDefaultsBacked(key: CodingKeys.latitude.rawValue, defaultValue: nil)
    static var latitude: Double?
    @UserDefaultsBacked(key: CodingKeys.longitude.rawValue, defaultValue: nil)
    static var longitude: Double?

    enum CodingKeys: String, CodingKey {
        case preLoginTutorialDisplayed
        case postLoginTutorialDisplayed
//        case userModel
        case accessToken
        case latitude
        case longitude
    }
}

extension AppData {
    
//    static func logoutDataSetUp() {
//        self.userModel = UserModel()
//        AppUserDefaults.removeAllValues()
//        AppUserDefaults.removeValue(forKey: CodingKeys.userModel.rawValue)
//        AppUserDefaults.removeValue(forKey: CodingKeys.accessToken.rawValue)
//        self.preLoginTutorialDisplayed = true
//        if let value = AppUserDefaults.value(forKey: CodingKeys.postLoginTutorialDisplayed.rawValue) as? Bool {
//            self.postLoginTutorialDisplayed = value
//        }
//    }
}

enum AppUserDefaults {
    static func save(value: Any, forKey key: String) {
        let storage: UserDefaults = .standard
        storage.set(value, forKey: key)
        storage.synchronize()
    }
    
    static func removeValue(forKey key: String) {
        let storage: UserDefaults = .standard
        storage.removeObject(forKey: key)
        storage.synchronize()
    }
    
    static func value(forKey key: String) -> Any? {
        let storage: UserDefaults = .standard
        return storage.value(forKey: key)
    }
    
    static func removeAllValues() {
        let storage: UserDefaults = .standard
        let dictionary = storage.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            storage.removeObject(forKey: key)
        }
        let appDomain = Bundle.main.bundleIdentifier!
        storage.removePersistentDomain(forName: appDomain)
        storage.synchronize()
    }
}
