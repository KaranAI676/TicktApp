//
//  LoginModel.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

import Foundation

struct LoginModel: Codable {
    let message: String
    let result: LoginData?
    let status: Bool
    let statusCode: Int?
        
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct LoginData: Codable {
    let id: String
    let email: String
    let token: String?
    let userType: Int?
    let trade: [String]?
    let firstName: String?
    let userImage: String?
    let userName: String?
    let mobileNumber: String?
    let accountType: String?
    let specialization: [String]?
    
    enum CodingKeys: String, CodingKey {
        case email, token, specialization, trade, userName
        case id = "_id"
        case userType = "user_type"
        case firstName = "firstName"
        case mobileNumber = "mobile_number"
        case accountType = "account_type"
        case userImage = "user_image"        
    }
}
