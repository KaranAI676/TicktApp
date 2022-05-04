//
//  ChatEnum.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

enum MessageType: String {
    
    case none = "none"
    case text = "text"
    case audio = "audio"
    case video = "video"
    case image = "image"
    case left = "left"
    case added = "added"
    case created = "created"
    case changed = "changed"
    case header = "header"
    case action = "action"
    case location = "location"
    case post = "post"
    
    var text: String {
        switch self {
        case .image:
            return "Image"
        case .video:
            return "Video"
        case .audio:
            return "Audio"
        case .post:
            return "Post"
        default:
            return ""
        }
    }
}

enum DatabaseNode {
    
    enum Root: String {        
        case roomInfo = "room_info"
        case inbox = "inbox"
        case messages = "messages"
        case lastMessage = "lastMessage"
        case users = "users"
        case block = "block"
        case accessToken = "accessToken"
        case userBlockStatus = "users_block_status"
        case jobs = "jobs"
    }
    
    enum Rooms: String {
        case memberJoin = "memberJoin"
        case memberLeave = "memberLeave"
        case memberDelete = "memberDelete"
    }
    
    enum RoomInfo: String {
        case typing = "typing"
        case roomId = "chatRoomId"
        case chatType = "chatRoomType"
        case lastUpdate = "chatLastUpdate"
        case lastUpdates = "chatLastUpdates"
        case chatRoomMembers = "chatRoomMembers"
    }
    
    enum Inbox : String {
        case roomId = "roomId"
        case unreadCount = "unreadCount"
    }
    
    enum Users: String {
        case root = "users"
        case name = "name"
        case email = "email"
        case userId = "userId"
        case profilePic = "image"
        case deviceId = "deviceId"
        case userType = "userType"
        case online = "onlineStatus"
        case deviceType = "deviceType"
        case deviceToken = "deviceToken"
    }
    
    enum LastMessage: String {
        case chatLastMessage = "chatLastMessage"
    }    
}

enum Chat {
    case none
    case new
    case existing
}

enum RoomType: String {
    case none
    case single = "single"
    case group = "group"
}

enum DeliveryStatus: String {
    case send
    case read
    case uploading
    case failed
}
/// Chat is exiting or is new
enum ChatType {
    /// Default status
    case none
    /// New chat will be started
    case new
    /// Old chat will be continued
    case old
}
/// Device in which user is logged in
enum DeviceType: String {
    /// Device type cannot be determined
    case web = "1"
    /// User is logged in iPhone
    case iOS = "2"
    /// User is logged in Android
    case android = "3"
}

enum Message: String {
    case type = "messageType"
    case message = "messageText"
    case postId = "postId"
    case sender = "senderId"
    case status = "messageStatus"
    case mediaUrl = "mediaUrl"
    case thumbnail = "thumbnail"
    case caption = "messageCaption"
    case isBlock = "isBlock"
    case timestamp = "messageTimestamp"
    case messageId = "messageId"
    case duration = "mediaDuration"
    case lattitude = "lattitude"
    case longitude = "longitude"
    case isDeleted = "isDeleted"
    case receiverId = "receiverId"
    case progress = "progress"
    case messageRoomId = "messageRoomId"
}

enum ObserverKeys: String {
    case user
    case typing
    case message
    case roomInfo
    case leaveGroup
    case unreadCount
    case messageAdded
}

enum ChatmemberKeys: String {
    case userId = "userId"
    case name = "name"
    case image = "image"
    case email = "email"
    case deviceToken = "deviceToken"
    case onlineStatus = "onlineStatus"
    case deviceType = "deviceType"
}
