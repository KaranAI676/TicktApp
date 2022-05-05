//
//  ChatController.swift
//  Tickt
//
//  Created by Tickt on 17/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class InboxVC: BaseVC, UISearchBarDelegate {
  
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var inboxTableView: UITableView!
        
    let inboxController = InboxController()
    private var shouldShowNoDataMessage = false
    private var isSearch = false
    var chats: [Inbox] { return inboxController.inboxList }
    var filteredChats: [Inbox] {
        if let text = searchBar.text?.lowercased(),!text.isEmpty {
            isSearch = true
            var chats = [Inbox]()
            var items = [Inbox]()
            items = inboxController.inboxList.filter({($0.jobName ?? "").lowercased().contains(s: text) || ($0.username ?? "").lowercased().contains(s: text)})
            for item in items {
                let chat = inboxController.inboxList.first(where: {$0.jobId == item.jobId})
                if chat.isNotNil {
                    chats.append(chat!)
                }
            }
            return chats
        } else {
            isSearch = false
            return inboxController.inboxList
        }
    }
        //Tradie: 612dd90d1008f6661b3dff2e, Builder: 612ddef11008f6661b3dff30
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)        
        inboxController.observeInbox()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inboxTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEditing()
        isSearch = false
        searchBar.text = ""
        searchButton.isHidden = false
        searchBar.isHidden = true
        screenTitle.isHidden = false
        inboxTableView.reloadData()
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        searchButton.isHidden = true
        searchBar.isHidden = false
        screenTitle.isHidden = true
    }
    
    func initialSetup() {
        inboxController.delegate = self
        inboxTableView.isHidden = true
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        inboxTableView.registerCell(with: InboxTableViewCell.self)
        inboxTableView.separatorStyle = .none
        inboxTableView.emptyDataSetSource = self
        inboxTableView.emptyDataSetDelegate = self
    }
}

extension InboxVC: InboxControllerDelegate {
    
    func didFailToFetchInbox(error: Error) {
        CommonFunctions.showToastWithMessage(error.localizedDescription)
    }
        
    func willFetchInbox() {
        
    }
    
    func didFetchInbox(message: String) {
        inboxTableView.isHidden = false
        inboxTableView.reloadData()
    }
    
    func inboxChangesOccurs() {
        
    }
    
    func reloadRow(at index: Int) {
        inboxTableView.isHidden = false
        inboxTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func deleteRow(at index: Int) {
        inboxTableView.isHidden = false
        inboxTableView.reloadData()
    }
    
    func inboxStatus(isEmpty: Bool) {
        inboxTableView.isHidden = false
        shouldShowNoDataMessage = isEmpty
        inboxTableView.reloadData()
    }
    
    func updateAllChatUnreadCount(unreadCount: Int) {
        if kUserDefaults.isTradie() {
            self.tabBarController?.tabBar.items![2].badgeValue = unreadCount == 0 ? nil : "\(unreadCount)"
        } else {
            self.tabBarController?.tabBar.items![3].badgeValue = unreadCount == 0 ? nil : "\(unreadCount)"
        }
    }
}

extension InboxVC {
   override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let attribs = [NSAttributedString.Key.font : UIFont.kAppDefaultFontBold(ofSize: 16),
                   NSAttributedString.Key.foregroundColor: AppColors.themeBlue]
        let message = NSAttributedString(string: "Chat will appear here for your jobs", attributes: attribs)
        return message
    }
    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return shouldShowNoDataMessage
    }
}

extension InboxVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredChats.count
    }
    
    private func chatValidation(inbox: Inbox) {
        let senderId = inbox.lastMessage?.senderId ?? ""
        let receiverId = inbox.lastMessage?.receiverId ?? ""
        let ids = CommonFunctions.getTradieBuilderIds(senderId: senderId, receiverId: receiverId, roomId: inbox.roomId)
        let tradieId = ids.0
        let builderId = ids.1
        let otherUserId = !kUserDefaults.isTradie() ? tradieId : builderId        
        let chatRoom: ChatRoom = inbox.chatRoom!
        let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
        if kUserDefaults.isTradie() {
            if self.emptyCheck(array: [tradieId, inbox.roomId, builderId, inbox.jobId ?? "", inbox.jobName ?? ""]) {
                ChatHelper.getUnreadMessagesTradie(tradieId: tradieId, builderId: builderId, jobId: inbox.jobId!) { unreadCount in
                    chatVC.tradieId = tradieId
                    chatVC.chatRoom = chatRoom
                    chatVC.jobId = inbox.jobId!
                    chatVC.builderId = builderId
                    chatVC.jobName = inbox.jobName ?? ""
                    chatVC.chatController = SingleChatController(roomId: inbox.roomId, senderId: kUserDefaults.getUserId(), receiverId: otherUserId, chatRoom: chatRoom, chatMember: ChatMember(userId: builderId), otherUserUnreadCount: unreadCount, jobId: inbox.jobId!)
                    self.push(vc: chatVC)
                }
            } else {
                CommonFunctions.showToastWithMessage("Failed to fetch Some details")
            }
        } else {
            if self.emptyCheck(array: [tradieId, inbox.roomId, builderId, inbox.jobId ?? "", inbox.jobName ?? ""]) {
                ChatHelper.getUnreadMessagesBuilder(tradieId: tradieId, builderId: builderId, jobId: inbox.jobId!) { unreadCount in
                    chatVC.tradieId = tradieId
                    chatVC.chatRoom = chatRoom
                    chatVC.jobId = inbox.jobId!
                    chatVC.builderId = builderId
                    chatVC.jobName = inbox.jobName ?? ""
                    chatVC.chatController = SingleChatController(roomId: inbox.roomId, senderId: kUserDefaults.getUserId(), receiverId: otherUserId, chatRoom: chatRoom, chatMember: ChatMember(userId: builderId), otherUserUnreadCount: unreadCount, jobId: inbox.jobId!)
                    self.push(vc: chatVC)
                }
            } else {
                CommonFunctions.showToastWithMessage("Failed to fetch Some details")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: InboxTableViewCell.self)
        if indexPath.row < filteredChats.count {
            inboxTableView.isHidden = false
            let inbox = filteredChats[indexPath.row]
            cell.populate(inbox: inbox)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < filteredChats.count {
            let inbox = filteredChats[indexPath.row]
            self.chatValidation(inbox: inbox)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension InboxVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { [weak self] (index) in
            guard let `self` = self else { return }
            if index.row < chats.count {
                let inbox = self.chats[index.row]
                print(inbox.userImage ?? "")
//                    UIImageView.cacheImage(url: itemObject.itemUrl)
            }
        }
    }
}
