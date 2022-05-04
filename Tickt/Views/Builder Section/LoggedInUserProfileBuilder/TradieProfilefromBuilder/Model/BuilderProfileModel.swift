//
//  BuilderProfileModel.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import Foundation
import SwiftyJSON

struct BuilderProfileModel {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: BuilderProfileResult
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = BuilderProfileResult.init(json["result"])
    }
}

struct BuilderProfileResult {
    var jobCompletedCount: Int
    var totalJobPostedCount: Int
    var areasOfSpecialization: AreasOfSpecialization
    var aboutCompany: String?
    var userType: Int
    var position: String
    var jobCount: Int
    var ratings: Double
    var jobPostedData: [JobpostedDataModel]
    var portfolio: [PortfoliaData]
    var reviewData: [TradieProfileReviewData]
    var builderId: String
    var builderImage: String
    var builderName: String
    var reviewsCount: Int
    var companyName: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        jobCompletedCount = json["jobCompletedCount"].intValue
        totalJobPostedCount = json["totalJobPostedCount"].intValue
        areasOfSpecialization = AreasOfSpecialization.init(json["areasOfSpecialization"])
        aboutCompany = json["aboutCompany"].stringValue
        userType = json["userType"].intValue
        position = json["position"].stringValue
        jobCount = json["jobCount"].intValue
        ratings = json["ratings"].doubleValue
        jobPostedData =  json["jobPostedData"].arrayValue.map({JobpostedDataModel.init($0)})
        portfolio =  json["portfolio"].arrayValue.map({PortfoliaData.init($0)})
        reviewData =  json["reviewData"].arrayValue.map({TradieProfileReviewData.init($0)})
        builderId = json["builderId"].stringValue
        builderImage = json["builderImage"].stringValue
        builderName = json["builderName"].stringValue
        reviewsCount = json["reviewsCount"].intValue
        companyName = json["companyName"].stringValue
    }
}

struct JobpostedDataModel {
    
    var tradeName: String
    var locationName: String
    var questionsCount: Int
    var amount: String
    var time: String
    var specializationName: String
    var jobName: String
    var viewersCount: Int
    var jobDescription: String
    var jobId: String
    var durations: String
    var tradeSelectedUrl: String
    var jobStatus: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradeName = json["tradeName"].stringValue
        locationName = json["locationName"].stringValue
        questionsCount = json["questionsCount"].intValue
        amount = json["amount"].stringValue
        time = json["time"].stringValue
        specializationName = json["specializationName"].stringValue
        jobName = json["jobName"].stringValue
        viewersCount = json["viewersCount"].intValue
        jobDescription = json["jobDescription"].stringValue
        jobId = json["jobId"].stringValue
        durations = json["durations"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        jobStatus = json["jobStatus"].stringValue
    }
}
