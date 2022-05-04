//
//  UserDefaults+Addition.swift
//  Shift Vendor
//
//  Created by Vijay on 09/07/19.
//  Copyright © 2019 Vijay. All rights reserved.
//

import CoreLocation

extension UserDefaults {
    
    func isUserLogin() -> Bool {
        return bool(forKey: UserDefaultKeys.kIsLoggedIn)
    }
    
    func isFirebaseCreated() -> Bool {
        return bool(forKey: UserDefaultKeys.kFirebaseLoggedIn)
    }

    func getUserId() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kUserId))
    }
    
    func getAccessToken() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kAccessToken))
    }
    
    func getDeviceToken() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kDeviceToken))
    }

    func getUserTrade() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kTrade))
    }
    
    func getUsername() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kUsername))
    }
    
    func getFirstName() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kFirstName))
    }

    func getUserMobile() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kPhoneNumber))
    }
    
    func getUserEmail() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kLoggedInEmail))
    }
    
    func getUserProfileImage() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kProfileImage))
    }

    func getUserPassword() -> String {
        return String.getString(string(forKey: UserDefaultKeys.kPassword))
    }
    
    func isSocialLogin() -> Bool {
        return bool(forKey: UserDefaultKeys.kIsSocialLogin)
    }
        
    func getSocialLoginType() -> String {
        return string(forKey: UserDefaultKeys.kAccountType) ?? "google"
    }
    
    func getSocialId() -> String {
        return string(forKey: UserDefaultKeys.kSocialId) ?? ""
    }
    
    func getUserType() -> Int {
        return integer(forKey: UserDefaultKeys.kuserType)
    }
    
    
    func isTradie() -> Bool {
        if let value = value(forKey: UserDefaultKeys.kuserType) as? Int, value == 1 {
            return true
        } else {
            return false
        }
    }
    
    func canPlayTutorial() -> Bool {
        return !bool(forKey: UserDefaultKeys.kTutorialPlayed)
    }
    
    func getDotCounts() -> Int {
        if integer(forKey: UserDefaultKeys.kuserType) == 1 {
            return 8
        }else {
            return 6
        }
    }
    
    func getMellbourneCoordinates() -> CLLocation {
        return CLLocation(latitude: -37.8136, longitude: 144.9631)
    }
    
    func getUserLatitude() -> Double {
        return double(forKey: UserDefaultKeys.kUserLatitude) == 0.0 ? -37.8136 : double(forKey: UserDefaultKeys.kUserLatitude)
    }
    
    func getSpecialization() -> [String] {
        return kUserDefaults.value(forKey: UserDefaultKeys.kSpecialization) as? [String] ?? []
    }
    
    func getUserLongitude() -> Double {
        return double(forKey: UserDefaultKeys.kUserLongitude) == 0.0 ? 144.9631 : double(forKey: UserDefaultKeys.kUserLongitude)
    }
}

enum UserDefaultKeys {
    static let kGender = "gender"
    static let kUserId = "userId"
    static let kAddress = "address"
    static let kUsername = "username"
    static let kPassword = "password"
    static let kLastName = "lastName"
    static let kuserType = "userType"
    static let kIsLoggedIn = "isLogin"
    static let kLoggedInEmail = "email"
    static let kFirstName = "name"
    static let kSocialId = "socialId"
    static let kAccountType = "accountType"
    static let kIsSocialLogin = "isSocialLogin"
    static let kFacebookId = "kFacebookId"
    static let kDescription = "description"
    static let kAccessToken = "accessToken"
    static let kTrade = "trade"
    static let kUserLatitude = "userLatitude"
    static let kUserLongitude = "userLongitude"
    static let kFirebaseLoggedIn = "firebaseLogin"
    static let kAccessTokenLinkedIn = "access_token"
    static let kDeviceToken = "deviceToken"
    static let kPhoneNumber = "phoneNumber"
    static let kProfileImage = "profileImage"
    static let kAccessTokenType = "accessTokenType"
    static let kSpecialization = "specialization"
    static let kTutorialPlayed = "tutorialPlay"
}

enum AccountType: String {
    case google, linkedIn, apple
}
