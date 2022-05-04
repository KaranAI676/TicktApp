//
//  SavedTradieBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 21/06/21.
//

import Foundation
import SwiftyJSON

struct SavedTradieBuilderModel {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: [SavedTradies]
    

    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = json["result"].arrayValue.map({SavedTradies.init($0)})
    }
}
