//
//  PaymentDetailBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 09/07/21.
//

import Foundation

struct ApproveDeclineMilestoneModel {
    
    var jobId = ""
    var jobName = ""
    var tradieId = ""
    var paymentMethods = ""
    var milestoneData = PaymentDetailBuilderModel()
    
    init() {}
    
    init(jobId: String, jobName: String, tradieId: String, milestoneData: PaymentDetailBuilderModel) {
        self.jobId = jobId
        self.jobName = jobName
        self.tradieId = tradieId
        self.paymentMethods = ""
        self.milestoneData = milestoneData
    }
}

struct PaymentDetailBuilderModel {
    
    var milestoneId: String = ""
    var milestoneName: String = ""
    var milestoneStatus: MilestoneStatus = .notComplete
    var milestoneAmount: String = ""
    var taxes: String = ""
    var platformFees: String = ""
    var total: String = ""
    var hoursWorked: String = ""
    var hourlyRate: String = ""
    
    init() {}
    
    init(milestoneId: String?, milestoneName: String, milestoneStatus: MilestoneStatus, milestoneAmount: String?, taxes: String?, platformFees: String?, total: String?, hoursWorked: String?, hourlyRate: String?) {
        self.milestoneId = milestoneId ?? ""
        self.milestoneName = milestoneName
        self.milestoneStatus = milestoneStatus
        self.milestoneAmount = milestoneAmount ?? ""
        self.taxes = taxes ?? ""
        self.platformFees = platformFees ?? ""
        self.total = total ?? ""
        self.hoursWorked = hoursWorked ?? ""
        self.hourlyRate = hourlyRate ?? ""
    }
}


//MARK:- RecentCard
struct RecentCardModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: CardListResultModel
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}
