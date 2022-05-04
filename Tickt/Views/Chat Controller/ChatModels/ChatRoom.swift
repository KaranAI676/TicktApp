//
//  ChatRoom.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ChatRoom {
    
    var chatRoomId : String
    let chatRoomType : RoomType
    let lastUpdate              : Double
    let lastUpdates             : [UserUpdates]
    let chatRoomMembers: [MemberUpdates]
    
    var currentUserUpdate: MemberUpdates? {        
        let userId = kUserDefaults.getUserId()
        let res = self.chatRoomMembers.filter { (memberUpdate) -> Bool in
            return memberUpdate.userId == userId
        }
        return res.first
    }
    
    init(with json: JSON) {
        chatRoomId                  = json["chatRoomId"].stringValue
        let typeString              = json["chatRoomType"].stringValue
        chatRoomType                = RoomType(rawValue: typeString) ?? .none
        lastUpdate                  = json["chatLastUpdate"].doubleValue
        lastUpdates                 = UserUpdates.models(from: json["chatLastUpdate"].dictionaryValue)
        
        let jsonDict = json["chatRoomMembers"].dictionaryValue
        var chatMem: [MemberUpdates] = []
        for (key,value) in jsonDict {
            let memberJoin = value["memberJoin"].doubleValue
            let memberLeave = value["memberLeave"].doubleValue
            let memberDelete = value["memberDelete"].doubleValue
            
            let memberUp = MemberUpdates(userId: key,
                                         memberDelete: memberDelete,
                                         memberJoin: memberJoin,
                                         memberLeave: memberLeave)
            
            chatMem.append(memberUp)
        }
        self.chatRoomMembers = chatMem
    }
}

struct UserUpdates {
    
    let id          : String
    let updatedAt   : TimeInterval
    
    init(id: String, updatedAt: Double) {
        self.id          = id
        self.updatedAt   = updatedAt
    }
    
    static func models(from dictionary: [String: JSON]) -> [UserUpdates] {
        var updates = [UserUpdates]()
        for (key, value) in dictionary {
            let update = UserUpdates(id: key, updatedAt: value.doubleValue)
            updates.append(update)
        }
        return updates
    }
}

struct MemberUpdates {
    let userId: String
    let memberDelete: Double
    let memberJoin : Double
    let memberLeave: Double
}
