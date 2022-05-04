//
//  CommonClasses.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift
import GoogleSignIn
import FirebaseAuth
import MobileCoreServices
import NotificationCenter
import AuthenticationServices
import UniformTypeIdentifiers

class CommonFunctions {

    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String) {
        
        guard let window = kAppDelegate.window else { return }
        
        if let vc = window.rootViewController {
            DispatchQueue.mainQueueAsync {
                vc.view.makeToast(msg)
            }
        }
        
        if let vc = window.rootViewController?.presentedViewController {
            DispatchQueue.mainQueueAsync {
                vc.view.makeToast(msg)
            }
        }
    }
    
    /// Delay Functions
    class func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()            
        }
    }
    
    class func getTextWithImage(startText: String, image: UIImage, imgSize: CGSize? = nil, endText: String, font: UIFont, color: UIColor, isEndTextBold: Bool = false) -> NSMutableAttributedString {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: startText)
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        
        //        image1Attachment.bounds.origin = CGPoint(x: 0.0, y: 5.0)
        let size = imgSize ?? image.size
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - size.height).rounded() / 2, width: size.width, height: size.height)
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        if isEndTextBold {
            let endStringAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
            let endAttributedString = NSAttributedString(string: "   " + endText, attributes: endStringAttribute)
            fullString.append(endAttributedString)
        } else {
            fullString.append(NSAttributedString(string: endText))
        }
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
    
    /// Show Action Sheet With Actions Array
    class func showActionSheetWithActionArray(_ title: String?, message: String?,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertActionArray.forEach{ alert.addAction($0) }
        
        DispatchQueue.mainQueueAsync {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    /// Show Activity Loader
    class func showActivityLoader() {
        Loader.show()
    }
    
    /// Hide Activity Loader
    class func hideActivityLoader() {
        Loader.hide()
    }
    
    class func scanLayer(frame:CGRect) -> CAShapeLayer {
        let height: CGFloat = frame.size.height
        let width: CGFloat = frame.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 50))
        path.move(to: CGPoint(x: 0, y: height-50))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 50, y: height))
        path.move(to: CGPoint(x: width - 50, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height - 50))
        path.move(to: CGPoint(x: width, y: 50))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width - 50, y: 0))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        shape.lineWidth = 5
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }
}


extension CommonFunctions {
    
    static let empty = ""
    static let price = "1234567890$."
    static let numbers = "1234567890"
    static let alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
    static let alphaNumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 1234567890"
    static let alphaNumericPunctuation = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 1234567890~!@#$%^&*()_+=-`{}|[]:;<>?,./"
    
    /// Allowed Characters & Max limit
    static func textValidation(allowedCharacters: String, textField: String, string: String, range: NSRange, numberOfCharacters: Int) -> Bool {
        ///
        let allowedCharacters = allowedCharacters
        let allowedCharacterset = CharacterSet(charactersIn: allowedCharacters)
        let typeCharacterset = CharacterSet(charactersIn: string)
        ///
        let boolC = allowedCharacterset.isSuperset(of: typeCharacterset)
        let currentText = textField
        ///
        guard let strRange = Range(range, in: currentText) else { return false }
        let updateText = currentText.replacingCharacters(in: strRange, with: string)
        let boolD = updateText.count <= numberOfCharacters
        return boolC && boolD
    }
    
    /// Allowed Characters
    static func textValidation(allowedCharacters: String, textField: String, string: String, range: NSRange) -> Bool {
        ///
        let allowedCharacters = allowedCharacters
        let allowedCharacterset = CharacterSet(charactersIn: allowedCharacters)
        let typeCharacterset = CharacterSet(charactersIn: string)
        ///
        let boolC = allowedCharacterset.isSuperset(of: typeCharacterset)
        return boolC
    }
    
    /// Characters limit
    static func textValidation(textField: String, string: String, range: NSRange, numberOfCharacters: Int) -> Bool {
        let currentText = textField
        ///
        guard let strRange = Range(range, in: currentText) else { return false }
        let updateText = currentText.replacingCharacters(in: strRange, with: string)
        let boolD = updateText.count <= numberOfCharacters
        return boolD
    }
    
