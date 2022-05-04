//
//  AppDelegate+Notification.swift
//  Tickt
//
//  Created by Admin on 17/03/21.
//

import UIKit
import Firebase
import FirebaseMessaging

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func registerForRemoteNotification() {        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: {_, _ in })
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { (token, error) in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                kUserDefaults.setValue(token, forKey: UserDefaultKeys.kDeviceToken)
                self.updateDeviceToken()
            }
        }
    }
                
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let dict = userInfo["aps"] as? NSDictionary
        ApiManager.prettyPrint(json: dict ?? "", statusCode: 200)
        if application.applicationState == .active || application.applicationState == .background, let type = dict?["notificationType"] as? String, type == "31" {
            print("Testing")
        }
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let dict = notification.request.content.userInfo as? JSONDictionary {
            UIApplication.shared.applicationIconBadgeNumber = 0
            if let type = dict["notificationType"] as? String, type == "31" {
                kAppDelegate.getTradeList(callAPI: true)
                completionHandler([])
            } else  if let type = dict["gcm.notification.notification_type"] as? String, type == "50" {
                if let vc = UIApplication.getTopViewController() {
                    if vc.isKind(of: SingleChatVC.self),
                       let jsonString = dict["gcm.notification.sender"] as? String,
                       let senderDetail = getSenderDetail(jsonString: jsonString),
                       let matchingId = senderDetail["user_id"] as? String,
                       let jobId = dict["gcm.notification.jobId"] as? String {
                        let topVC = vc as! SingleChatVC
                        if kUserDefaults.isTradie() {
                            if topVC.builderId == matchingId, topVC.jobId == jobId {
                                completionHandler([])
                            } else {
                                completionHandler([.alert,.badge,.sound])
                            }
                        } else {
                            if topVC.tradieId == matchingId, topVC.jobId == jobId {
                                completionHandler([])
                            } else {
                                completionHandler([.alert,.badge,.sound])
                            }
                        }
                    } else if vc.isKind(of: InboxVC.self) {
                        completionHandler([])
                    } else {
                        completionHandler([.alert,.badge,.sound])
                    }
                } else {
                    completionHandler([.alert,.badge,.sound])
                }
            } else {
                completionHandler([.alert,.badge,.sound])
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo
        if let type = dict["notificationType"] as? String, type == "31" {
            kAppDelegate.getTradeList(callAPI: true)
        } else if let type = dict["gcm.notification.notification_type"] as? String, type == "50" {
            PushNotificationController.shared.openChatVC(dict: dict)
        } else if let payloadResponse: PushNotificationModel = self.handleSuccess(data: dict) {
            PushNotificationController.shared.redirectNotification(model: payloadResponse)
        }
        completionHandler()
    }
    
    func getSenderDetail(jsonString: String) -> JSONDictionary? {
        let data = (jsonString).data(using: .utf8) ?? Data()
        do {
            if let dict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? JSONDictionary {
                return dict
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}

extension AppDelegate {
    
    func printNotificationData(userInfo: String) {
        
        let dateString = Date().toString(dateFormat: "dd MM YYY, hh:mm:ss")
        if let newLine = "\n---------\(dateString)--------\n".data(using: .utf8) {
            DocumentManager.sharedManager.writeDataToLogFile(data: newLine, name: "Notification")
        }
        
        if let newLine = userInfo.data(using: .utf8) {
            DocumentManager.sharedManager.writeDataToLogFile(data: newLine, name: "Notification")
        }
        
        if let newLine = "\n----------------\n".data(using: .utf8) {
            DocumentManager.sharedManager.writeDataToLogFile(data: newLine, name: "Notification")
        }
    }
}
