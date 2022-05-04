//
//  TradeModel.swift
//  Tickt
//
//  Created by S H U B H A M on 08/03/21.
//

import Foundation
import SwiftyJSON

struct TradeModel {
    var result: TradeData?
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
        result = TradeData.init(json["result"])
    }
}

struct TradeData {
    var trade: [TradeList]?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        trade = json["trade"].arrayValue.map({TradeList.init($0)})
    }
}

struct TradeList {
    let tradeImg: String?
    let status: Int
    let description: String?
    let sortBy: Int
    var id: String
    let tradeID: String?
    var isSelected: Bool = false
    let tradeName: String?
    let selectedUrl: String?
    let unselectedUrl: String?
    var qualifications: [SpecializationModel]?
    var specialisations: [SpecializationModel]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case description
        case tradeName = "trade_name"
        case qualifications, specialisations
        case selectedUrl = "selected_url"
        case unselectedUrl = "unselected_url"
        case tradeImg = "trade_img"
        case sortBy = "sort_by"
        case tradeID = "tradeId"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradeImg = json["trade_img"].stringValue
        status = json["status"].intValue
        description = json["description"].stringValue
        sortBy = json["sort_by"].intValue
        id = json["_id"].stringValue
        tradeID = json["tradeId"].stringValue
        isSelected = json["isSelected"].boolValue
        tradeName = json["trade_name"].stringValue
        selectedUrl = json["selected_url"].stringValue
        unselectedUrl = json["unselected_url"].stringValue
        qualifications = json["qualifications"].arrayValue.map({SpecializationModel.init($0)})
        specialisations = json["specialisations"].arrayValue.map({SpecializationModel.init($0)})
    }
    
}
