//
//  JobMilestoneData.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//

import Foundation
import SwiftyJSON

struct JobMilestoneModel {
    let statusCode: Int
    var result: MilestoneResult
    let message: String
    let status: Bool

    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = MilestoneResult.init(json["result"])
    }
}

struct MilestoneResult {
    let jobId: String
    let jobName: String
    let postedBy: PostedBy
    var milestones: [MilestoneData]?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        jobId = json["jobId"].stringValue
        jobName = json["jobName"].stringValue
        postedBy = PostedBy.init(json["PostedBy"])
        milestones =  json["milestones"].arrayValue.map({MilestoneData.init($0)})
    }

}

struct MilestoneData {
    let status: Int
    let amount: Double
    let declinedCount: Int
    let isPhotoevidence: Bool
    let declinedReason: DeclinedData?
    let fromDate, toDate: String?
    var isMilestoneSelected: Bool?
    let milestoneName, milestoneId: String
    let payType: String?
    
    enum CodingKeys: String, CodingKey {
        case milestoneName, toDate, milestoneId, isPhotoevidence, status, amount, fromDate, declinedReason, declinedCount
        case payType = "pay_type"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        status = json["status"].intValue
        amount = json["amount"].doubleValue
        declinedCount = json["declinedCount"].intValue
        isPhotoevidence = json["isPhotoevidence"].boolValue
        declinedReason = DeclinedData.init(json["declinedReason"])
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        isMilestoneSelected = json["isMilestoneSelected"].boolValue
        milestoneName = json["milestoneName"].stringValue
        milestoneId = json["milestoneId"].stringValue
        payType = json["payType"].stringValue
    }
}


struct DeclinedData {
    let url: [String]?
    let reason: String?
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        url = json["url"].arrayObject as? [String] ?? []
        reason = json["reason"].stringValue
    }
}

struct MilestoneObject {
    var jobId = ""
    var amount = 0.0
    var jobName = ""
    var milestoneId = ""
    var description = ""
    var actualHours = ""
    var totalAmount = 0.0
    var photo: [UIImage] = []
    var isPhotoEvidence = false
    var isLastMilestone = false
    var payType = PayType.perHour.rawValue
}
