//
//  ChatHelper.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging

let databaseReference = Database.database().reference()

class ChatHelper {
    
    static func validate(_ text: String)->String?{
        let messageStr = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if messageStr.isEmpty {
            return nil
        }
        return messageStr
    }
    
    static func getConversationId(jobId:String, tradieId: String, buidlerId: String)-> String {
        return jobId + "_" + tradieId + "_" + buidlerId
    }
    
    static func getUnsentMediaMessages(_ receiverId: String)->[ChatMessage]{
        return []//mediaFiles
    }
    
    static func getJobDetails(itemId: String, completion: @escaping (ItemDetailsChatModel?)->())  {
        
        databaseReference.child(DatabaseNode.Root.jobs.rawValue).child(itemId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                print("JOB DETAIL: \n",JSON(value))
                let itemObject = ItemDetailsChatModel(withJSON: JSON(value))
                if itemObject.jobId == "" {
                    completion(nil)
                } else {
                    completion(itemObject)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    static func addJobDetails(jobId: String, jobName: String, tradieId: String, builderId: String, profileImage: String, username: String) {
        let itemRef = databaseReference.child(DatabaseNode.Root.jobs.rawValue)
        let data: [String:Any] = ["jobId": jobId,
                                  "jobName": jobName,
                                  "tradieId": tradieId,
                                  "username": username,
                                  "builderId": builderId,
                                  "profileImage": profileImage]
        itemRef.child(jobId).updateChildValues(data)
    }
        
    static func checkInboxExistsFor(jobId:String, otherUserId: String, userId: String, completion: @escaping (Bool)->()) {
        guard !(userId.isEmpty && otherUserId.isEmpty && jobId.isEmpty) else { return }
        databaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(otherUserId + "_" +  jobId).observeSingleEvent(of:.value, with: {
            (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                print("INBOX DETAIL: \n",JSON(value))
                if (value["roomId"] as? String ?? "") != "" {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        })
    }
    
    static func updateInboxForConversationId(roomId: String, tradieId: String, builderId: String, unreadCount: Int, jobId: String, jobName: String) {
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)        
        let data: [String:Any] = ["jobId": jobId,
                                  "roomId": roomId,
                                  "jobName": jobName]
        //Change for a inbox
//        "unreadMessages": unreadCount
        inboxRef.child(tradieId).child(builderId + "_" + jobId).updateChildValues(data)
        inboxRef.child(builderId).child(tradieId + "_" + jobId).updateChildValues(data)
    }
    
    static func createRoom(jobId: String, tradieId: String, builderId: String, type: RoomType, members: [ChatMember]) -> ChatRoom {
        
        let roomId: String = getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderId)
        let chatroom = createRoom(roomId: roomId,
                                       curUserId: kUserDefaults.getUserId(),
                                       members: members,
                                       chatRoomPic: "",
                                       chatRoomTitle: "",
                                       chatRoomType: .single)
        return chatroom
    }
    
    static func getUnreadMessagesTradie(tradieId: String, builderId: String, jobId: String, completion: @escaping((Int)->())) {
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(tradieId)
            .child(builderId + "_" + jobId)
        inboxRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                print("UNREAD COUNT DETAIL: \n", JSON(value))
                let valueDict = value as? [AnyHashable:Any] ?? ["unreadMessages": 0]
                let unreadMessages = valueDict["unreadMessages"] as? Int ?? 0
                completion(unreadMessages)
            } else {
                completion(0)
            }
        }
    }
    
    static func getUnreadMessagesBuilder(tradieId: String, builderId: String, jobId: String, completion: @escaping((Int)->())) {
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(builderId)
            .child(tradieId + "_" + jobId)
        inboxRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                print("UNREAD COUNT DETAIL: \n", JSON(value))
                let valueDict = value as? [AnyHashable:Any] ?? ["unreadMessages": 0]
                let unreadMessages = valueDict["unreadMessages"] as? Int ?? 0
                completion(unreadMessages)
            } else {
                completion(0)
            }
        }
    }
    
    static func setUnreadMessageCountByTradie(tradieId: String, builderId: String, roomId: String, jobId:String, count:Int) {
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue).child(builderId)
        inboxRef.child(tradieId + "_" + jobId).updateChildValues(["roomId": roomId, "unreadMessages": count, "jobId": jobId])
        print("Unread Count Builder : \(count)")
    }
    
    static func setUnreadMessageCountByBuilder(tradieId: String, builderId: String, roomId: String, jobId:String, count:Int) {
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue).child(tradieId)
        inboxRef.child(builderId + "_" + jobId).updateChildValues(["roomId": roomId, "unreadMessages": count,"jobId": jobId])
        print("Unread Count Tradie : \(count)")
    }
    
    static func resetUnreadCountTradie(tradieId: String, builderId: String, jobId:String) {
        databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(tradieId)
            .child(builderId + "_" + jobId)
            .updateChildValues(["unreadMessages": 0])
    }
    
    static func resetUnreadCountBuilder(tradieId: String, builderId: String, jobId:String) {
        databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(builderId)
            .child(tradieId + "_" + jobId)
            .updateChildValues(["unreadMessages": 0])
    }
    
    static func getAllUnreadMessageCount(userId: String, completion: @escaping((Int)->())) {
        let inboxRef = databaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId)
        var unreadCount = 0
        inboxRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                for (inboxKey, inboxValue) in data {
                    let valueDict = inboxValue as? [AnyHashable:Any] ?? ["unreadMessages": 0]
                    unreadCount += valueDict["unreadMessages"] as? Int ?? 0
                }
                }
                completion(unreadCount)
            }
        }
    }
}


