//
//  QuotesModel.swift
//  Tickt
//
//  Created by Admin on 15/09/21.
//

import Foundation
import SwiftyJSON

struct QuotesModel {
    var result: QuoteData?
    let message: String
    let status: Bool
    let statusCode: Int
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = QuoteData.init(json["result"])
    }
}

struct QuoteData {
    let resultData: [QuoteList]
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        resultData = json["resultData"].arrayValue.map({QuoteList.init($0)})
    }
}

struct QuoteList {
    
    let Id: String
    let amount: String
    let status: String
    let jobId: String
    let userId: String
    let updatedAt: String
    let createdAt: String
    let quoteItem: [QuoteItem]?
    let jobName: String
    let tradeName: String?
    let fromDate: String?
    let toDate: String?
    let locationName: String?
    let duration: String?
    let selectedUrl: String?
    let tradieName: String?
    let tradieImage: String?
    let rating: Double
    let reviewCount: Int
    let totalQuoteAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case Id = "_id"
        case amount = "amount"
        case status = "status"
        case jobId = "jobId"
        case userId = "userId"
        case updatedAt = "updatedAt"
        case createdAt = "createdAt"
        case quoteItem = "quote_item"
        case jobName = "jobName"
        case tradeName = "trade_name"
        case fromDate = "from_date"
        case toDate = "to_date"
        case locationName = "location_name"
        case duration = "duration"
        case selectedUrl = "selected_url"
        case tradieName = "tradieName"
        case tradieImage = "tradieImage"
        case rating = "rating"
        case reviewCount = "reviewCount"
        case totalQuoteAmount = "totalQuoteAmount"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        Id = json["_id"].stringValue
        amount = json["amount"].stringValue
        status = json["status"].stringValue
        jobId =  json["jobId"].stringValue
        userId = json["userId"].stringValue
        updatedAt = json["updatedAt"].stringValue
        createdAt = json["createdAt"].stringValue
        quoteItem = json["quote_item"].arrayValue.map({QuoteItem.init($0)})
        jobName = json["jobName"].stringValue
        tradeName = json["trade_name"].stringValue
        fromDate = json["from_date"].stringValue
        toDate =  json["to_date"].stringValue
        locationName = json["location_name"].stringValue
        duration = json["duration"].stringValue
        selectedUrl = json["selected_url"].stringValue
        tradieName =  json["tradieName"].stringValue
        tradieImage = json["tradieImage"].stringValue
        rating = json["rating"].doubleValue
        reviewCount =  json["reviewCount"].intValue
        totalQuoteAmount = json["totalQuoteAmount"].intValue
    }
}

struct QuoteItem {

    let Id: String
    let description: String
    let price: Double
    let quantity: Int
    let totalAmount: Int
    let status: Int
    let itemNumber: Int
    let quoteId: String

     enum CodingKeys: String, CodingKey {
        case Id = "_id"
        case description = "description"
        case price = "price"
        case quantity = "quantity"
        case totalAmount = "totalAmount"
        case status = "status"
        case itemNumber = "item_number"
        case quoteId = "quoteId"        
    }
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        Id = json["_id"].stringValue
        description = json["description"].stringValue
        price = json["price"].doubleValue
        quantity = json["quantity"].intValue
        totalAmount = json["totalAmount"].intValue
        status = json["status   "].intValue
        itemNumber = json["item_number"].intValue
        quoteId = json["quoteId"].stringValue
    }
}

struct RepublishQuoteJobModel {
    
    var statusCode: Int
    var message: String
    var status: Bool
    var result: RepublishjobData
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = RepublishjobData.init(json["result"])
    }
}

struct RepublishjobData {
    let resultData: RepublishJobResult
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        resultData = RepublishJobResult.init(json["resultData"])
    }
}
