//
//  ActiveModel.swift
//  Tickt
//
//  Created by Admin on 13/05/21.
//

import SwiftyJSON

struct ActiveModel {
    var result: ActiveData
    let status: Bool
    let statusCode: Int
    let message: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = ActiveData.init(json["result"])
    }
}

struct ActiveData {
    var active: [RecommmendedJob]
    var milestonesCount, newJobsCount: Int
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        milestonesCount = json["milestonesCount"].intValue
        newJobsCount = json["newJobsCount"].intValue
        active = json["active"].arrayValue.map({RecommmendedJob.init($0)})
    }
}