extension ChatHelper {
    
    /**
     Get message id for a chatroom
     */
    
    static func getMessageId(forRoom roomId: String) -> String {
        if let id = databaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).childByAutoId().key{
            return id
        } else {
            fatalError("Cannot generate message")
        }
    }
    
    /**
     Get timestamp
     */
    
    static var timestamp: [AnyHashable:Any]{
        return ServerValue.timestamp()
    }
}


extension ChatHelper {
    
    //MARK:- Delete chat
    static func deleteChat(otherUserId : String,roomId: String) {
        
        guard !otherUserId.isEmpty,!roomId.isEmpty else { return }
        
        let userId = kUserDefaults.getUserId()
        databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
            .child(roomId).child(DatabaseNode.RoomInfo.chatRoomMembers.rawValue)
            .child(userId).child(DatabaseNode.Rooms.memberDelete.rawValue)
            .setValue(ServerValue.timestamp())
        databaseReference.child(DatabaseNode.Root.inbox.rawValue)
            .child(userId)
            .child(otherUserId)
            .removeValue()
        
    }
}
//MARK:- User related details
//===================================
extension ChatHelper{
    
    static func getUserDetails(userId: String, completion: @escaping (JSONDictionary?)->()) {
        let node: DatabaseNode.Root = .users
        databaseReference.child(node.rawValue).child(userId).observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? JSONDictionary {
                print("USER DETAIL: \n", JSON(value))
                completion(value)
            } else {
                completion(nil)
            }
        }
//        databaseReference.child(node.rawValue).child(userId).observe(.value) { (snapshot) in
//            if let value = snapshot.value as? JSONDictionary {
//                print("USER DETAIL: \n", JSON(value))
//                completion(value)
//            } else {
//                completion(nil)
//            }
//        }
    }
    
    static func signInAnonymously() {
        
        Auth.auth().signInAnonymously { (signinResult, error) in
            if let signinResult = signinResult{
                printDebug("Logged in userId: \(signinResult.user.uid)")
                ChatHelper.updateUserDetails()
//                let user = UserModel(AppUserDefaults.value(forKey: .fullUserProfile))
                self.setOnline(userId: kUserDefaults.getUserId(), status: true)
            } else if let error = error {
                printDebug("Error Encountered: \(error.localizedDescription)")
            } else {
                printDebug("Unknown error occurred")
            }
        }
    }
    
    /**
     Login user to the firebase
     */
    
    static func createFirebaseUser(withEmail email: String, password: String, completion: @escaping (Bool)->()) {
         
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                printDebug(authResult.user.uid)
                kUserDefaults.setValue(true, forKey: UserDefaultKeys.kFirebaseLoggedIn)
                completion(true)
            } else if let error = error {
                print(error)
                ChatHelper.signIn(withEmail: email, password: password) { status in
                    if status {
                        print("Logged in to Firebase Console")
                    }
                }
                completion(false)
            } else {
                printDebug("Unknown error")
                completion(false)
            }
        }
    }
    
    static func signIn(withEmail email: String, password: String, completion: @escaping (Bool)->()) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let _ = authResult {
                ChatHelper.updateUserDetails()
                completion(true)
            } else if let error = error {
                printDebug(error.localizedDescription)
                completion(false)
            } else {
                printDebug("Unknown error")
                completion(false)
            }
        }
    }
    
    /**
     Create user using the email and default password
     */
    static func createUser(withEmail email: String, password: String, completion: @escaping (Bool)->()){
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            
            if let authResult = authResult{
                printDebug(authResult.user.uid)
                ChatHelper.updateUserDetails()
                completion(true)
            }else if let error = error{
                printDebug(error.localizedDescription)
                completion(false)
            }else{
                printDebug("Unknown error")
                completion(false)
            }
        })
    }
    
    /**
     Login Via custom token
     */
    
    static func loginWithCustom(token: String){
        
        Auth.auth().signIn(withCustomToken: token) { (signinResult, error) in
            if let signinResult = signinResult{
                printDebug("Logged in userId: \(signinResult.user.uid)")
                ChatHelper.updateUserDetails()
//                let user = UserModel(AppUserDefaults.value(forKey: .fullUserProfile))
                self.setOnline(userId: kUserDefaults.getUserId(), status: true)
            } else if let error = error{
                printDebug("Error Encountered: \(error.localizedDescription)")
            } else {
                printDebug("Unknown error occurred")
            }
        }
    }
    
    /**
     Create user using the email and default password
     */
    
    static func updateUserDetails(_ isOnline: Bool = false) {
        let name = !kUserDefaults.getFirstName().isEmpty ? kUserDefaults.getFirstName() : kUserDefaults.getUsername()
        var userDetails: [String: Any] = [:]
        userDetails[DatabaseNode.Users.name.rawValue] = name
        userDetails[DatabaseNode.Users.deviceId.rawValue] = DeviceDetail.deviceId
        userDetails[DatabaseNode.Users.userId.rawValue] = kUserDefaults.getUserId()
        userDetails[DatabaseNode.Users.email.rawValue] = kUserDefaults.getUserEmail()
        userDetails[DatabaseNode.Users.userType.rawValue] = kUserDefaults.getUserType()        
        userDetails[DatabaseNode.Users.deviceToken.rawValue] = kUserDefaults.getDeviceToken()
        userDetails[DatabaseNode.Users.profilePic.rawValue] = kUserDefaults.getUserProfileImage()
        userDetails[DatabaseNode.Users.deviceType.rawValue] = DeviceType.iOS.rawValue
        if isOnline {
            userDetails[DatabaseNode.Users.online.rawValue] = isOnline
        } else {
            userDetails[DatabaseNode.Users.online.rawValue] = ChatHelper.timestamp
        }
        ChatHelper.updateUserDetails(userId: kUserDefaults.getUserId(), details: userDetails)
    }
    
    static func updateUserDetails(userId: String, details: [String: Any]) {
        if !userId.isEmpty {
            databaseReference.child(DatabaseNode.Users.root.rawValue).child(userId).setValue(details)
        }
    }
    
    /**
     Update device token
     */
    
    static func updateDeviceToken(userId: String, deviceToken: String) {
        if !userId.isEmpty {
            let userRef = databaseReference.child(DatabaseNode.Users.root.rawValue).child(userId)
            userRef.child(DatabaseNode.Users.deviceToken.rawValue).setValue(deviceToken)
        }
    }
    
    /**
     Check user login status
     */
    static func checkStatusAndSignIn() {
        if Auth.auth().currentUser == nil{
            self.signIn(withEmail: kUserDefaults.getUserEmail(), password: AppConstants.firebaseAuthPass.rawValue, completion: { (success) in
                if success{
                    printDebug("========================\n\n")
                    printDebug("User logged in firebase\n\n")
                    printDebug("========================")
                    setOnline()
                } else {
                    printDebug("========================\n\n")
                    printDebug("User cannot log in firebase\n\n")
                    printDebug("========================")
                }
            })
        } else {
            setOnline()
        }
    }
    
    /**
     SetOnline status
     */
    
    private static func setOnline(userId: String, status: Bool){
        
        let userRef = databaseReference.child(DatabaseNode.Users.root.rawValue).child(userId)
        if status {
            userRef.child(DatabaseNode.Users.online.rawValue).setValue(status)
        } else {
            userRef.child(DatabaseNode.Users.online.rawValue).setValue(timestamp)
        }
    }

    /**
     set onffline
     */
    static func setOffLine() {
//        let fullUserProfile = AppUserDefaults.value(forKey: .fullUserProfile)
//        guard !fullUserProfile.isEmpty else { return }
//        let user = UserModel(fullUserProfile)
//        guard !user.userId.isEmpty else { return }
        self.setOnline(userId: kUserDefaults.getUserId(), status: false)
    }
    /**
     set online
     */
    static func setOnline() {
//        let user = UserModel(AppUserDefaults.value(forKey: .fullUserProfile))
        self.setOnline(userId: kUserDefaults.getUserId(), status: true)
    }
    
    /// Check if the chat is new or old
    static func checkifNewSingleChat(forUserId userId: String, curUserId: String, completion: @escaping (String?)->()){
        
        let roomId = [userId,curUserId].sorted().joined(separator: "_")
        
        let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
        
        roomRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(roomId) {
                completion(roomId)
            } else{
                completion(nil)
            }
        }
    }
    
    static func getChatRoomDetails(roomId: String, completion: @escaping (ChatRoom?)->()) {
        databaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                print("CHAT ROOM DETAIL: \n",JSON(value))
                let room = ChatRoom(with: JSON(value))
                completion(room)
            } else {
                completion(nil)
            }
        }
    }
}

