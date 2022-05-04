//
//  BankModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//

import Foundation

struct BankModel: Codable {
    let message: String
    let statusCode: Int
    let status: Bool
    let result: BankDetail
    
    enum CodingKeys: String, CodingKey {
        case message, status, result
        case statusCode = "status_code"
    }
}

struct BankDetail: Codable {
    
    var bsbNumber, accountName, accountNumber, userId, stripeAccountId: String?
    let accountVerified:Bool?

    enum CodingKeys: String, CodingKey {
        case userId
        case bsbNumber = "bsb_number"
        case accountName = "account_name"
        case accountNumber = "account_number"
        case stripeAccountId = "stripeAccountId"
        case accountVerified = "accountVerified"
    }
    
    mutating func resetData() {
        userId = nil
        bsbNumber = nil
        accountName = nil
        accountNumber = nil
        stripeAccountId = nil
    }
}

struct CompleteMilestone: Codable {
    let message: String
    let statusCode: Int
    let status: Bool
    let result: CompleteMilestoneDetail
    
    enum CodingKeys: String, CodingKey {
        case message, status, result
        case statusCode = "status_code"
    }
}

struct CompleteMilestoneDetail: Codable {
    let jobCompletedCount: Int
}
