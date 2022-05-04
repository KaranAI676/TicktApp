//
//  SettingsBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 12/07/21.
//

import Foundation
import SwiftyJSON

struct SettingsBuilderModel {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: SettingsBuilderResultModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = SettingsBuilderResultModel.init(json["result"])
    }
}

struct SettingsBuilderResultModel {
    
    var reminders: SettingsOptionsModel
    var messages: SettingsOptionsModel
    var pushNotificationCategory:[Int]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        reminders = SettingsOptionsModel.init(json["reminders"])
        messages = SettingsOptionsModel.init(json["messages"])
        pushNotificationCategory = json["pushNotificationCategory"].object as? [Int] ?? [Int]()
    }
}

struct SettingsOptionsModel {
    var email: Bool
    var pushNotification: Bool
    var smsMessages: Bool
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        email = json["email"].boolValue
        pushNotification = json["pushNotification"].boolValue
        smsMessages = json["smsMessages"].boolValue
    }
}