extension ChatHelper {
    
    /**
     Create last message node
     */
    static func setLastMessage(_ message: ChatMessage) {
        let lastMessageRef = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue)
        let lastMsgRoom = lastMessageRef.child(message.messageRoomId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue)
        lastMsgRoom.setValue(message.messageDict)
    }
    
    /**
     Create message node
     */
    static func sendMessage(_ message: ChatMessage) {
        
        let messageRef = databaseReference.child(DatabaseNode.Root.messages.rawValue).child(message.messageRoomId).child(message.messageId)
        messageRef.setValue(message.messageDict)
    }
    
    /**
     Set last updates
     */
    static func setLastUpdates(forRoom roomId: String, userId: String) {
        let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId)
        roomRef.child(DatabaseNode.RoomInfo.lastUpdate.rawValue).setValue(timestamp)
        roomRef.child(DatabaseNode.RoomInfo.lastUpdates.rawValue)
            .child(userId).setValue(timestamp)
        setUserLastUpdate(forRoom: roomId, userId: userId)
    }
    
    static func setUserLastUpdate(forRoom roomId: String, userId: String) {
        let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
            .child(roomId)
        roomRef.child("chatLastUpdates").updateChildValues([userId: timestamp])
    }
}

extension ChatHelper{
    
    /*
     create Single chat room for the user
     */
    static func createRoom(forUserId userId: String, curUserId: String,type: RoomType, members: [ChatMember] )->ChatRoom{
        
        let roomId: String = [userId,curUserId].sorted().joined(separator: "_")
        
        let chatroom = self.createRoom(roomId: roomId,
                                       curUserId: curUserId,
                                       members: members,
                                       chatRoomPic: "",
                                       chatRoomTitle: "",
                                       chatRoomType: .single)
        
        return chatroom
    }
    
