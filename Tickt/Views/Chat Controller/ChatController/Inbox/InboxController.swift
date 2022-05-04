//
//  InboxController.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseDatabase

protocol ChatError:AnyObject {
    func didFailToFetchInbox(error: Error)
}

protocol InboxControllerDelegate: ChatError{
    func willFetchInbox()
    func inboxChangesOccurs()
    func reloadRow(at index: Int)
    func deleteRow(at index: Int)
    func inboxStatus(isEmpty: Bool)
    func didFetchInbox(message: String)
    func updateAllChatUnreadCount(unreadCount: Int)
}

class InboxController {
        
    var unsafeInboxList: [Inbox] = []
    var itemsInfoArray: [ItemDetailsChatModel] = []
    private var databaseHandle: [String:UInt] = [:]
    private var groupDetailHandle: [String:UInt] = [:]
    private var messageChangeHandle: [String:UInt] = [:]
    private let inboxQueue = DispatchQueue(label: "InboxQueue", attributes: .concurrent)
        
    weak var delegate: InboxControllerDelegate?
    
    var inboxList: [Inbox] {
        var inboxCopy: [Inbox]!
        inboxQueue.sync {
            inboxCopy = self.unsafeInboxList
        }
        return inboxCopy
    }
}

extension InboxController {
    func delete(row: Int) {
        let inbox = self.inboxList[row]
        guard let otherUserId = inbox.chatMember?.userId else { return }
        ChatHelper.deleteChat(otherUserId: otherUserId, roomId: inbox.roomId)
    }
}

extension InboxController {
    
    func observeInbox() {
        let userId = kUserDefaults.getUserId()
        observeChatDelete(userId: userId)
        observeNewChatMessage(userId: userId)
        observeLastMessageChange(userId: userId)
    }
    
