//
//  ProfileModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 25/05/21.
//

import SwiftyJSON

struct ProfileModel {
    let result: ProfileResult?
    let statusCode: Int
    let status: Bool
    let message: String

    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = ProfileResult.init(json["result"])
    }
}

struct ProfileResult {
    let ratings: Double
    let jobCount: Int
    let about: String?
    let aboutCompany: String?
    let position: String
    let builderId: String
    let reviewsCount: Int
    let companyName: String
    let builderName: String
    let builderImage: String
    let jobCompletedCount: Int
    let totalJobPostedCount: Int
    let reviewData: [ReviewData]?
    let areasOfjobs: [AreasOfjob]?
    var portfolio: [PortfoliaData]?
    let jobPostedData: [RecommmendedJob]?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        ratings = json["ratings"].doubleValue
        jobCount = json["jobCount"].intValue
        about = json["about"].stringValue
        aboutCompany = json["aboutCompany"].stringValue
        position = json["position"].stringValue
        builderId = json["builderId"].stringValue
        reviewsCount = json["reviewsCount"].intValue
        companyName = json["companyName"].stringValue
        builderName =  json["builderName"].stringValue
        builderImage =  json["builderImage"].stringValue
        jobCompletedCount = json["jobCompletedCount"].intValue
        totalJobPostedCount = json["totalJobPostedCount"].intValue
        reviewData =  json["reviewData"].arrayValue.map({ReviewData.init($0)})
        areasOfjobs =  json["areasOfjobs"].arrayValue.map({AreasOfjob.init($0)})
        portfolio =  json["portfolio"].arrayValue.map({PortfoliaData.init($0)})
        jobPostedData =  json["jobPostedData"].arrayValue.map({RecommmendedJob.init($0)})
    }
}

struct PortfoliaData: Codable {
    var jobName: String
    var portfolioId: String
    var jobDescription: String
    var portfolioImage: [String]?
    
    init() {
        self.init(JSON([:]))
        jobName = ""
        portfolioId = ""
        jobDescription = ""
        portfolioImage = []
    }
    
    init(jobName: String, portfolioId: String, description: String, imagesUrls: [String]) {
        self.jobName = jobName
        self.portfolioId = portfolioId
        jobDescription = description
        portfolioImage = imagesUrls
    }
    
    init(_ json: JSON) {
        jobName = json["jobName"].stringValue
        portfolioId = json["portfolioId"].stringValue
        jobDescription = json["jobDescription"].stringValue
        portfolioImage = json["portfolioImage"].arrayObject as? [String] ?? []
    }
    
}

struct ReviewData {
    let date: String
    let review: String
    let ratings: Double
    let reviewSenderId: String
    let reviewSenderName: String
    let reviewSenderImage: String
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        date = json["date"].stringValue
        review = json["review"].stringValue
        ratings = json["ratings"].doubleValue
        reviewSenderId = json["reviewSenderId"].stringValue
        reviewSenderName = json["reviewSenderName"].stringValue
        reviewSenderImage = json["reviewSenderImage"].stringValue
       
    }
}

struct AreasOfjob {
    let specializationName, specializationId: String
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        specializationName = json["specializationName"].stringValue
        specializationId = json["specializationId"].stringValue
    }
}

struct JobPostedData {
    let tradeId: String
    let viewersCount: Int
    let questionsCount: Int
    let tradeSelectedUrl: String
    let durations, tradeName, locationName: String
    let amount, time, specializationName, jobName: String
    let jobDescription, jobId, specializationId: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradeId = json["tradeId"].stringValue
        viewersCount = json["viewersCount"].intValue
        questionsCount = json["questionsCount"].intValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        durations = json["durations"].stringValue
        tradeName = json["tradeName"].stringValue
        locationName = json["locationName"].stringValue
        amount = json["amount"].stringValue
        time = json["time"].stringValue
        specializationName = json["specializationName"].stringValue
        jobName = json["jobName"].stringValue
        jobDescription = json["jobDescription"].stringValue
        jobId = json["jobId"].stringValue
        specializationId = json["specializationId"].stringValue
       
    }
}