    private static func createRoom(roomId: String, curUserId: String, members: [ChatMember], chatRoomPic: String, chatRoomTitle: String, chatRoomType: RoomType)->ChatRoom{
        
        let roomRef = databaseReference.child(DatabaseNode.Root.roomInfo.rawValue)
            .child(roomId)
        
        var roomData: [String:Any] = [:]
        roomData[DatabaseNode.RoomInfo.lastUpdate.rawValue] = timestamp
        roomData[DatabaseNode.RoomInfo.roomId.rawValue] = roomId
        roomData[DatabaseNode.RoomInfo.chatType.rawValue] = chatRoomType.rawValue
        var updates: [String: Any] = [:]
        var chatRoomMembers: [String:Any] = [:]
        var isTyping: [String:Any] = [:]
        
        for member in members {
            if member.userId == curUserId {
                updates[member.userId] = ChatHelper.timestamp
            } else {
                updates[member.userId] = 0
            }
            chatRoomMembers[member.userId] = [DatabaseNode.Rooms.memberLeave.rawValue:0,
                                              DatabaseNode.Rooms.memberDelete.rawValue: ChatHelper.timestamp,
                                              DatabaseNode.Rooms.memberJoin.rawValue: ChatHelper.timestamp]
            isTyping[member.userId] = false
        }
        
        roomData[DatabaseNode.RoomInfo.typing.rawValue] = isTyping
        roomData[DatabaseNode.RoomInfo.lastUpdates.rawValue] = updates
        roomData[DatabaseNode.RoomInfo.chatRoomMembers.rawValue] = chatRoomMembers
        
        roomRef.setValue(roomData)
        let chatroom = ChatRoom(with: JSON(roomData))
        return chatroom
    }
    
