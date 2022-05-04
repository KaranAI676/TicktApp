//
//  TradieProfilefromBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import Foundation
import SwiftyJSON

struct TradieProfilefromBuilderModel {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: TradieProfileResult
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = TradieProfileResult.init(json["result"])
    }
}

struct TradieProfileResult {
    var tradieId: String?
    var tradieImage: String?
    var tradieName: String
    var tradeName: String
    var businessName:String?
    var position: String
    var ratings: Double
    var reviewsCount: Int
    var jobCompletedCount: Int
    var areasOfSpecialization: AreasOfSpecialization
    var about: String
    var portfolio: [TradieProfilePortfolio]
    var jobCount: Int
    var reviewData: [TradieProfileReviewData]
    var vouchesData: [TradieProfileVouchesData]
    var isSaved: Bool?
    var isInvited: Bool?
    var invitationId: String?
    var isRequested: Bool?
    var voucherCount: Int?
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        tradieImage = json["tradieImage"].stringValue
        tradieName = json["tradieName"].stringValue
        tradeName = json["tradeName"].stringValue
        businessName = json["businessName"].stringValue
        position = json["position"].stringValue
        ratings = json["ratings"].doubleValue
        reviewsCount = json["reviewsCount"].intValue
        jobCompletedCount = json["jobCompletedCount"].intValue
        areasOfSpecialization = AreasOfSpecialization.init(json["areasOfSpecialization"])
        about = json["about"].stringValue
        jobCount = json["jobCount"].intValue
        portfolio =  json["portfolio"].arrayValue.map({TradieProfilePortfolio.init($0)})
        reviewData =  json["reviewData"].arrayValue.map({TradieProfileReviewData.init($0)})
        vouchesData =  json["vouchesData"].arrayValue.map({TradieProfileVouchesData.init($0)})
        isSaved = json["isSaved"].boolValue
        isInvited = json["isInvited"].boolValue
        invitationId = json["invitationId"].stringValue
        isRequested = json["isRequested"].boolValue
        voucherCount = json["voucherCount"].intValue
    }
}

struct AreasOfSpecialization {
    var specializationData: [SpecializationData]
    var tradeData: [TradeDataModel]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        specializationData = json["specializationData"].arrayValue.map({SpecializationData.init($0)})
        tradeData =  json["tradeData"].arrayValue.map({TradeDataModel.init($0)})
    }
}

struct TradeDataModel {
    var tradeId: String
    var tradeSelectedUrl: String
    var tradeName: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradeId = json["tradeId"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        tradeName = json["tradeName"].stringValue
    }
}

struct TradieProfilePortfolio {
    var jobName: String
    var jobDescription: String
    var portfolioId: String
    var portfolioImage: [String]    
    
    init() {
        self.init(JSON([:]))
        jobName = ""
        jobDescription = ""
        portfolioId = ""
        portfolioImage = []
    }
    
    init(_ model: PortfoliaData) {
        jobName = model.jobName
        jobDescription = model.jobDescription
        portfolioId = model.portfolioId
        portfolioImage = model.portfolioImage ?? []
    }
    
    init(_ json: JSON) {
        jobName = json["jobName"].stringValue
        jobDescription = json["jobDescription"].stringValue
        portfolioId = json["portfolioId"].stringValue
        portfolioImage = json["portfolioImage"].arrayObject as? [String] ?? []
    }
}

struct TradieProfileReviewData {
    var reviewSenderImage: String
    var reviewSenderId: String
    var reviewId: String?
    var reviewSenderName: String
    var date: String
    var ratings: Double
    var review: String
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        reviewSenderImage = json["reviewSenderImage"].stringValue
        reviewSenderId = json["reviewSenderId"].stringValue
        reviewId = json["reviewId"].stringValue
        reviewSenderName = json["reviewSenderName"].stringValue
        date = json["date"].stringValue
        ratings = json["ratings"].doubleValue
        review = json["review"].stringValue
    }
}

struct TradieProfileVouchesData {
    var builderId: String
    var builderName: String
    var builderImage: String
    var date: String
    var voucherId: String
    var jobId: String
    var jobName: String
    var tradieId: String
    var tradieName: String
    var vouchDescription: String
    var recommendation: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        builderId = json["builderId"].stringValue
        builderName = json["builderName"].stringValue
        builderImage = json["builderImage"].stringValue
        date = json["date"].stringValue
        voucherId = json["voucherId"].stringValue
        jobId = json["jobId"].stringValue
        jobName = json["jobName"].stringValue
        tradieId = json["tradieId"].stringValue
        tradieName = json["tradieName"].stringValue
        vouchDescription = json["vouchDescription"].stringValue
        recommendation = json["recommendation"].stringValue
    }
}
