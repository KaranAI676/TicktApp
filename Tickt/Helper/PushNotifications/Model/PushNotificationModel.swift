//
//  PushNotificationModel.swift
//  Tickt
//
//  Created by S H U B H A M on 26/07/21.
//

import SwiftyJSON

struct PushNotificationModel: Codable {
    let extraData: String?
    let notificationId: String?
    let myId, userType: String?
    let othersId, notificationType: String?
    let title, notificationText, jobId: String?
    
    enum CodingKeys: String, CodingKey {
        case jobId = "jobId"
        case notificationType
        case title, notificationText
        case myId = "receiverId"
        case othersId = "senderId"
        case userType = "user_type"
        case extraData = "extra_data"
        case notificationId = "notification_id"        
    }
    
    func myExtraModel() -> NotificationExtraDataModel? {
        let data = (extraData ?? "").data(using: .utf8)!
        do {
            if let dict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? JSONDictionary {
                let json = JSON(dict)
                return NotificationExtraDataModel(json)
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
