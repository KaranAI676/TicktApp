//
//  ApproveDeclineDetailBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 04/06/21.
//

import Foundation
import SwiftyJSON

struct ApproveDeclineDetailBuilderModel {
    
    var result: ApproveDeclineDetailResult
    var statusCode: Int
    var message: String
    var status: Bool
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = ApproveDeclineDetailResult.init(json["result"])
    }
}

struct ApproveDeclineDetailResult {
    var images: [PhotosObject]?
    var hoursWorked: String?
    var description: String?
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        images =  json["images"].arrayValue.map({PhotosObject.init($0)})
        hoursWorked = json["hoursWorked"].stringValue
        description = json["description"].stringValue
    }
}
