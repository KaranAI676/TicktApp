//
//  CheckApproveBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 17/05/21.
//

import Foundation

struct CheckApproveBuilderModel: Codable {
    
    var result: CheckApprovedResult
    var statusCode: Int
    var message: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct CheckApprovedResult: Codable {
    var jobId: String?
    var tradieId: String?
    var jobName: String?
    var tradie: CheckApprovedTradie?
    var milestones: [CheckApprovedMilestones]?
}

struct CheckApprovedTradie: Codable {
    
    var tradieName: String
    var tradieImage: String
    var reviews: Int
    var tradieId: String
    var ratings: Double
    
}

struct CheckApprovedMilestones: Codable {
    
    var fromDate: String = ""
    var toDate: String? = nil
    var milestoneId: String = ""
    var declinedCount: Int
    var status: Int = 0
    var milestoneName: String = ""
    var isPhotoevidence: Bool = false
    var isSelected: Bool? = false
    var recommendedHours: String = ""
    var statusButtonCanInteract: Bool? = false
    var order: Int
    var milestoneAmount: String?
    var taxes: String?
    var platformFees: String?
    var total: String?
    var hoursWorked: String?
    var hourlyRate: String?
    
}
