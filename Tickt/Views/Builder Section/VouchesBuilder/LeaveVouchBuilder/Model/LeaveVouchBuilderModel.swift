//
//  LeaveVouchBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 20/06/21.
//

import Foundation
import SwiftyJSON

struct LeaveVouchBuilderModel {
    
    var jobId: String = ""
    var jobName: String = ""
    var tradieId: String = ""
    var vouchText: String = ""
    var recommendation: (image: UIImage, finalUrl: String, data: Data, type: MediaTypes, mimeType: MimeTypes)?
}


struct VouchAddedModel {
    var status: Bool
    var message: String
    var statusCode: Int
    var result: TradieProfileVouchesData
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = TradieProfileVouchesData.init(json["result"])
    }
}
