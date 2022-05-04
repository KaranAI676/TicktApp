//
//  SingleChatController.swift
//  Tickt
//
//  Created by Appinventiv on 13/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseDatabase

protocol SingleChatControllerDelegate:AnyObject {
    func messagesStatus(isEmpty: Bool)
    func didUserFetched(user: JSONDictionary)
    func didSendMessage(sender: SingleChatController, message: ChatMessage)
    func didUpdateChatMember(sender: SingleChatController, updatedKey key: ChatmemberKeys)
    func didGetMessages(sender: SingleChatController, organisedData: [String: [ChatMessage]])
    func didSendPush(message: String, messageId: String, jobId: String, receiverId: String, count: Int)
}

class SingleChatController {

    init(roomId: String, senderId: String, receiverId: String, chatRoom: ChatRoom, chatMember: ChatMember, otherUserUnreadCount: Int, jobId: String) {
        self.roomId = roomId
        self.senderId = senderId
        self.receiverId = receiverId
        self.chatRoom = chatRoom
        self.chatMember = chatMember
        self.otherUserUnreadMessageCount = otherUserUnreadCount
        self.jobId = jobId
    }
    
    var jobId: String!
    var roomId: String!
    var senderId: String!
    var receiverId: String!
    var chatRoom: ChatRoom!
    var chatMember : ChatMember!
    var organisedKeys: [String] = []
    var otherUserUnreadMessageCount:Int!
    var organisedData: [String: [ChatMessage]] = [:]
    
    private var unreadHandle: UInt?
    private var unreadCount: Int = 0
    var reloadRowAtIndex: ((IndexPath) -> Void)?
    private var messageHandle: [String: UInt] = [:]
    private var databaseHandle: [String: UInt] = [:]
    weak var delegate: SingleChatControllerDelegate?
}

extension SingleChatController {
    
    func addObservers() {
        
        if !roomId.isEmpty {
            let ids = roomId.split(separator: "_")
            if kUserDefaults.isTradie() {
                observeUser(forUser: String(ids[2]))
            } else {
                observeUser(forUser: String(ids[1]))
            }
        } else {
           let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: roomId)
            if kUserDefaults.isTradie() {
                observeUser(forUser: ids.1)
            } else {
                observeUser(forUser: ids.0)
            }
        }
        
        observeUnreadCount()
        observeAllChatUnreadCount()
        observeMessages(forRoom: roomId)
        ChatHelper.setUserLastUpdate(forRoom: roomId, userId: kUserDefaults.getUserId())
    }
        
    private func observeMessages(forRoom roomId: String) {
        guard let currentMember = self.chatRoom.currentUserUpdate else { return }
        let messageRef = databaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId)
        checkIfMessagesAreEmpty(ref: messageRef)
        databaseHandle[ObserverKeys.message.rawValue] = messageRef.queryLimited(toLast: 500).queryOrdered(byChild: "messageTimestamp").queryStarting(atValue: currentMember.memberDelete).observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            if let value = snapshot.value{
                let message = ChatMessage(with: JSON(value))
                let ids = CommonFunctions.getTradieBuilderIds(senderId: self.senderId, receiverId: self.receiverId, roomId: self.roomId)
                let tradieId = ids.0
                let builderId = ids.1
                if kUserDefaults.isTradie() {
                    ChatHelper.resetUnreadCountTradie(tradieId: tradieId, builderId: builderId, jobId: self.jobId)
                } else {
                    ChatHelper.resetUnreadCountBuilder(tradieId: tradieId, builderId: builderId, jobId: self.jobId)
                }
                self.refreshMessageData(message)
            }
        }
    }
               
    private func observeUser(forUser userId: String) {
        let userRef = databaseReference.child(DatabaseNode.Root.users.rawValue).child(userId)
        databaseHandle[ObserverKeys.user.rawValue] = userRef.observe(.value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            if let value = snapshot.value as? JSONDictionary {
                print("\(snapshot.key) : \(value)")
                self.delegate?.didUserFetched(user: value)
            }
        })
    }
}

extension SingleChatController {
    
