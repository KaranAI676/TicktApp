//
//  BuilderHomeModel.swift
//  Tickt
//
//  Created by S H U B H A M on 19/04/21.
//

import Foundation
import SwiftyJSON

struct BuilderHomeModel {
    
    //MARK:- Variables
    var statusCode: Int
    var message: String
    var status: Bool
    var result: BuilderModelResult
    ///
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = BuilderModelResult.init(json["result"])
    }
}

struct BuilderModelResult {
    
    //MARK:- Variables
    var userType: Int
    var unreadCount: Int
    var savedTradespeople: [SavedTradies]
    var recomendedTradespeople: [RecommendedPeoples]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        userType = json["user_type"].intValue
        unreadCount = json["unreadCount"].intValue
        savedTradespeople = json["saved_tradespeople"].arrayValue.map({SavedTradies.init($0)})
        recomendedTradespeople = json["recomended_tradespeople"].arrayValue.map({RecommendedPeoples.init($0)})
    }
}

struct PopularTradesPeople {
    
    //MARK:- Variables
    var userImage: String?
    var trade: String?
    var userName: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        userImage = json["userImage"].stringValue
        trade = json["trade"].stringValue
        userName = json["userName"].stringValue
    }
}

struct SavedTradies {
    
    //MARK:- Variables
    var tradieId: String
    var tradieImage: String?
    var tradieName: String
    var businessName: String
    var ratings: Double
    var reviews: Int
    var tradeData: [BuilderHomeTradeData]
    var specializationData: [BuilderHomeSpecialisation]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        tradieImage = json["tradieImage"].stringValue
        tradieName = json["tradieName"].stringValue
        businessName = json["businessName"].stringValue
        ratings = json["ratings"].doubleValue
        reviews = json["reviews"].intValue
        tradeData = json["tradeData"].arrayValue.map({BuilderHomeTradeData.init($0)})
        specializationData = json["specializationData"].arrayValue.map({BuilderHomeSpecialisation.init($0)})
    }
    
    init(tradieId: String, tradieImage: String, tradieName: String, businessName: String, ratings: Double, reviews: Int, tradeData: [BuilderHomeTradeData], specializationData: [BuilderHomeSpecialisation]) {
        self.tradieId = tradieId
        self.tradieImage = tradieImage
        self.tradieName = tradieName
        self.ratings = ratings
        self.reviews = reviews
        self.tradeData = tradeData
        self.specializationData = specializationData
        self.businessName = businessName
    }
}

struct RecommendedPeoples {
    
    //MARK:- Variables
    var reviews: Int
    var ratings: Double
    var tradieId: String
    var tradieName: String
    var businessName : String
    var tradieImage: String?
    var tradeData: [BuilderHomeTradeData]
    var specializationData: [BuilderHomeSpecialisation]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        tradieImage = json["tradieImage"].stringValue
        tradieName = json["tradieName"].stringValue
        businessName = json["businessName"].stringValue
        ratings = json["ratings"].doubleValue
        reviews = json["reviews"].intValue
        tradeData = json["tradeData"].arrayValue.map({BuilderHomeTradeData.init($0)})
        specializationData = json["specializationData"].arrayValue.map({BuilderHomeSpecialisation.init($0)})
    }
}

struct MostViewedTradespeople {
    
    //MARK:- Variables
    var ratings: Double
    var reviews: Int
    var tradieId: String
    var tradeData: [BuilderHomeTradeData]
    var tradieImage: String?
    var userType: Int
    var tradieName: String
    var specializationData: [BuilderHomeSpecialisation]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        tradieImage = json["tradieImage"].stringValue
        tradieName = json["tradieName"].stringValue
        userType = json["userType"].intValue
        ratings = json["ratings"].doubleValue
        reviews = json["reviews"].intValue
        tradeData = json["tradeData"].arrayValue.map({BuilderHomeTradeData.init($0)})
        specializationData = json["specializationData"].arrayValue.map({BuilderHomeSpecialisation.init($0)})
    }
}

struct BuilderHomeTradeData {
    
    //MARK:- Variables
    var tradeId: String
    var tradeName: String
    var tradeSelectedUrl: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradeId = json["tradeId"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        tradeName = json["tradeName"].stringValue
    }
    
    init(tradeId: String, tradeName: String, tradeSelectedUrl: String) {
        self.tradeId = tradeId
        self.tradeName = tradeName
        self.tradeSelectedUrl = tradeSelectedUrl
    }
    
    init(_ model: TradeDataModel)  {
        self.tradeId = model.tradeId
        self.tradeName = model.tradeName
        self.tradeSelectedUrl = model.tradeSelectedUrl
    }
}

struct BuilderHomeSpecialisation {
    
    //MARK:- Variables
    var specializationName: String
    var specializationId: String
    
    init(name: String, id: String = "") {
        specializationName = name
        specializationId = id
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        specializationName = json["specializationName"].stringValue
        specializationId = json["specializationId"].stringValue
    }
}