    class func isConnectedToNetwork(isShowToast: Bool = false) -> Bool {
        var isConnected: Bool = false
        do {
            let connection = try Reachability.init().connection
            if connection != .unavailable {
                isConnected = true
            }
        }
        catch {
            isConnected = false
        }
        if isShowToast && !isConnected {
            showToastWithMessage(LS.noInternetConnection)
        }
        return isConnected
    }
}

extension CommonFunctions {
    
    static func getTextWithImageWithLink(startText: String, startTextColor: UIColor, middleText: String , image: UIImage, endText: String,endTextColor: UIColor , middleTextColor: UIColor , font: UIFont) -> NSMutableAttributedString {
        
        let fullString = NSMutableAttributedString()
        
        //Start Text SetUp
        let startTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: startTextColor] as [NSAttributedString.Key : Any]
        let startAttributedString = NSAttributedString(string: startText, attributes: startTextAttribute)
        
        //Middle Text SetUp
        let middleTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: middleTextColor] as [NSAttributedString.Key : Any]
        let middleAttributedString = NSAttributedString(string: middleText, attributes: middleTextAttribute)
        
        //Image SetUp
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        image1Attachment.image = image
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        //End Text SetUp
        let endTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: endTextColor] as [NSAttributedString.Key : Any]
        let endAttributedString = NSAttributedString(string: endText, attributes: endTextAttribute)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(startAttributedString)
        fullString.append(middleAttributedString)
        fullString.append(image1String)
        fullString.append(endAttributedString)
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
    
    static func getTextWithImage(image: UIImage, font: UIFont, count: Int = 1) -> NSMutableAttributedString {
        
        let fullString = NSMutableAttributedString()
        
        //Image SetUp
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        image1Attachment.image = image
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        for _ in 0..<count {
            fullString.append(image1String)
        }
        
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        return fullString
    }
    
    static func getTradieBuilderIds(senderId: String, receiverId: String, roomId: String) -> (String, String) {
        var tradieId = ""
        var builderId = ""

        if !roomId.isEmpty {
            let ids = roomId.split(separator: "_")
            tradieId = String(ids[1])
            builderId = String(ids[2])
        } else if kUserDefaults.isTradie() {
            if senderId == kUserDefaults.getUserId() {
                tradieId = senderId
                builderId = receiverId
            } else {
                tradieId = receiverId
                builderId = senderId
            }
        } else {
            if senderId == kUserDefaults.getUserId() {
                tradieId = receiverId
                builderId = senderId
            } else {
                tradieId = senderId
                builderId = receiverId
            }
        }
        return (tradieId, builderId)
    }
    //Arshh
    static func setUserDefaults(model: Any?) {
        if let userModel = model as? LoginData {
            kUserDefaults.set(true, forKey: UserDefaultKeys.kIsLoggedIn)
            kUserDefaults.set(userModel.id, forKey: UserDefaultKeys.kUserId)
            kUserDefaults.set(userModel.userName, forKey: UserDefaultKeys.kUsername)
            kUserDefaults.set(userModel.token, forKey: UserDefaultKeys.kAccessToken)
            kUserDefaults.set(userModel.trade?.first, forKey: UserDefaultKeys.kTrade)
            kUserDefaults.set(userModel.firstName, forKey: UserDefaultKeys.kFirstName)
            kUserDefaults.set(userModel.email, forKey: UserDefaultKeys.kLoggedInEmail)
            kUserDefaults.set(userModel.userImage, forKey: UserDefaultKeys.kProfileImage)
            kUserDefaults.set(userModel.mobileNumber, forKey: UserDefaultKeys.kPhoneNumber)
            kUserDefaults.setValue(userModel.specialization, forKey: UserDefaultKeys.kSpecialization)
            return
        }
        
        if let _ = model as? GIDGoogleUser {
            return
        }
        
        if let userModel = model as? LinkedInModel {
            kUserDefaults.set(true, forKey: UserDefaultKeys.kIsSocialLogin)
            kUserDefaults.setValue(AccountType.linkedIn.rawValue, forKey: UserDefaultKeys.kAccountType)
            kUserDefaults.set(userModel.id, forKey: UserDefaultKeys.kSocialId)
            let firstName = userModel.firstName?.localized?.en_US ?? ""
            let lastName = userModel.lastName?.localized?.en_US ?? ""
            kUserDefaults.set(firstName + " " + lastName , forKey: UserDefaultKeys.kFirstName)
            return
        }
        
        if let userModel = model as? ASAuthorizationAppleIDCredential {
            kUserDefaults.set(userModel.user, forKey: UserDefaultKeys.kSocialId)
            kUserDefaults.set(userModel.email ?? "N.A", forKey: UserDefaultKeys.kLoggedInEmail)
            kUserDefaults.set(userModel.fullName?.givenName ?? "N.A", forKey: UserDefaultKeys.kFirstName)
            kUserDefaults.set(true, forKey: UserDefaultKeys.kIsSocialLogin)
            kUserDefaults.setValue(AccountType.apple.rawValue, forKey: UserDefaultKeys.kAccountType)
            return
        }
    }
    
    static func removeUserDefaults() {        
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        if let domain = Bundle.main.bundleIdentifier {
            let token = kUserDefaults.getDeviceToken()
            kUserDefaults.removePersistentDomain(forName: domain)
            if token.count > 0 {
                kUserDefaults.set(token, forKey: UserDefaultKeys.kDeviceToken)
            }
        }
        
        kUserDefaults.set("", forKey: UserDefaultKeys.kAccessToken)
        kUserDefaults.set(false, forKey: UserDefaultKeys.kIsLoggedIn)
        kUserDefaults.set(false, forKey: UserDefaultKeys.kTutorialPlayed)
        IntercomHandler.shared.logout()
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func getScreenTypeFromJobStatus(_ jobStatus: JobStatus) -> ScreenType {
        var screenType: ScreenType = .openJobs
        switch jobStatus {
        case .expired:
            screenType = .pastJobsExpired
        case .open:
            screenType = .openJobs
        case .active:
            screenType = .activeJob
        case .completed, .cancelled:
            screenType = .pastJobsCompleted
        default:
            break
        }
        return screenType
    }
}

