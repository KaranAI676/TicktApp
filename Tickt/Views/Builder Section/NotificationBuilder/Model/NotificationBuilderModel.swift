//
//  NotificationBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 18/07/21.
//

import Foundation
import SwiftyJSON

struct NotificationModel {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: NotificationResultModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = NotificationResultModel.init(json["result"])
    }
}

struct NotificationResultModel {
    
    var count: Int
    var list: [NotificationListingModel]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        count = json["count"].intValue
        list =  json["list"].arrayValue.map({NotificationListingModel.init($0)})
    }
}

struct NotificationListingModel {
    
    var createdAt: String?
    var updatedAt: String?
    var read: Int?
    var subTitle: String?
    var id: String?
    var notificationType: Int?
    var title: String?
    var image: String?
    var isSent: Int?
    var othersId: String?
    var myId: String?
    var notificationText: String?
    var isFailed: Int?
    var jobId: String?
    var status: Int?
    var userType: Int?
    var extraData: NotificationExtraDataModel?
    
    
    init() {
        self.init(JSON([:]))
    }
    
    
    init(_ json: JSON) {
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        read = json["read"].intValue
        subTitle = json["sub_title"].stringValue
        id = json["_id"].stringValue
        notificationType = json["notificationType"].intValue
        title = json["title"].stringValue
        image = json["image"].stringValue
        isSent = json["isSent"].intValue
        othersId = json["senderId"].stringValue
        myId = json["receiverId"].stringValue
        notificationText = json["notificationText"].stringValue
        isFailed = json["isFailed"].intValue
        notificationText = json["notificationText"].stringValue
        status = json["status"].intValue
        userType = json["user_type"].intValue
        extraData = NotificationExtraDataModel.init(json["extra_data"])
    }
}

struct NotificationExtraDataModel {
    var redirectStatus: Int?
    var jobStatusInt: Int?
    var jobStatusText: String?
    var tradieId: String?
    var jobName: String?
    var tradeName: String?
    var jobDesc: String?
    var fromDate: String?
    var toDate: String?
    var tradeImage: String?
    var quoteCount: Int?
    var tradieName: String?
    var rating: Double?
    var reviewCount: Int?
    var tradieImage: String?
    var builderImage: String?
    var builderName: String?
    var jobDescription: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    
    init(_ json: JSON) {
        redirectStatus = json["redirect_status"].intValue
        jobStatusInt = json["jobStatusInt"].intValue
        jobStatusText = json["jobStatusText"].stringValue
        tradieId = json["tradieId"].stringValue
        jobName = json["jobName"].stringValue
        tradeName = json["tradeName"].stringValue
        jobDesc = json["jobDesc"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        tradeImage = json["tradeImage"].stringValue
        quoteCount = json["quoteCount"].intValue
        tradieName = json["tradieName"].stringValue
        rating = json["rating"].doubleValue
        reviewCount = json["reviewCount"].intValue
        tradieImage = json["tradieImage"].stringValue
        builderImage = json["builderImage"].stringValue
        builderName = json["builderName"].stringValue
        jobDescription = json["jobDescription"].stringValue
    }
}