    func sendTextMessage(text: String) {
        let trimmedText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            return
        }
        sendMessage { () -> (ChatMessage) in
            let message = MessageComposer.composeTextMessage(text: trimmedText,
                                                             sender: kUserDefaults.getUserId(),
                                                             receiver: self.receiverId,
                                                             roomId: self.roomId,
                                                             isBlock: false)
            return message
        }
    }
        
    func sendImageOnMessage(mediaMessage: ChatMessage){
        self.sendMessage { () -> (ChatMessage) in
            return mediaMessage
        }
    }
    
    /**
     Set message at the firebase node
     */
    private func sendMessage(_ getMessage: ()->(ChatMessage)) {
        let message = getMessage()
        ChatHelper.setLastMessage(message)
        ChatHelper.sendMessage(message)
        ChatHelper.setLastUpdates(forRoom: message.messageRoomId, userId: message.senderId)
        let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: roomId)
        let tradieId = ids.0
        let builderId = ids.1
        if kUserDefaults.isTradie() {
            ChatHelper.setUnreadMessageCountByTradie(tradieId: tradieId, builderId: builderId, roomId: roomId, jobId: jobId, count: otherUserUnreadMessageCount + 1)
        } else {
            ChatHelper.setUnreadMessageCountByBuilder(tradieId: tradieId, builderId: builderId, roomId: roomId, jobId: jobId, count: otherUserUnreadMessageCount + 1)
        }
        sendPush(message: message, count: unreadCount)
        delegate?.didSendMessage(sender: self, message: message)
    }
}

extension SingleChatController {
    /**
     Get chat members
     */
    private func getChatMembers() -> [ChatMember] {
        
        let dictionary: [String:Any] = ["name": kUserDefaults.getUsername(),
                                        "email": kUserDefaults.getUserEmail(),
                                        "userId": kUserDefaults.getUserId()]
        let member2: ChatMember = ChatMember(with: JSON(dictionary))
        return [self.chatMember, member2]
    }
    
    func createRoomInfo(_ members: [ChatMember], _ forUserId: String) {
        self.chatRoom = ChatHelper.createRoom(forUserId: forUserId, curUserId: kUserDefaults.getUserId(), type: .single, members: members)
    }
    
    func sendPush(message: ChatMessage, count: Int) {
        let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: roomId)
        let tradieId = ids.0
        let builderId = ids.1
        let recieverId = kUserDefaults.isTradie() ? builderId : tradieId
        guard chatMember != nil else { return }
        delegate?.didSendPush(message: message.messageText, messageId: message.messageId, jobId: jobId, receiverId: recieverId, count: count)        
    }
    
    private func checkIfMessagesAreEmpty(ref: DatabaseReference) {
        ChatHelper.checkIfNodeIsEmpty(ref: ref) { [weak self] (status) in
            self?.delegate?.messagesStatus(isEmpty: status)
        }
    }
}

extension SingleChatController {
    
    func refreshMessageData(_ message: ChatMessage) {
        let currentUserId = kUserDefaults.getUserId()
        if ((currentUserId != message.senderId) && message.isBlock) || message.isDeleted {
            return
        }
        organise(message: message)
        delegate?.didGetMessages(sender: self, organisedData: self.organisedData)
    }
    
    private func organise(message: ChatMessage){
        
        let key = dateManager.getNotationFor(timestamp: message.messageTimestamp)
        if !self.organisedKeys.contains(key){
            self.organisedKeys.append(key)
        }
        if var arr = self.organisedData[key] {
            if let index = arr.firstIndex(of: message){
                arr.remove(at: index)
            }
            let index = arr.insertionIndexOf(elem: message, isOrderedBefore: { (m1, m2) -> Bool in
                return m1.messageTimestamp < m2.messageTimestamp
            })
            arr.insert(message, at: index)
            arr.sort(by: { (m1, m2) -> Bool in
                return m1.messageTimestamp < m2.messageTimestamp
            })
            self.organisedData[key] = arr
        } else {
            self.organisedData[key] = [message]
        }
    }
}

extension SingleChatController {
    
    func updateTyping(status: Bool) {
        if chatRoom != nil, !roomId.isEmpty {
            updateSelfTypingStatus(status, roomId)
        }
    }
    
    private func updateSelfTypingStatus(_ isTyping: Bool, _ roomId: String) {
        let typingRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
            .child(roomId)
            .child(DatabaseNode.RoomInfo.typing.rawValue)
        typingRef.updateChildValues([kUserDefaults.getUserId(): isTyping])
    }
        
