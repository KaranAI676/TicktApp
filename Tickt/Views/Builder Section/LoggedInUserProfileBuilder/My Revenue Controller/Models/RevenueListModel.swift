//
//  RevenueListModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation
import SwiftyJSON

struct RevenueListModel {
    let status: Bool
    let message: String
    let result: [RevenueListResult]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        status = json["status"].boolValue
        message = json["message"].stringValue
        result = json["result"].arrayValue.map({RevenueListResult.init($0)})
    }
}

struct RevenueListResult {
    let totalJobs: Int
    let revenue: RevenueList?
    let totalEarnings: Double
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        totalJobs = json["totalJobs"].intValue
        totalEarnings = json["totalEarnings"].doubleValue
        revenue = RevenueList.init(json["revenue"])
    }
}

struct RevenueList {
    let count: Int
    let revenueList: [RevenueListData]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        count = json["count"].intValue
        revenueList = json["revenueList"].arrayValue.map({RevenueListData.init($0)})
    }
}

struct RevenueListData {
    
    let tradieId: String?
    let fromDate, id: String?
    let toDate: String?
    let urls: [PhotosObject]?
    let builderName: String?
    let builderImage: String?
    let jobName, earning, jobDescription, jobId: String?
    let status: String?
    let builderId: String?

    enum CodingKeys: String, CodingKey {
        case tradieId = "tradieId"
        case fromDate = "from_date"
        case id = "_id"
        case toDate = "to_date"
        case urls, builderName, builderImage, jobName, earning
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
        toDate = json["to_date"].stringValue
        id = json["_id"].stringValue
        urls = json["urls"].arrayValue.map({PhotosObject.init($0)})
        builderName = json["builderName"].stringValue
        builderImage = json["builderImage"].stringValue
        jobName = json["jobName"].stringValue
        earning = json["earning"].stringValue
        jobDescription = json["job_description"].stringValue
        jobId = json["jobId"].stringValue
        status = json["status"].stringValue
        builderId = json["builderId"].stringValue
    }
}
