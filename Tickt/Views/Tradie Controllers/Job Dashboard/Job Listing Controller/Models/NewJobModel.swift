//
//  NewJobModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//

import Foundation
import SwiftyJSON

struct NewJobModel {
    let message: String
    let statusCode: Int
    let status: Bool
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

struct ApprovedMilestone {
    let message: String
    let statusCode: Int
    let status: Bool
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
