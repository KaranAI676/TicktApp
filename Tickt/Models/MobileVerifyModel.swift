//
//  MobileVerifyModel.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

struct MobileVerifyModel: Codable {
    let message: String
    let status: Bool
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case message, status
        case statusCode = "status_code"        
    }
}
