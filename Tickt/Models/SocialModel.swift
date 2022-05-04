//
//  SocialModel.swift
//  Tickt
//
//  Created by Admin on 12/03/21.
//

import Foundation

struct SocialModel: Codable {
    var result: SocialData?
    let message: String
    let status: Bool
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case message, result
    }
}

struct SocialData: Codable {
    var isProfileCompleted: Bool?
}