    static func checkIfNodeIsEmpty(ref: DatabaseReference, completion: @escaping((Bool)->())){
        ref.observeSingleEvent(of: .value) { (snapshot) in
            completion(!snapshot.hasChildren())
        }
    }
}

//MARK:- Block/Unblock
//========================================
extension ChatHelper{
    
    static func block(userId: String, curUserId: String){
        let blockRef = databaseReference.child(DatabaseNode.Root.block.rawValue)
        blockRef.child(curUserId).child(userId).setValue(timestamp)
        let roomId: String = [userId,curUserId].sorted().joined(separator: "_")
        self.getLastMessageFor(roomId: roomId) { (message) in
            if let message = message {
                let ref = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue)
                    .child(roomId)
                    .child(curUserId).child("chatLastMessage")
                ref.setValue(message.messageDict)
            }
        }
    }
    
    static func unBlock(userId: String, curUserId: String){
        let blockRef = databaseReference.child(DatabaseNode.Root.block.rawValue)
        blockRef.child(curUserId).child(userId).removeValue()
        
        let roomId: String = [userId,curUserId].sorted().joined(separator: "_")
        let ref = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue)
            .child(roomId)
            .child(curUserId)
        ref.removeValue()
    }
    
    static func getLastMessageFor(roomId: String, completion: @escaping (ChatMessage?)->()){
        let lastMessageRef = databaseReference.child(DatabaseNode.Root.lastMessage.rawValue)
            .child(roomId)
            .child(DatabaseNode.LastMessage.chatLastMessage.rawValue)
        
        lastMessageRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value{
                print("LAST MESSAGE DETAIL: \n",JSON(value))
                let message = ChatMessage(with: JSON(value))
                completion(message)
            }else{
                completion(nil)
            }
        }
    }
}

