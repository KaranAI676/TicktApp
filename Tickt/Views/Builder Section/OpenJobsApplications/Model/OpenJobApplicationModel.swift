//
//  OpenJobApplicationModel.swift
//  Tickt
//
//  Created by S H U B H A M on 23/05/21.
//

import Foundation

struct OpenJobApplicationModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: [OpenJobApplicationResult]
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct OpenJobApplicationResult: Codable {
    
    var status: String
    var ratings: Double
    var reviews: Int
    var tradieId: String
    var tradeData: [OpenJobApplicationTradeData]
    var specializationData: [AreasOfSpecializationOpenJob]
    var tradieImage: String
    var tradieName: String
}

struct AreasOfSpecializationOpenJob: Codable {
    
    var specializationId: String
    var specializationName: String
}

struct OpenJobApplicationTradeData: Codable {
    
    var tradeId: String
    var tradeSelectedUrl: String
    var tradeName: String
}

struct OpenJobApplicationSpecData: Codable {
    
}
