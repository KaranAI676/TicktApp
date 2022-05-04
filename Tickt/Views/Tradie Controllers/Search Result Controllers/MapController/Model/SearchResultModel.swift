//
//  SearchResultModel.swift
//  Tickt
//
//  Created by Admin on 18/04/21.
//

import CoreLocation
import SwiftyJSON

struct SearchResultModel {
    var message: String
    var statusCode: Int
    var status: Bool
    var result: [RecommmendedJob]?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = json["result"].arrayValue.map({RecommmendedJob.init($0)})
    }
}

struct FilterData {
    var price = ""
    var payType = ""
    var trade: TradeList?
    var locationName = ""
    var isSliderMoved = false
    var minimumPrice: Float = 1
    var jobType = JobTypeModel()
    var isFiltered: Bool = false
    var cordinates: [Double] = []
    var maximumPrice: Float = 1000
    var isAllSubCatSelected: Bool = false
    var isOnlyTradeSelected: Bool = false
    var sortBy: SortingType? = .highestRated
    
    mutating func resetData() {
        price = ""
        cordinates = []
        locationName = ""
        isFiltered = true
        minimumPrice = 1
        maximumPrice = 1000
        sortBy = .highestRated
        isAllSubCatSelected = false
        isOnlyTradeSelected = false
        payType = PayType.perHour.rawValue
    }
}