extension CommonFunctions {
    
    static func getFormattedDates(fromDate: Date?, toDate: Date? = nil) -> String {
        guard let fromDate = fromDate else { return CommonStrings.emptyString }
        if let toDate = toDate {
            if fromDate.year != toDate.year {
                if fromDate.year == Date().year {
                    return "\(fromDate.toString(dateFormat: Date.DateFormat.ddMMM.rawValue)) - \(toDate.toString(dateFormat: Date.DateFormat.ddMMMYYY.rawValue))"
                } else {
                    return "\(fromDate.toString(dateFormat: Date.DateFormat.ddMMMYYY.rawValue)) - \(toDate.toString(dateFormat: Date.DateFormat.ddMMMYYY.rawValue))"
                }
            } else if fromDate.year == toDate.year && fromDate.year != Date().year && toDate.year != Date().year {
                return "\(fromDate.toString(dateFormat: Date.DateFormat.ddMMMYYY.rawValue)) - \(toDate.toString(dateFormat: Date.DateFormat.ddMMMYYY.rawValue))"
            } else if fromDate.month != toDate.month {
                return "\(fromDate.toString(dateFormat: Date.DateFormat.ddMMM.rawValue)) - \(toDate.toString(dateFormat: Date.DateFormat.ddMMM.rawValue))"
            } else {
                return "\(fromDate.toString(dateFormat: Date.DateFormat.ddMMM.rawValue)) - \(toDate.toString(dateFormat: Date.DateFormat.ddMMM.rawValue))"
            }
        } else {
            return fromDate.year == Date().year ? fromDate.toString(dateFormat: Date.DateFormat.ddMMM.rawValue) : fromDate.toString(dateFormat: Date.DateFormat.ddMMMYYY.rawValue)
        }
    }

    static func setProgressBar(milestoneDone: Int, totalMilestone: Int, _ progressView: HorizontalProgressBar) {
        let progres = Double.getDouble(milestoneDone) / Double.getDouble(totalMilestone)
        if progres.isNaN {
            progressView.progress = 0
        } else {
            progressView.progress = CGFloat(progres)
        }
    }
    
