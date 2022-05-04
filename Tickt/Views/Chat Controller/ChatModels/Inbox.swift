//
//  Inbox.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Inbox : Hashable {
    var hashValue: Int
    let roomId : String
    var unreadCount : Int = 0
    var username: String?
    var userImage: String?
    var chatRoom : ChatRoom?
    var chatMember : ChatMember?
    var lastMessage : ChatMessage?
    var roomType: RoomType = .none
    var jobId: String?
    var jobName: String?
    
    init(with json: JSON) {
        roomId                  = json["roomId"].stringValue
        unreadCount             = json["unreadMessages"].intValue
        hashValue               = roomId.hashValue
        jobId                   = json["jobId"].stringValue
        jobName                 = json["jobName"].stringValue
    }
    
    init(with roomId: String) {
        self.roomId                  = roomId
        hashValue                    = roomId.hashValue
    }
    
    static func ==(lhs: Inbox, rhs: Inbox) -> Bool {
        return lhs.roomId == rhs.roomId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(roomId)
        hasher.combine(unreadCount)
        hasher.combine(chatMember)
        hasher.combine(roomType)
        hasher.combine(jobId)
        hasher.combine(jobName)
    }
}
