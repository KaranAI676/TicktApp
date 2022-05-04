//
//  SearchingBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 28/04/21.
//

import Foundation
import GoogleMaps
import SwiftyJSON

enum SortingType: String, CaseIterable {
    
    case highestRated = "Highest rated"
    case closestToMe = "Closest to me"
    case mostJobsCompleted = "Most jobs completed"
    
    var tagValue: Int {
        switch self {
        case .highestRated:
            return 1
        case .closestToMe:
            return 2
        case .mostJobsCompleted:
            return 3
        }
    }
}

struct SearchingModel {
    
    var message: String
    var status: Bool
    var statusCode: Int
    var result: RecommendedPeopleResult?
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = RecommendedPeopleResult.init(json["result"])
    }
}

struct RecommendedPeopleResult {
    var totalCount: Int
    var data: [RecommendedPeoples]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        totalCount = json["totalCount"].intValue
        data = json["data"].arrayValue.map({RecommendedPeoples.init($0)})
    }
}

struct SearchingContentsModel {
    
    var isFiltered: Bool = true
    var sortBy: SortingType? = .highestRated
    var category = SearchedResultData()
    var trade: TradeList?
    var location: JobLocation?
    var fromDate: MilestoneDates?
    var toDate: MilestoneDates?
    var totalSpecialisationCount: Int = 0
    var filterCount: Int = 0
}
