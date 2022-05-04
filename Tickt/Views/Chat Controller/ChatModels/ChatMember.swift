//
//  ChatMember.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

//struct ChatMember: Hashable {
//    //var hashValue: Int = 0
//    //var email, fullName: String
//    //var online: String
//    var userId: String
//    //var userImage: String
////    var deviceToken: String
//    //var deviceType: DeviceType
//    //var deviceId: String
//    //var userType: String
//
//    var jsonValue : JSON {
//        let dict : [String : Any] = ["userId" : userId                            ]
//        return JSON(dict)
//    }
//
//    var dictionaryValue : [String : Any]{
//        let dict : [String : Any] = ["userId" : userId
//                                     ]
//        return dict
//    }
//}
//
//extension ChatMember {
//
//    init(with json: JSON) {
//        userId      = json["userId"].stringValue
//
//    }
//
//    static func ==(left:ChatMember, right:ChatMember) -> Bool {
//        return left.userId == right.userId
//    }
//
//    static func models(from jsonArray: [JSON]) -> [ChatMember] {
//        var models: [ChatMember] = []
//        for json in jsonArray {
//            let member = ChatMember(with: json)
//            models.append(member)
//        }
//        return models
//    }
//}


struct ChatMember: Hashable {
//    let email, fullName: String
//    let online: String
    let userId: String
//    var deviceToken: String
//    let deviceType: DeviceType
//    var userImage: String
//    var deviceToken: String
//    let deviceType: DeviceType
//    let deviceId: String
//    let userType: String
    
    var jsonValue : JSON {
        
        let dict : [String : Any] = ["userId" : userId]
//                                     "deviceToken" : deviceToken,
//                                     "deviceType": deviceType.rawValue]
//                                     "image" : userImage,
//                                     "email" : email,
//                                     "deviceToken" : deviceToken,
//                                     "onlineStatus" : online,
//                                     "deviceType": deviceType.rawValue,
//                                     "deviceId": deviceId,
//                                     "userType" : userType]
        return JSON(dict)
    }
    
    var dictionaryValue : [String : Any]{
        let dict : [String : Any] = ["userId" : userId]
//                                     "deviceToken" : deviceToken,
//                                     "deviceType": deviceType.rawValue]
//                                     "image" : userImage,
//                                     "email" : email,
//                                     "deviceToken" : deviceToken,
//                                     "onlineStatus" : online,
//                                     "deviceType": deviceType.rawValue,
//                                     "deviceId": deviceId,
//                                     "userType" : userType]
        return dict
    }
}

extension ChatMember {
    
    init(with json: JSON) {
        userId      = json["userId"].stringValue
//        deviceToken = json["deviceToken"].stringValue
//        deviceType  = DeviceType(rawValue: json["deviceType"].stringValue) ?? .iOS
//        fullName    = json["name"].stringValue
//        userImage   = json["image"].stringValue
//        email       = json["email"].stringValue
//        deviceToken = json["deviceToken"].stringValue
//        //online      = json["onlineStatus"].stringValue
//        deviceType  = DeviceType(rawValue: json["deviceType"].stringValue) ?? .none
//        deviceId    = json["deviceId"].stringValue
//        if let _ = json["onlineStatus"].bool {
//            online = "Online"
//        }else if let timeStamp = json["onlineStatus"].double {
//            let time = dateManager.string(from: timeStamp,
//                                          dateFormat: "hh:mm a",
//                                          inMilliSeconds: true)
//            online = "Last seen on \(time)"
//        }else{
//            online = ""
//        }
////        hashValue   = userId.hashValue
//        userType   = json["userType"].stringValue
    }
    
    static func ==(left:ChatMember, right:ChatMember) -> Bool {
        return left.userId == right.userId
    }
    
    static func models(from jsonArray: [JSON]) -> [ChatMember] {
        var models: [ChatMember] = []
        for json in jsonArray {
            let member = ChatMember(with: json)
            models.append(member)
        }
        return models
    }
}
