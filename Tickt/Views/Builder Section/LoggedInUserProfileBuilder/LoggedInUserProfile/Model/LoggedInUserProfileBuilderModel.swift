//
//  LoggedInUserProfileBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import Foundation

struct LoggedInUserProfileBuilderModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: LoggedInUserProfileResultModel
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct LoggedInUserProfileResultModel: Codable {
    var userId: String = ""
    var userImage: String = ""
    var userName: String = ""
    var ratings: Double = 0.0
    var reviews: Int = 0
    var userType: Int = 0
    var profileCompleted: String = ""
    var jobCompletedCount: Int = 0
}
