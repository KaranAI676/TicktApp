//
//  AppliedModel.swift
//  Tickt
//
//  Created by Admin on 13/05/21.
//

import SwiftyJSON


struct AppliedModel {
    var result: AppliedData
    let status: Bool
    let statusCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case result, status, message
        case statusCode = "status_code"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = AppliedData.init(json["result"])
    }
}

struct AppliedData {
    var applied: [RecommmendedJob]
    var milestonesCount, newJobsCount: Int
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        milestonesCount = json["milestonesCount"].intValue
        newJobsCount = json["newJobsCount"].intValue
        applied = json["applied"].arrayValue.map({RecommmendedJob.init($0)})
    }
    
}

struct Applied {
    
    let durations, tradeName, locationName: String
    let milestoneNumber, totalMilestones: Int
    let amount, time, specializationName, jobName: String
    let tradeId, jobId, specializationId: String
    let tradeSelectedUrl: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        durations = json["durations"].stringValue
        tradeName = json["tradeName"].stringValue
        locationName = json["locationName"].stringValue
        milestoneNumber = json["milestoneNumber"].intValue
        totalMilestones = json["totalMilestones"].intValue
        amount = json["amount"].stringValue
        time = json["time"].stringValue
        specializationName = json["specializationName"].stringValue
        jobName = json["jobName"].stringValue
        tradeId = json["tradeId"].stringValue
        jobId = json["jobId"].stringValue
        specializationId = json["specializationId"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
    }
}