    private func observeNewChatMessage(userId: String) {
        guard !userId.isEmpty else { return }
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(userId)
        checkIfInboxIsEmpty(ref: inboxRef)
        databaseHandle[ObserverKeys.messageAdded.rawValue] = inboxRef.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let self = self, let value = snapshot.value else { return }
            var inbox = Inbox(with: JSON(value))
            inbox.roomType = .single
            //Getting Room Info
            guard !inbox.roomId.isEmpty else { return }
            let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(inbox.roomId)
            self.groupDetailHandle[inbox.roomId] = roomRef.observe(.value, with: { [weak self] (snapshot) in
                guard let self = self else { return }
                if let value = snapshot.value {
                    print("ROOM INFO: ", JSON(value))
                    let chatRoom = ChatRoom(with: JSON(value))
                    inbox.chatRoom = chatRoom
                
                    //Getting last Message
                    let lastMessageRef = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(inbox.roomId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue)
                    self.databaseHandle[inbox.roomId] = lastMessageRef.observe(.value) { [weak self](snapshot) in
                        guard let self = self else  { return }
                        if let value = snapshot.value, !(value is NSNull) {                            
                            let message = ChatMessage(with: JSON(value))
                            var otherUserId = ""
                            let ids = inbox.roomId.split(separator: "_")
                            if ids.count == 3 {
                                let tradieId = ids[1]
                                let builderId = ids[2]
                                if kUserDefaults.isTradie() {
                                    otherUserId = String(builderId)
                                } else {
                                    otherUserId = String(tradieId)
                                }
                            } else if kUserDefaults.getUserId() == message.receiverId {
                                otherUserId = message.senderId
                            } else {
                                otherUserId = message.receiverId
                            }

                            inbox.lastMessage = message
                            //Getting User Detail
                            guard !otherUserId.isEmpty else { return }
                            ChatHelper.getUserDetails(userId: otherUserId) { [weak self] (member) in
                                guard let self = self else  { return }
                                if let memberObject = member {
                                    inbox.username = memberObject["name"] as? String ?? ""
                                    inbox.userImage = memberObject["image"] as? String ?? ""
                                    self.addNew(inboxItem: inbox)
                                    let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                                        .child(userId)
                                    self.messageChangeHandle["messageChangedHandle"] = inboxRef.observe(.childChanged, with: { [weak self] (snapshot) in
                                        guard let self = self, let value = snapshot.value else { return }
                                        var inbox = Inbox(with: JSON(value))
                                        print("New Unread Message: ", JSON(value))
                                        inbox.roomType = .single
                                        self.updateUnreadCount(inbox: inbox)
                                        self.updateAllMessageCount()
                                    }) { [weak self](error) in
                                        self?.delegate?.didFailToFetchInbox(error: error)
                                    }
                                } else {
                                    self.updateEmptyStatus()
                                }
                            }
                        } else {
                            self.updateEmptyStatus()
                        }
                    }
                }
            })
            
            self.getBlockLeaveLastMessage(roomId: inbox.roomId, completion: { (lastMessage) in
                if let lastMessage = lastMessage {
                    self.update(lastMessage: lastMessage, inbox: inbox)
                } else {
                    self.setLastMessageObserver(inbox: inbox)
                    self.observeLastMessageChange(userId: userId)
                }
            })
        }) { [weak self](error) in
            self?.delegate?.didFailToFetchInbox(error: error)
        }
    }
    
    func updateEmptyStatus() {
        if self.unsafeInboxList.isEmpty {
            self.delegate?.inboxStatus(isEmpty: true)
        } else {
            self.delegate?.inboxStatus(isEmpty: false)
        }
    }
    
    private func observeChatDelete(userId: String) {
        guard !userId.isEmpty else { return }
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(userId)
        messageChangeHandle["deletedHandle"] = inboxRef.observe(.childRemoved, with: { [weak self] (snapshot) in
            guard let self = self, let value = snapshot.value else { return }
            let inbox = Inbox(with: JSON(value))
            self.update(deleted: inbox)
        }) { [weak self](error) in
            self?.delegate?.didFailToFetchInbox(error: error)
        }
    }
    
    private func observeLastMessageChange(userId: String) {
        guard !userId.isEmpty else { return }
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(userId)
        messageChangeHandle["messageChangedHandle"] = inboxRef.observe(.childChanged, with: { [weak self] (snapshot) in
            guard let self = self, let value = snapshot.value else { return }
            var inbox = Inbox(with: JSON(value))
            print("New Unread Message: ", JSON(value))
            self.updateUnreadCount(inbox: inbox)
            inbox.roomType = .single
        }) { [weak self](error) in
            self?.delegate?.didFailToFetchInbox(error: error)
        }
    }
    
    private func observeRoomDetails(inbox: Inbox) {
        guard !inbox.roomId.isEmpty else { return }
        let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(inbox.roomId)
        groupDetailHandle[inbox.roomId] = roomRef.observe(.value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            if let value = snapshot.value {
                let chatRoom = ChatRoom(with: JSON(value))
                self.update(inboxItem: inbox, chatRoom: chatRoom)
            }
        })
    }
        
    private func setLastMessageObserver(inbox: Inbox) {
        guard !inbox.roomId.isEmpty else { return }
        let lastMessageRef = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(inbox.roomId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue)
        databaseHandle[inbox.roomId] = lastMessageRef.observe(.value) { [weak self] (snapshot) in
            guard let self = self else  { return }
            if let value = snapshot.value {
                print(JSON(value))
                let message = ChatMessage(with: JSON(value))
                self.update(lastMessage: message, inbox: inbox)
            }
        }
    }
}

extension InboxController {
    
