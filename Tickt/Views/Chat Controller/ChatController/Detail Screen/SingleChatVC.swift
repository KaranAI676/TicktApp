//
//  MessagesVC.swift
//  Groupa
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
import Photos
import Foundation
import AVFoundation
import AssetsLibrary
import DZNEmptyDataSet
//import SKPhotoBrowser
import MobileCoreServices
import IQKeyboardManagerSwift
import SwiftyJSON

class SingleChatVC: BaseVC, ItemDataBookmarkDelegate {
            
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var openGalleryButton: UIButton!
    @IBOutlet weak var nameLabel: CustomRomanLabel!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var visitSupplierButton: UIButton!
    @IBOutlet weak var messageBoxTextView: UITextView!
    @IBOutlet weak var messageBoxContainerView: UIView!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBoxContainerViewHeightConstraint: NSLayoutConstraint!
    
    var jobId = ""
    var jobName = ""
    var imageURL = ""
    var tradieId: String!
    var builderId: String!
    var finalVideoUrl = ""
    var chatRoom: ChatRoom!
    var otherUserId = String()
    var chatImages = UIImage()
    var messages: [ChatMessage] = []
    var exportSession: AVAssetExportSession!
    var chatController: SingleChatController!
    private var shouldShowNoDataMessage = false
    private let messageBoxMinBottom: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    deinit {
        debugPrint("SingleChatVC released memory")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatController!.addObservers()
        addKeyBoardObserver()
        kAppDelegate.setUpKeyboardSetup(status: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatController!.removeObservers()
        removeKeyboardObserver()
        kAppDelegate.setUpKeyboardSetup(status: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageBoxContainerView.drawShadow()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        pop()
    }
    
    func bookmarkUpdation(model: ItemDataModel) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func initialSetUp() {
        if var controllers = navigationController?.viewControllers, controllers.count > 1 {
            let currentVC = controllers[controllers.count - 1]
            let lastVC = controllers[controllers.count - 2]
            if currentVC.isKind(of: SingleChatVC.self) && lastVC.isKind(of: SingleChatVC.self) {
                controllers.remove(object: lastVC)
            }
        }
        messageBoxTextView.text = ""
        jobNameLabel.text = jobName
        chatTableView.allowsSelection = true
        chatTableView.registerCell(with: SenderTC.self)
        chatTableView.registerCell(with: ReceiverTC.self)
        chatTableView.registerCell(with: SentImageTextCell.self)
        chatTableView.registerCell(with: ReceivedImageTextCell.self)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.estimatedRowHeight = 50
        chatTableView.rowHeight = UITableView.automaticDimension
        chatController!.delegate = self
        chatTableView.emptyDataSetSource = self
        messageBoxTextView.delegate = self
        chatController!.reloadRowAtIndex = { (indexPath) in
            printDebug(indexPath)
        }
        if kUserDefaults.isTradie() {
            visitSupplierButton.setTitleForAllMode(title: "Visit Builder Profile")
        } else {
            visitSupplierButton.setTitleForAllMode(title: "Visit Tradie Profile")
        }
    }
    
    @IBAction func visitSupplierProfile(_ sender: Any) {
        if kUserDefaults.isTradie() { //Tradie Login
            if let vc = navigationController?.viewControllers.first(where: { $0 is BuilderProfileVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                let profileVC = BuilderProfileVC.instantiate(fromAppStoryboard: .profile)
                profileVC.builderId = builderId
                push(vc: profileVC)
            }
        } else { //Builder Login
            if let vc = navigationController?.viewControllers.first(where: { $0 is TradieProfilefromBuilderVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
                vc.tradieId = tradieId
                push(vc: vc)
            }
        }
    }
    
    func scrollToLastMessageAfterSending() {
        let section = chatController!.organisedKeys.count
        if let row = chatController!.organisedData["Today"]?.count{
            chatTableView.scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .none, animated: false)
        }
    }
    
    private func scrollToLastMessage() {
        if let visibleIndexPath = chatTableView.indexPathsForVisibleRows {
            let section = chatController!.organisedKeys.count
            if let count = chatController!.organisedData[chatController!.organisedKeys[section - 1]]?.count{
                for index in visibleIndexPath{
                    if index.row >= count - 4 && index.row <= count - 1{
                        chatTableView.scrollToRow(at: IndexPath(row: count - 1, section: section - 1), at: .bottom, animated: false)
                        break
                    }
                }
            }
        }
    }
    
    func updateTextViewContainer(_ textView: UITextView) {
        let oneLineHeight = textView.font?.lineHeight ?? 0.0
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        if newSize.height < 6 * oneLineHeight {
            textView.frame = newFrame
            self.messageBoxContainerViewHeightConstraint.constant = newSize.height
        } else { }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func sendImage(mimeType: MimeTypes) {
        let roomId = chatController.roomId ?? chatController.chatRoom.chatRoomId
        let rcvID = chatController!.chatMember.userId
        var message: ChatMessage?
        message = MessageComposer.composeImageMessage(mediaUrl: " ", roomId: roomId, receiverId: rcvID, isBlock: false, timeStamp: (Double(Date().millisecondsSince1970)), mimeType: mimeType)
        if var message = message {
            message.image = chatImages
            message.messageStatus =  DeliveryStatus(rawValue: DeliveryStatus.uploading.rawValue) ?? .read
            var messageToDisplay = message
            messageToDisplay.messageTimestamp = Double((Date().millisecondsSince1970))
            self.messages.append(messageToDisplay)
            if let _ = self.messages.firstIndex(of: message) {
                chatController!.refreshMessageData(message)
            }
            uploadImages(msg: message, mimeType: mimeType)
        }
    }
    
    private func uploadImages(msg: ChatMessage, mimeType: MimeTypes) {
        var message = msg
        var data: (Data, MimeTypes) = (Data(), .imageJpeg)
        if mimeType == .imageJpeg {
            data = (chatImages.jpegData(compressionQuality: 0.5) ?? Data(), MimeTypes.imageJpeg)
        } else {
            do {
                if let url =  URL(string: finalVideoUrl) {
                    let dataObject = try Data(contentsOf: url)
                    data = (dataObject, .videoMp4)
                }
            } catch  {
                printDebug("Video doesn't covert")
            }
        }
        let params: [String: Any] = [ApiKeys.file: [data]]
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: params, methodType: .post, showLoader: true, result: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        if let url = serverResponse.result?.url?.first {
                            if mimeType == .imageJpeg {
                                self.imageURL = url
                            } else {
                                self.finalVideoUrl = url
                            }
                            message.mediaURL = url
                            message.messageStatus = DeliveryStatus(rawValue: DeliveryStatus.send.rawValue) ?? .read
                            self.chatController.sendImageOnMessage(mediaMessage: message)
                        }
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to upload images")
                        CommonFunctions.hideActivityLoader()
                    }
            case .failure(let error):
                CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "Unknown error")
            default:
                break
            }
        }, onProgress: { (progress) in
            print(progress)
        })
    }
    
    @IBAction func sendMessageButtonTapped(_ sender:UIButton) {
        if let msg = messageBoxTextView.text , !msg.isEmpty {
            chatController!.sendTextMessage(text: msg)
        }
    }
    
    @IBAction func openGalleryPressed(_ sender: UIButton) {
        goToCommonPopupVC()
    }
    
    private func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.video, .photo, .gallery]
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}

