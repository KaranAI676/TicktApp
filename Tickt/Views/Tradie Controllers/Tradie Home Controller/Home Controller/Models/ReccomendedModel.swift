//
//  ReccomendedModel.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import Foundation
import SwiftyJSON

struct RecommmendedJobModel {
    let message: String
    let statusCode: Int
    let status: Bool
    var result: RecommmendedJobData?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = RecommmendedJobData.init(json["result"])
    }
}

struct RecommmendedJobData {
    var recomendedJobs: [RecommmendedJob]?
    var unreadCount: Int?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        unreadCount = json["unreadCount"].intValue
        recomendedJobs = json["recomended_jobs"].arrayValue.map({RecommmendedJob.init($0)})
    }
}

struct RecommmendedJob {
    var quoteJob: Bool?
    var amount: String?
    var jobId: String?
    var time: String?
    var isRated: Bool?
    var tradeSelectedUrl: String?
    var jobDescription: String?
    var specializationName: String?
    var tradeId: String?
    var specializationId: String?
    var jobName: String?
    var tradeName: String?
    var questionsCount: Int?
    var locationName: String?
    var distance: Double?
    var viewersCount: Int?
    var userImage: String?
    var durations: String?
    var location_name: String?
    var location: LocationData?
    var milestoneNumber: Int?
    var totalMilestones: Int?
    var jobStatus: String?
    var toDate: String?
    var status: String?
    var timeLeft: String?
    var fromDate: String?
    var builderData: BuilderData?
    var builderId: String?
    var builderName: String?
    var builderImage: String?
    
    init() {
        self.init(JSON([:]))
        quoteJob = false
        amount = nil
        jobId = nil
        time = nil
        isRated = nil
        tradeSelectedUrl = nil
        jobDescription = nil
        specializationName = nil
        tradeId = nil
        specializationId = nil
        jobName = nil
        tradeName = nil
        questionsCount = nil
        locationName = nil
        distance = nil
        viewersCount = nil
        userImage = nil
        durations = nil
        location_name = nil
        location = nil
        milestoneNumber = nil
        totalMilestones = nil
        jobStatus = nil
        toDate = nil
        status = nil
        timeLeft = nil
        fromDate = nil
        builderData = nil
        builderName = nil
        builderImage = nil
        builderId = nil
    }
    
    
    init(_ json: JSON) {
        quoteJob = json["quoteJob"].boolValue
        amount = json["amount"].stringValue
        jobId = json["jobId"].stringValue
        time = json["time"].stringValue
        isRated = json["isRated"].boolValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        jobDescription = json["jobDescription"].stringValue
        specializationName = json["specializationName"].stringValue
        tradeId = json["tradeId"].stringValue
        specializationId = json["specializationId"].stringValue
        jobName = json["jobName"].stringValue
        tradeName = json["tradeName"].stringValue
        questionsCount = json["questionsCount"].intValue
        locationName = json["locationName"].stringValue
        location = LocationData.init(json["location"])
        distance = json["distance"].doubleValue
        viewersCount = json["viewersCount"].intValue
        userImage = json["userImage"].stringValue
        durations = json["durations"].stringValue
        location_name = json["location_name"].stringValue
        milestoneNumber = json["milestoneNumber"].intValue
        totalMilestones = json["totalMilestones"].intValue
        jobStatus = json["jobStatus"].stringValue
        toDate = json["toDate"].stringValue
        status = json["status"].stringValue
        timeLeft = json["timeLeft"].stringValue
        fromDate = json["fromDate"].stringValue
        builderData = BuilderData.init(json["builderData"])
        builderId = json["builderId"].stringValue
        builderName = json["builderName"].stringValue
        builderImage = json["builderImage"].stringValue
    }
}

struct BuilderData {
    var builderId: String?
    var builderImage: String?
    var jobDescription: String?
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        builderId = json["builderId"].stringValue
        builderImage = json["builderImage"].stringValue
        jobDescription = json["jobDescription"].stringValue
    }
}

struct LocationData {
    let type: String
    let coordinates: [Double]?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        type = json["type"].stringValue
        coordinates = json["coordinates"].arrayObject as? [Double] ?? []
    }
}


