//
//  PastModel.swift
//  Tickt
//
//  Created by Admin on 13/05/21.
//

import SwiftyJSON
struct PastModel {
    var result: PastData
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
        result = PastData.init(json["result"])
    }
}

struct PastData {
    var completed: [RecommmendedJob]
    var milestonesCount, newJobsCount: Int
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        completed = json["completed"].arrayValue.map({RecommmendedJob.init($0)})
        milestonesCount = json["milestonesCount"].intValue
        newJobsCount = json["newJobsCount"].intValue
    }
}
