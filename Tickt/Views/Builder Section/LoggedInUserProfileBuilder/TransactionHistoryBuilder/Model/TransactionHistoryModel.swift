//
//  TransactionHistoryModel.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation
import SwiftyJSON

struct TransactionHistoryModel  {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: [TransactionHistoryResultModel]
    

    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = json["list"].arrayValue.map({TransactionHistoryResultModel.init($0)})
    }
}

struct TransactionHistoryResultModel {
    
    var totalEarnings: Double
    var totalJobs: Int
    var revenue: TransactionHistoryRevenueModel?
   
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        totalEarnings = json["totalEarnings"].doubleValue
        totalJobs = json["totalJobs"].intValue
        revenue = TransactionHistoryRevenueModel.init(json["revenue"])
    }
    
}

struct TransactionHistoryRevenueModel {
    var count: Int
    var revenueList: [TransactionHistoryRevenueListModel]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        count = json["count"].intValue
        revenueList = json["revenueList"].arrayValue.map({TransactionHistoryRevenueListModel.init($0)})
    }
}

struct TransactionHistoryRevenueListModel {
    
    var tradieId: String
    var fromDate: String
    var id: String
    var toDate: String?
    var urls: [PhotosObject]?
    var tradieName: String
    var jobName: String
    var earning: String
    var tradieImage: String
    var jobDescription: String
    var jobId: String
    var status: String
    var builderId: String
    
    init() {
        self.init(JSON([:]))
        tradieId = ""
        fromDate = ""
        id = ""
        toDate = ""
        urls = nil
        tradieName = ""
        jobName = ""
        earning = ""
        tradieImage = ""
        jobDescription = ""
        jobId = ""
        status = ""
        builderId = ""
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        fromDate = json["from_date"].stringValue
        id = json["_id"].stringValue
        toDate = json["to_date"].stringValue
        urls = json["urls"].arrayValue.map({PhotosObject.init($0)})
        tradieName = json["tradieName"].stringValue
        jobName = json["jobName"].stringValue
        earning = json["earning"].stringValue
        tradieImage = json["tradieImage"].stringValue
        jobDescription = json["job_description"].stringValue
        jobId = json["jobId"].stringValue
        status = json["status"].stringValue
        builderId = json["builderId"].stringValue
    }

}
