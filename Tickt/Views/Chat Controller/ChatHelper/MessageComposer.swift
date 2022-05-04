//
//  MessageComposer.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MessageComposer {
    
    static func composeTextMessage(text message: String, sender: String, receiver: String, roomId: String, isBlock: Bool) -> ChatMessage {
        
        let messageId: String = ChatHelper.getMessageId(forRoom: roomId)
        
        let dictionary: [String:Any] = [Message.message.rawValue: message,
                                        Message.sender.rawValue: sender,
                                        Message.receiverId.rawValue: receiver,
                                        Message.messageRoomId.rawValue: roomId,
                                        Message.isBlock.rawValue:isBlock,
                                        Message.messageId.rawValue:messageId,
                                        Message.type.rawValue: MessageType.text.rawValue,
                                        Message.status.rawValue:DeliveryStatus.send.rawValue,
                                        Message.timestamp.rawValue:ChatHelper.timestamp]
        return ChatMessage(with: JSON(dictionary))
        
    }
    
    static func composeImageMessage(mediaUrl: String, roomId: String, receiverId : String, isBlock: Bool, timeStamp: Double?, mimeType: MimeTypes) -> ChatMessage? {
        
        let senderId = kUserDefaults.getUserId()
        
        let messageId = ChatHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()
                
        if mimeType == .imageJpeg {
            message[Message.type.rawValue] = MessageType.image.rawValue
            message[Message.message.rawValue] = "Image"
        } else {
            message[Message.type.rawValue] = MessageType.video.rawValue
            message[Message.message.rawValue] = "Video"
        }
        message[Message.sender.rawValue] = senderId
        message[Message.mediaUrl.rawValue] = mediaUrl
        message[Message.messageId.rawValue] = messageId
        message[Message.isDeleted.rawValue] = false
        message[Message.progress.rawValue] = 0
        message[Message.isBlock.rawValue] = isBlock
        message[Message.messageRoomId.rawValue] = roomId
        message[Message.receiverId.rawValue] = receiverId
        message[Message.status.rawValue] = DeliveryStatus.send.rawValue
        message[Message.timestamp.rawValue] = timeStamp ?? ChatHelper.timestamp
        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        
        return chatMessage
    }
    
    static func composeVideoMessage(mediaUrl: String, thumbnail: String, roomId: String, receiverId : String, isBlock: Bool, timeStamp: Double?) -> ChatMessage? {
        
        let senderId = kUserDefaults.getUserId()
        let messageId = ChatHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()
        
        message[Message.type.rawValue] = MessageType.video.rawValue
        message[Message.message.rawValue] = "Sent a video"
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.send.rawValue
        message[Message.mediaUrl.rawValue] = mediaUrl
        message[Message.thumbnail.rawValue] = thumbnail
        message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = ChatHelper.timestamp
        message[Message.messageId.rawValue] = messageId
        message[Message.isDeleted.rawValue] = false
        message[Message.receiverId.rawValue] = receiverId
        message[Message.progress.rawValue] = 0
        message[Message.messageRoomId.rawValue] = roomId
        message[Message.isBlock.rawValue] = isBlock
        
        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        return chatMessage
    }
}

