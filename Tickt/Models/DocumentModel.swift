//
//  DocumentModel.swift
//  Tickt
//
//  Created by Admin on 12/03/21.
//

import Foundation
import SwiftyJSON

struct DocumentModel {
    let result: DocumentData?
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
        result = DocumentData.init(json["result"])
    }
}

struct DocumentData: Codable {
    let url: [String]?
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        url = json["url"].arrayObject as? [String] ?? []
    }
}

