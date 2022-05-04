//
//  LinkedInModel.swift
//  Tickt
//
//  Created by Admin on 15/03/21.
//

import UIKit
import Foundation

struct LinkedInEmailModel: Codable {
    let elements: [LinkedElement]
}

struct LinkedElement: Codable {
    let elementHandle: Handle
    let handle: String

    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

struct Handle: Codable {
    let emailAddress: String
}

struct LinkedInModel: Codable {
    let id: String
    let firstName: LinkedInNameData?
    let lastName: LinkedInNameData?
    let profilePicture: LinkedInProfileData?
}

struct LinkedInNameData: Codable {
    let localized: LinkedInName?
}

struct LinkedInName: Codable {
    let en_US: String?
}

struct LinkedInProfileData: Codable {
    let displayImage: LinkedInProfileObject?
    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

struct LinkedInProfileObject: Codable {
    let elements: [LinkedInElement]?
}

struct LinkedInElement: Codable {
    let identifiers: [Identifier]?
}

struct Identifier: Codable {
    let identifier: String
}
