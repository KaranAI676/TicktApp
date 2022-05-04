//
//  RevenueDetailModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation
import SwiftyJSON

struct RevenueDetailModel {
    
    let status: Bool
    let statusCode: Int
    let message: String
    let result: RevenueDetaiResult

    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = RevenueDetaiResult.init(json["result"])
    }
    
}

struct RevenueDetaiResult {
    
    let tradieId, fromDate: String
    let milestones: [Milestone]
    let id: String
    let urls: [PhotosObject]
    let builderName: String
    let builderImage: String
    let totalEarning, jobName, jobDescription, jobId: String
    let status, builderId: String
    let toDate: String?

    enum CodingKeys: String, CodingKey {
        case tradieId = "tradieId"
        case fromDate = "from_date"
        case milestones
        case id = "_id"
        case toDate = "to_date"
        case urls, builderName, builderImage, totalEarning, jobName
        case jobDescription = "job_description"
        case jobId = "jobId"
        case status
        case builderId = "builderId"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        fromDate = json["from_date"].stringValue
        id = json["_id"].stringValue
        milestones = json["milestones"].arrayValue.map({Milestone.init($0)})
        urls = json["urls"].arrayValue.map({PhotosObject.init($0)})
        builderName = json["builderName"].stringValue
        builderImage = json["builderImage"].stringValue
        totalEarning = json["totalEarning"].stringValue
        jobName = json["jobName"].stringValue
        jobDescription = json["job_description"].stringValue
        jobId = json["jobId"].stringValue
        status = json["status"].stringValue
        builderId = json["builderId"].stringValue
        toDate = json["to_date"].stringValue
    }
}

struct Milestone {
    let order: Int
    let declinedCount: Int
    let status, id: String
    let actualHours: String?
    let milestoneName: String
    let isPhotoevidence: Bool?
    let milestoneAmount: Double?
    let completedAt, toDate: String?
    let milestoneEarning, fromDate: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case order
        case id = "_id"
        case actualHours = "actual_hours"
        case milestoneAmount
        case toDate = "to_date"
        case fromDate = "from_date"
        case milestoneEarning, completedAt
        case milestoneName = "milestone_name"
        case declinedCount = "declined_count"
        case isPhotoevidence = "is_photoevidence"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        order = json["order"].intValue
        declinedCount = json["declined_count"].intValue
        status = json["status"].stringValue
        id = json["_id"].stringValue
        actualHours = json["actual_hours"].stringValue
        milestoneName = json["milestone_name"].stringValue
        isPhotoevidence = json["is_photoevidence"].boolValue
        milestoneAmount = json["milestoneAmount"].doubleValue
        completedAt = json["completedAt"].stringValue
        toDate = json["to_date"].stringValue
        milestoneEarning = json["milestoneEarning"].stringValue
        fromDate = json["from_date"].stringValue
    }
}
