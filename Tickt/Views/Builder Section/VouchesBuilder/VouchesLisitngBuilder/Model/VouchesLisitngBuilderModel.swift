//
//  VouchesLisitngBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 19/06/21.
//

import Foundation
import SwiftyJSON

struct VouchesLisitngBuilderModel {
    var status: Bool
    var message: String
    var statusCode: Int
    var result: VouchesLisitngResultModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = VouchesLisitngResultModel.init(json["result"])
    }
}

struct VouchesLisitngResultModel {
    var totolVouches: Int
    var voucher: [TradieProfileVouchesData]
    
    enum CodingKeys: String, CodingKey {
        case voucher
        case totolVouches = "count"
    }
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        totolVouches = json["count"].intValue
        voucher = json["voucher"].arrayValue.map({TradieProfileVouchesData.init($0)})
    }
}