    func observeMessageChange(message: ChatMessage) {
        messageHandle[message.messageId] = ChatHelper.observeMessage(messageId: message.messageId, roomId: message.messageRoomId, completion:  { [weak self] (messageId, value, key) in
            guard let _self = self else { return }
            switch key {
            case .status:
                if let seen = value as? String {
                    _self.updateSeenStatus(message: message, seen: seen)
                } else {
                    printDebug("Seen is empty.\nOriginal value: \(value)")
                }
            default:
                break
            }
        })
    }
    
    private func updateSeenStatus(message: ChatMessage, seen: String) {
        let key = dateManager.getNotationFor(timestamp: message.messageTimestamp)
        guard let messages = organisedData[key] else { return }
        if let section = organisedKeys.firstIndex(of: key), let row = messages.firstIndex(of: message) {
            organisedData[key]?[row].messageStatus = .read
            reloadRowAtIndex?((IndexPath(row: row, section: section)))
        }
    }
    
    private func observeUnreadCount() {
        let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: roomId)
        let tradieId = ids.0
        let builderId = ids.1
        if kUserDefaults.isTradie() {
            unreadHandle = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                .child(builderId).observe(.value) { [weak self] (snapshot) in
                    if let value = snapshot.value as? [AnyHashable:Any] {
                        self?.otherUserUnreadMessageCount = value["unreadMessages"] as? Int ?? 0
                    }
                }
        } else {
            unreadHandle = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                .child(tradieId).observe(.value) { [weak self] (snapshot) in
                    if let value = snapshot.value as? [AnyHashable:Any] {
                        self?.otherUserUnreadMessageCount = value["unreadMessages"] as? Int ?? 0
                    }
                }
        }
    }
    
    private func observeAllChatUnreadCount() {
        let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: roomId)
        let tradieId = ids.0
        let builderId = ids.1
        if kUserDefaults.isTradie() {
            unreadHandle = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                .child(builderId).child(tradieId + "_" + jobId).observe(.value) { [weak self] (snapshot) in
                    if let value = snapshot.value as? [AnyHashable:Any] {
                        self?.otherUserUnreadMessageCount = value["unreadMessages"] as? Int ?? 0
                    }
                }
        } else {
            unreadHandle = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                .child(tradieId).child(builderId + "_" + jobId).observe(.value) { [weak self] (snapshot) in
                    if let value = snapshot.value as? [AnyHashable:Any] {
                        self?.otherUserUnreadMessageCount = value["unreadMessages"] as? Int ?? 0
                    }
                }
        }
    }

}

extension SingleChatController {
    
    func removeObservers() {
        if chatRoom != nil {
            if !roomId.isEmpty {
                removeFirebaseObservers(roomId: roomId)
            } else if !chatRoom.chatRoomId.isEmpty {
                removeFirebaseObservers(roomId: chatRoom.chatRoomId)
            }
        }
    }
    
    private func removeFirebaseObservers(roomId: String) {
        ChatHelper.setUserLastUpdate(forRoom: roomId, userId: kUserDefaults.getUserId())
        if let handle = self.databaseHandle[ObserverKeys.message.rawValue] {
            let messageRef = databaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId)
            messageRef.queryLimited(toLast: 500)
                .queryOrdered(byChild: "isBlock")
                .queryEqual(toValue: false)
                .removeObserver(withHandle: handle)
        }
        
        if let handle = self.databaseHandle[ObserverKeys.typing.rawValue] {
            databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
                .child(roomId)
                .child(DatabaseNode.RoomInfo.typing.rawValue)
                .removeObserver(withHandle: handle)
        }
        
        if let handle = self.unreadHandle {
            let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: roomId)
            let tradieId = ids.0
            let builderId = ids.1
            if kUserDefaults.isTradie() {
                databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                    .child(tradieId).child(builderId + "_" + jobId).child("unreadMessages").removeObserver(withHandle: handle)
                databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                    .child(tradieId).child(builderId + "_" + jobId).removeObserver(withHandle: handle)
            } else {
                databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                    .child(builderId).child(tradieId + "_" + jobId).child("unreadMessages").removeObserver(withHandle: handle)
                databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                    .child(builderId).child(tradieId + "_" + jobId).removeObserver(withHandle: handle)
            }
        }
        
        if let handle = self.databaseHandle[ObserverKeys.user.rawValue] {
            let userRef = databaseReference.child(DatabaseNode.Root.users.rawValue)
                .child(chatMember.userId)
            userRef.removeObserver(withHandle: handle)
        }
    }
}

extension Array {
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}