    private func addNew(inboxItem inbox: Inbox) {
        inboxQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let index = self.unsafeInboxList.firstIndex(of: inbox) {
                var newInbox = inbox
                newInbox.chatMember = self.unsafeInboxList[index].chatMember
                newInbox.chatRoom = self.unsafeInboxList[index].chatRoom
                newInbox.unreadCount = self.unsafeInboxList[index].unreadCount
                self.unsafeInboxList[index] = newInbox
            } else {
                self.unsafeInboxList.append(inbox)
            }
            self.sortListing()
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFetchInbox(message: "Completed")
            }
        }
    }

    private func update(inboxItem inbox: Inbox, chatRoom: ChatRoom) {
        inboxQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let index = self.unsafeInboxList.firstIndex(of: inbox) {
                self.unsafeInboxList[index].chatRoom = chatRoom
            }
            self.sortListing()
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFetchInbox(message: "Completed")
            }
        }
    }
    
    private func update(userDetails chatMember: JSONDictionary, inbox: Inbox) {
        inboxQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let index = self.unsafeInboxList.firstIndex(of: inbox) {
                self.unsafeInboxList[index].username = chatMember["name"] as? String ?? ""
                self.unsafeInboxList[index].userImage = chatMember["image"] as? String ?? ""
            }
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFetchInbox(message: "Completed")
            }
        }
    }
    
    private func update(lastMessage message: ChatMessage, inbox: Inbox) {
        getUserDetails(message: message, inbox: inbox)
        inboxQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let index = self.unsafeInboxList.firstIndex(of: inbox) {
                self.unsafeInboxList[index].lastMessage = message
            }
            self.sortListing()
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFetchInbox(message: "Completed")
            }
        }
    }
    
    private func update(deleted inbox: Inbox){
        inboxQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let index = self.unsafeInboxList.firstIndex(of: inbox){
                self.unsafeInboxList.remove(at: index)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.deleteRow(at: index)
                }
            }
        }
    }
    
    private func updateUnreadCount(inbox: Inbox) {
        inboxQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let index = self.unsafeInboxList.firstIndex(of: inbox) {
                self.unsafeInboxList[index].unreadCount = inbox.unreadCount
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.reloadRow(at: index)
                }
            }
        }
    }
    
    func updateAllMessageCount() {
        var unreadCount = 0
        for inbox in self.unsafeInboxList {
            unreadCount += inbox.unreadCount
        }
        self.delegate?.updateAllChatUnreadCount(unreadCount: unreadCount)
//        self.tabBar.items![3].badgeValue = unreadCount == 0 ? "" : "\(unreadCount)"

    }
    
    private func sortListing() {
        self.unsafeInboxList.sort(by: { (firstDialogue, secondDialogue) -> Bool in
            if let messageFirst = firstDialogue.lastMessage, let secondMessage = secondDialogue.lastMessage{
                return messageFirst.messageTimestamp > secondMessage.messageTimestamp
            } else {
                return false
            }
        })
    }
}

extension InboxController {
    
    /// Get last messages if user has blocked aomeone or left any group
    private func getBlockLeaveLastMessage(roomId: String, completion: @escaping (ChatMessage?)->()) {
        let userId = kUserDefaults.getUserId()
        let lastMessageRef = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId)        
        lastMessageRef.child(userId).child("chatLastMessage").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value{
                let json = JSON(value)
                if json == .null{
                    completion(nil)
                } else {
                    completion(ChatMessage(with: json))
                }
            } else {
                completion(nil)
            }
        }
    }
    
    private func getUserDetails(message: ChatMessage, inbox: Inbox){
        var userId: String = ""        
        let ids = message.messageRoomId.split(separator: "_")
        if ids.count == 3 {
            let tradieId = ids[1]
            let builderId = ids[2]
            if kUserDefaults.isTradie() {
                userId = String(builderId)
            } else {
                userId = String(tradieId)
            }
        } else if kUserDefaults.getUserId() == message.receiverId {
            userId = message.senderId
        } else {
            userId = message.receiverId
        }
                
        guard !userId.isEmpty else { return }
        ChatHelper.getUserDetails(userId: userId) { [weak self] (member) in
            if let member = member {
                self?.update(userDetails: member, inbox: inbox)
            }
        }
    }
    
    private func checkIfInboxIsEmpty(ref: DatabaseReference) {
        ChatHelper.checkIfNodeIsEmpty(ref: ref) { [weak self] (status) in
            self?.delegate?.inboxStatus(isEmpty: status)
        }
    }
}

extension InboxController {
    
    func removeFirebaseObservers() {
        
        if let handle = databaseHandle[ObserverKeys.messageAdded.rawValue] {
            let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                .child(kUserDefaults.getUserId())
            inboxRef.removeObserver(withHandle: handle)
        }
        
        if let handle = messageChangeHandle["messageChangedHandle"] {
            let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
                .child(kUserDefaults.getUserId())
            inboxRef.removeObserver(withHandle: handle)
        }
        
        for item in self.inboxList {
            if let handle = databaseHandle[item.roomId] {
                databaseReference.child(DatabaseNode.Root.lastMessage.rawValue)
                    .child(item.roomId)
                    .child(DatabaseNode.LastMessage.chatLastMessage.rawValue)
                    .removeObserver(withHandle: handle)
            }
            // remove group details observers
            if let handle = self.groupDetailHandle[item.roomId]{
                let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
                    .child(item.roomId)
                roomRef.removeObserver(withHandle: handle)
            }
        }
    }
}


//if inbox.roomId == "6114dcd1dfbf304550ea2635_61122c5b8100e63559a55b0a_611237e70c311551971e2235" {
//    print("Waiting")//611a54703459136bc67a3100_611cbbf5c4d7b85d7f9eec63_611237e70c311551971e2235
//}