extension ChatHelper {
    /// Observe message like status
    static func observeMessage(messageId: String, roomId: String, completion: @escaping((String, Any, Message)->()))->UInt{
        
        let likeRef = databaseReference.child(DatabaseNode.Root.messages.rawValue)
            .child(roomId)
            .child(messageId)        
        return likeRef.observe(.childChanged) { (snapshot) in
            guard let value = snapshot.value else { return }
            print("MESSAGE DETAIL: \n",JSON(value))
            switch snapshot.key {
            case Message.status.rawValue:
                completion(messageId, value, .status)
            default:
                printDebug("\(snapshot.key) has changed")
            }
        }
    }
    
    static func removeMessageObserver(messageId: String, roomId: String, handle: UInt){
        
        let likeRef = databaseReference.child(DatabaseNode.Root.messages.rawValue)
            .child(roomId)
            .child(messageId)
        likeRef.removeObserver(withHandle: handle)
    }
}

extension ChatHelper {
    
    /// Send push notification with device token
    static func sendPush(message: String, token: String, messageId: String, roomId: String, receiverId: String, count: Int, deviceType: DeviceType) {
        guard !token.isEmpty else { return }
        let name = kUserDefaults.getUsername().isEmpty ? kUserDefaults.getFirstName() : kUserDefaults.getUsername()
        let sender: JSONDictionary = ["user_id": kUserDefaults.getUserId(),
                                      "first_name": name,
                                      "device_token": kUserDefaults.getDeviceToken(),
                                      "device_type":"2"]
        guard let dic = convertToJsonFormat(sender)?.components(separatedBy: .whitespacesAndNewlines) else { return }
        var json = [String : Any] ()
        json["to"] = token
        json["priority"] = "high"
        switch deviceType {
        case .web:
            json["mutableContent"] = true
            json["content-available"] = 1
            let dataKey: [String: Any] = [
                "app_icon"  : "https://appinventiv-development.s3.amazonaws.com/1628513615740ic-logo-yellow.png",
                "title"  : "Tickt App",
                "notificationText"  : "\(kUserDefaults.getFirstName()) send you a message",
                "senderName" : kUserDefaults.getFirstName(),
                "messageType" : MessageType.text.rawValue,
                "notification_type"  : "50",
                "badge": count,
                "sound" : "default",
                "messageText": message,
                "image": kUserDefaults.getUserProfileImage(),
                "notificationType": 25]
            json["data"] = dataKey
        case .iOS:
            json["notification"] = [
                "body" : "\(name): \(message)",
                "messageId": messageId,
                "messageText": message,
                "roomId": roomId,
                "roomName": "",
                "roomType": "single",
                "title" : name,
                "type": "chat",
                "sound" : "default",
                "badge" : count + 1,
                "device_type": DeviceType.iOS.rawValue,
                "sender": (dic.joined().replace(string: "\\", withString: ""))
            ]
        case .android:
            json["mutableContent"] = true
            let data_key: [String:Any] = ["follow_by": kUserDefaults.getUserId(),
                                          "roomId":roomId,
                                          "name": name,
                                          "messageId": messageId,
                                          "image": ""]
            let body: [String:Any] = ["message":message,
                                      "title": name,
                                      "notification_type": 25,
                                      "data_key": data_key]
            json["data"] = ["body" : body]
        }
        printDebug(JSON(json))
        sendNotification(with: json)
    }
    