extension SingleChatVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        chatController!.updateTyping(status: true)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        chatController!.updateTyping(status: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        chatController!.updateTyping(status: false)
    }
}

extension SingleChatVC {
    
    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attribs = [NSAttributedString.Key.font : UIFont.kAppDefaultFontBold(ofSize: 16),
                       NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let message = NSAttributedString(string: "Send your first message", attributes: attribs)
        return message
    }
    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return shouldShowNoDataMessage
    }
}

extension SingleChatVC: SingleChatControllerDelegate {
    
    func didUserFetched(user: JSONDictionary) {        
        nameLabel.text = user["name"] as? String ?? "N.A"
        profileImageView.sd_setImage(with: URL(string: user["image"] as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
    }
    
    func messagesStatus(isEmpty: Bool) {
        shouldShowNoDataMessage = isEmpty
        chatTableView.reloadData()
    }
    
    func didChangeTypingStatus(sender: SingleChatController, isTyping: Bool) {
        printDebug("Typing: \(isTyping)")
    }
    
    func didSendMessage(sender: SingleChatController, message: ChatMessage) {
        messageBoxTextView.text = ""
        if !chatController!.organisedData.isEmpty {
            scrollToLastMessageAfterSending()
            self.chatTableView.scrollToBottom()
        }        
        chatTableView.reloadData()
    }
    
    func didGetMessages(sender: SingleChatController, organisedData: [String : [ChatMessage]]) {
        chatTableView.reloadData()
        scrollToLastMessage()
        if !organisedData.isEmpty {
            self.chatTableView.scrollToBottom()
        }
    }
    
    func didChangeOnlineStatus(sender: SingleChatController, status: String) {
        
    }
    
    func didUpdateChatMember(sender: SingleChatController, updatedKey key: ChatmemberKeys) {
        
    }
}
