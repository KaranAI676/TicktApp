//
//  TemplateListModel.swift
//  Tickt
//
//  Created by S H U B H A M on 02/04/21.
//

import Foundation

struct TemplateListModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: [TemplateListModelData]
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct  TemplateListModelData: Codable {
    
    var milestoneCount: Int
    var templateId: String
    var templateName: String
    
    
    enum CodingKeys: String, CodingKey {
        case templateId
        case milestoneCount
        case templateName
    }
}

struct MilestoneListModel: Codable {
    
    var status: Bool
    var result: MilestoneResultModel
    var statusCode: Int
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct MilestoneResultModel: Codable {
    
    var createdAt: String
    var tempId: String
    var milestones: [MilestonesModel]
    var templateName: String
}

struct MilestonesModel: Codable {
    
    var fromDate: String
    var milestoneId: String
    var toDate: String?
    var milestoneName: String
    var recommendedHours: String
    var order: Int
}