    /// Send push  notification without asking for push notification
    static func sendPush(message: String, messageId: String, jobId: String, receiverId: String, count: Int, jobName: String) {
        let name = kUserDefaults.getUsername().isEmpty ? kUserDefaults.getFirstName() : kUserDefaults.getUsername()
        let sender: JSONDictionary = ["user_id": kUserDefaults.getUserId(),
                                      "first_name": name,
                                      "device_token": kUserDefaults.getDeviceToken(),
                                      "device_type":"2"]
        guard let dic = self.convertToJsonFormat(sender)?.components(separatedBy: .whitespacesAndNewlines) else { return }
        getDeviceToken(userId: receiverId) { member in
            let token = member["deviceToken"] as? String ?? ""
            let type = member["deviceType"] as? String ?? ""
            let deviceType = DeviceType(rawValue: type) ?? .iOS
            var json = [String : Any] ()
            json["to"] = token
            json["priority"] = "high"
            switch deviceType {
            case .web:
                json["mutableContent"] = true
                json["content-available"] = 1
                let dataKey: [String: Any] = [
                    "app_icon"  : "https://appinventiv-development.s3.amazonaws.com/1628513615740ic-logo-yellow.png",
                    "title"  : "Tickt App",
                    "notificationText"  : "\(kUserDefaults.getFirstName()) send you a message",
                    "senderName" : kUserDefaults.getFirstName(),
                    "messageType" : MessageType.text.rawValue,
                    "badge": count,
                    "sound" : "default",
                    "messageText": message,
                    "image": kUserDefaults.getUserProfileImage(),
                    "notificationType": 25]
                json["data"] = dataKey
            case .iOS:
                json["notification"] = [
                    "body"  : message,
                    "jobId"  : jobId,
                    "jobName"  : jobName,
                    "messageId" : messageId,
                    "messageText" : message,
                    "notification_type"  : "50",
                    "title" : name,
                    "sound" : "default",
                    "badge" : count + 1,
                    "device_type": DeviceType.iOS.rawValue,
                    "sender": (dic.joined().replace(string: "\\", withString: "")) as Any
                ]
            case .android:
                json["mutableContent"] = true
                json["content-available"] = 1
                let dataKey: [String: Any] = ["user_id": kUserDefaults.getUserId(),
                                              "name": kUserDefaults.getFirstName(),
                                              "messageId": messageId,
                                              "jobId"  : jobId,
                                              "jobName"  : jobName]
                let _: [String: Any] = ["message":message,
                                           "title": kUserDefaults.getFirstName(),
                                           "notification_type": "50",
                                           "data_key": dataKey]
                json["data"] = dataKey//["body" : body]
            }
            ApiManager.prettyPrint(json: json, statusCode: 200)
            sendNotification(with: json)
            printDebug(json)
        }
    }
    
    private static func convertToJsonFormat(_ array : [String : Any]) -> String? {
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            //Convert back to string. Usually only do this for debugging
            return String(data: jsonData, encoding: String.Encoding.utf8)
            
        } catch {
            printDebug(error.localizedDescription)
        }
        return nil
    }
    
    /**
     Get device token of the user. Completion(device token and  device type)
     */
    static func getDeviceToken(userId: String, completion: @escaping (JSONDictionary)->()){
        getUserDetails(userId: userId) { (member) in
            if let object = member {
                print(JSON(member ?? ""))
                completion(object)
            }
        }
    }
    
    /// Hit service through URL session
    private static func sendNotification(with json : [String:Any]) {
        print("Sending Push Notification:")
        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAuTeicwc:APA91bEzBmgYwilKP3WkpZVp31g91YbLojHTftJbk_0Sc80gWZTRMRPaBZXMQZR-dcBJ5IGijVDFX_jFr2lk1fVoXBxsEwQ_h4olbSbyUy_Yg-psRJ51Wn-TnTxfoXg3wJvumbOkAwdH", forHTTPHeaderField: "Authorization")
        request.setValue("Cache-Control", forHTTPHeaderField: "no-cache")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    printDebug("Status Code should be 200, but is \(httpStatus.statusCode)")
                }
                let responseString = String(data: data, encoding: .utf8)
                printDebug(responseString)
            }
            task.resume()
        } catch {
            printDebug(error)
        }
    }
}
