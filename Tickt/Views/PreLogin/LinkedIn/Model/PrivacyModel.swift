//
//  PrivacyModel.swift
//  Tickt
//
//  Created by Admin on 09/04/21.
//

import Foundation
import SwiftyJSON

struct PrivacyModel {
    var result: PrivacyData
    let message: String
    let status: Bool    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        result = PrivacyData.init(json["result"])
    }
}

struct PrivacyData {
    var privacyUrl: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        privacyUrl = json["privacyPolicy_url"].stringValue
    }
}

struct TermsModel {
    var result: TermsData
    let message: String?
    let status: Bool?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        result = TermsData.init(json["result"])
    }
}

struct TermsData {
    var termsUrl: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        termsUrl = json["tnc_url"].stringValue
    }
    
}