    static func getAttributedText(milestonesDone: Int, totalMilestones: Int, forDetail: Bool = false) -> NSAttributedString {
        let leadingText = forDetail ? "Job milestones   " : "Job Milestones   \(milestonesDone)"
        let trailingText = forDetail ? "\(milestonesDone) of \(totalMilestones)" : " of \(totalMilestones)"
        let string = leadingText + trailingText
        ///
        let attributedString = NSMutableAttributedString(string: string)
        ///
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1), .font: UIFont.kAppDefaultFontBold(ofSize: 18)]
        attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: leadingText.count))
        ///
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1), .font: UIFont.systemFont(ofSize: 18)]
        attributedString.addAttributes(secondAttributes, range: NSRange(location: string.count - trailingText.count, length: trailingText.count))
        ///
        return attributedString
    }
    
    static func getCountedSpecialisations(dataArray: Any, count: Int = CommonStrings.maxSpeclCount) -> Any {
        if let array = dataArray as? [BuilderHomeSpecialisation] {
            if array.count <= count {
                return array
            }else {
                var countedArray: [BuilderHomeSpecialisation] = []
                for i in 0..<count {
                    countedArray.append(array[i])
                }
                countedArray.append(BuilderHomeSpecialisation(name: CommonStrings.more))
                return countedArray
            }
        }else if let array = dataArray as? [tradeSpecial] {
            if array.count <= count {
                return array
            }else {
                var countedArray: [tradeSpecial] = []
                for i in 0..<count {
                    countedArray.append(array[i])
                }
                countedArray.append(("", CommonStrings.more, .specialisation))
                return countedArray
            }
        }
        return []
    }
    
    static func getReasonsModel() -> [ReasonsModel] {
        var reasonModel: [ReasonsModel] = []
        let reasonsArray = ReasonsType.allCases
        ///
        for i in 0..<reasonsArray.count {
            reasonModel.append(ReasonsModel(type: reasonsArray[i]))
        }
        return reasonModel
    }

    static func getDisputeReasonsModel() -> [DisputeModel] {
        var reasonModel: [DisputeModel] = []
        let reasonsArray = DisputeReason.allCases
        ///
        for i in 0..<reasonsArray.count {
            reasonModel.append(DisputeModel(type: reasonsArray[i]))
        }
        return reasonModel
    }
    
    static func getSupportChatOptions() -> [SupportChatOptionModel] {
        var optionsModel: [SupportChatOptionModel] = []
        let optionsArray = SupportOptions.allCases
        ///
        for i in 0..<optionsArray.count {
            optionsModel.append(SupportChatOptionModel(type: optionsArray[i]))
        }
        return optionsModel
    }
    
    static func setMediaImage(_ imageViewer: UIImageView, type: MediaTypes, url: PhotosObject) {
        switch type {
        case .image:
            imageViewer.sd_setImage(with: URL(string: url.link), placeholderImage: nil)
        case .video:
            imageViewer.sd_setImage(with: URL(string: url.thumbnail ?? ""), placeholderImage: nil)
        case .doc:
            if let index = url.link.lastIndex(of: ".") {
                let _extension = url.link[index...]
                switch String(_extension) {
                case ".doc":
                    imageViewer.image = #imageLiteral(resourceName: "DOC-1")
                case ".txt":
                    imageViewer.image = #imageLiteral(resourceName: "TXT-1")
                case ".rtf":
                    imageViewer.image = #imageLiteral(resourceName: "RTF")
                default:
                    imageViewer.image = UIImage()
                }
            } else {
                imageViewer.image = UIImage()
            }
        case .pdf:
            imageViewer.image = #imageLiteral(resourceName: "PDF-1")
        }
    }
    
    static func openMedia(_ vc: BaseVC, mediaTypes: MediaTypes, url: String, image: UIImage? = nil, genericUrl: String?) {
        switch mediaTypes {
        case .image:
            let nextVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
            if let url = genericUrl {
                nextVC.urlString = url
            }else if let image = image {
                nextVC.image = image
            }
            vc.push(vc: nextVC)
        case .pdf, .doc:
            let nextVC = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
            nextVC.comingFromLocal = genericUrl.isNil
            nextVC.url = genericUrl ?? url
            vc.push(vc: nextVC)
        default:
            break
        }
    }
}
