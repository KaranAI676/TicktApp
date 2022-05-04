//
//  NeedApprovalModel.swift
//  Tickt
//
//  Created by S H U B H A M on 16/05/21.
//

import Foundation

struct NeedApprovalBuilderModel: Codable {
    
    var result: [NeedApprovalModeResult]
    var statusCode: Int
    var message: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct NeedApprovalModeResult: Codable {
    
    var fromDate: String
    var jobName: String?
    var tradeName: String
    var locationName: String
    var timeLeft: String
    var totalMilestones: Int
    var toDate: String?
    var amount: String
    var status: String
    var total: String
    var specializationName: String
    var duration: String
    var jobId: String
    var tradeSelectedUrl: String
    var milestoneNumber: Int
    var needApproval: Bool?
    
    init() {
        fromDate = ""
        jobName = ""
        tradeName = ""
        locationName = ""
        timeLeft = ""
        totalMilestones = 0
        toDate = ""
        amount = ""
        status = ""
        total = ""
        specializationName = ""
        duration = ""
        jobId = ""
        tradeSelectedUrl = ""
        milestoneNumber = 0
        needApproval = false
    }
}
