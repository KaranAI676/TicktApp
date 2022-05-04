//
//  MyRevenueBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import Foundation
import SwiftyJSON

struct MyRevenueBuilderModel {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: MyRevenueBuilderResultModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = MyRevenueBuilderResultModel.init(json["result"])
    }
}

struct MyRevenueBuilderResultModel {
    var tradieId: String
    var from_date: String
    var milestones: [MyRevenueBuilderMilestone]
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        from_date = json["from_date"].stringValue
        milestones = json["milestones"].arrayValue.map({MyRevenueBuilderMilestone.init($0)})
    }
}

struct MyRevenueBuilderMilestone {
    var status: String
    var id: String
    var actualHours: String?
    var order: Int
    var toDate: String?
    var milestoneName: String
    var declinedCount: Int
    var milestoneEarning: String
    var completedAt: String?
    var fromDate: String
    
    enum CodingKeys: String, CodingKey {
        case status, order, milestoneEarning, completedAt
        case id = "_id"
        case actualHours = "actual_hours"
        case milestoneName = "milestone_name"
        case declinedCount = "declined_count"
        case fromDate = "from_date"
        case toDate = "to_date"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    
    init(_ json: JSON) {
        status = json["status"].stringValue
        id = json["_id"].stringValue
        actualHours = json["actual_hours"].stringValue
        order = json["order"].intValue
        toDate = json["to_date"].stringValue
        milestoneName = json["milestone_name"].stringValue
        declinedCount = json["declined_count"].intValue
        milestoneEarning = json["milestoneEarning"].stringValue
        completedAt = json["completedAt"].stringValue
        fromDate = json["from_date"].stringValue
    }
}
