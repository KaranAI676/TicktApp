//
//  ChatMessage.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ChatMessage : Equatable {
    
    let progress : Int
    var image : UIImage?
    var isBlock, isDeleted: Bool
    let messageType : MessageType
    let lattitude, longitude: Double
    let receiverId, senderId: String
    var messageStatus: DeliveryStatus
    var messageTimestamp: TimeInterval
    var videoThumbnail, mediaURL : String
    let messageRoomId, messageText: String
    let mediaDuration, messageCaption, messageId: String
}

extension ChatMessage {
    
    init(with json: JSON) {
        
        mediaDuration = json["mediaDuration"].stringValue
        mediaURL = json["mediaUrl"].stringValue
        messageCaption = json["messageCaption"].stringValue
        messageId = json["messageId"].stringValue
        messageRoomId = json["messageRoomId"].stringValue
        let messageStatusString = json["messageStatus"].stringValue
        messageStatus = DeliveryStatus(rawValue: messageStatusString) ?? .read
        let messageTypeString = json["messageType"].stringValue
        messageType = MessageType(rawValue: messageTypeString) ?? .none
        messageTimestamp = json["messageTimestamp"].doubleValue
        lattitude = json["lattitude"].doubleValue
        longitude = json["longitude"].doubleValue
        receiverId = json["receiverId"].stringValue
        senderId = json["senderId"].stringValue
        videoThumbnail = json["thumbnail"].stringValue
        isBlock  = json["isBlock"].boolValue
        isDeleted  = json["isDeleted"].boolValue
        progress  = json["progress"].intValue
        if messageType == .text {
            messageText = json["messageText"].stringValue
        } else{
            messageText = json["messageText"].stringValue
        }
    }
    
    static func ==(lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    var messageDict: [String:Any] {
        
        var message = JSONDictionary()
        
        message[Message.type.rawValue] = messageType.rawValue
        message[Message.message.rawValue] = messageType == .text ?  messageText : messageText
        message[Message.sender.rawValue] = senderId //Int(senderId)
        message[Message.status.rawValue] = messageStatus.rawValue
        message[Message.mediaUrl.rawValue] = mediaURL
        message[Message.thumbnail.rawValue] = videoThumbnail
        message[Message.caption.rawValue] = messageCaption
        message[Message.isBlock.rawValue] = isBlock
        message[Message.timestamp.rawValue] = ChatHelper.timestamp
        message[Message.messageId.rawValue] = messageId
        message[Message.duration.rawValue] = mediaDuration
        message[Message.isDeleted.rawValue] = isDeleted
        message[Message.messageRoomId.rawValue] = messageRoomId
        message[Message.progress.rawValue] = progress
        message[Message.receiverId.rawValue] = receiverId//Int(receiverId)
        
        return message
    }
}
