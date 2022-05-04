//
//  MilestoneVC.swift
//  Tickt
//
//  Created by Admin on 14/05/21.
//

import SwiftyJSON
import Firebase

class MilestoneVC: BaseVC {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var disputeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var jobDetailButton: UIButton!
    @IBOutlet weak var popupBackButton: UIButton!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!    
    @IBOutlet weak var builderImageView: UIImageView!
    @IBOutlet weak var profileDetailButton: UIButton!
    @IBOutlet weak var milestoneTableView: UITableView!
    @IBOutlet weak var reviewLabel: CustomRegularLabel!
    @IBOutlet weak var declinedMilestoneCount: CustomBoldLabel!
    @IBOutlet weak var declineMilestoneHeightConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var jobId = ""
    var tradeId = ""
    var lastMilestoneId = ""
    var specializationId = ""
    let viewModel = MilestoneVM()
    var lastDeclinedMilestone = 0
    var completingMilestone = 1000
    var milestoneModel: JobMilestoneModel?
    static var milestoneData = MilestoneObject()
    static var recommmendedJob = RecommmendedJob()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        hitAPI()
    }
    
    func hitAPI() {
        viewModel.getMilestones(isPullToRefresh: false, jobId: jobId)
    }
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMilestone(_:)), name: NotificationName.refreshMilestoneList, object: nil)
        viewModel.delegate = self
        milestoneTableView.refreshControl = refreshControl
        milestoneTableView.registerCell(with: ButtonCell.self)
        milestoneTableView.registerCell(with: JobMilestoneCell.self)
        milestoneTableView.registerCell(with: MilestoneDeclineCell.self)
    }
    
    @objc func refreshMilestone(_ notification: Notification) {
        viewModel.getMilestones(isPullToRefresh: false, jobId: jobId)
    }
    
    @objc func pullToRefresh() {
        viewModel.getMilestones(isPullToRefresh: true, jobId: jobId)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case editButton:
            if popUpView.alpha == 0 {
                popUpView.popIn()
                popupBackButton.fadeIn()
                view.bringSubviewToFront(popUpView)
            } else {
                popUpView.popOut()
                popupBackButton.fadeOut()
                view.sendSubviewToBack(popUpView)
            }
        case jobDetailButton:
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            jobDetailVC.jobId = jobId            
            jobDetailVC.screenType = .activeJobDetail
            jobDetailVC.changeRequestClosure = { [weak self] in
                self?.pullToRefresh()
            }
            push(vc: jobDetailVC)
        case profileDetailButton:
            guard let builderId = milestoneModel?.result.postedBy.builderId else { return }
            let profileVC = BuilderProfileVC.instantiate(fromAppStoryboard: .profile)
            profileVC.jobId = jobId
            profileVC.jobName = milestoneModel?.result.jobName ?? ""
            profileVC.builderId = builderId
            push(vc: profileVC)
        case popupBackButton:
            popUpView.popOut()
            popupBackButton.fadeOut()
        case disputeButton:
            popUpView.popOut()
            let disputeVC = LodgeDisputeVC.instantiate(fromAppStoryboard: .lodgeDispute)
            disputeVC.jobId = jobId
            disputeVC.jobName = milestoneModel?.result.jobName ?? ""
            push(vc: disputeVC)
        case cancelButton:
            popUpView.popOut()
            let cancelJobVC = CancelJobVC.instantiate(fromAppStoryboard: .profile)
            cancelJobVC.jobId = jobId
            cancelJobVC.jobName = milestoneModel?.result.jobName ?? ""
            push(vc: cancelJobVC)
        case messageButton:
            sender.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sender.isUserInteractionEnabled = true
            }
            chatValidation()
        default:
            break
        }
    }
    
    private func chatValidation() {
        let tradieId = kUserDefaults.getUserId()
        guard let builderId = milestoneModel?.result.postedBy.builderId  else { return }
        let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderId)
        ChatHelper.checkInboxExistsFor(jobId: jobId, otherUserId: builderId, userId: tradieId, completion: { (exists) in
            var chatRoom: ChatRoom?
            if !exists {
                ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: builderId, unreadCount: 0, jobId: self.jobId, jobName: self.milestoneModel?.result.jobName ?? "")
            }
            ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                [weak self] (room) in
                guard let self = self else { return }
                if room != nil, !(room?.chatRoomId.isEmpty)! {
                    chatRoom = room
                } else {
                    chatRoom = ChatHelper.createRoom(jobId: self.jobId, tradieId: tradieId, builderId: builderId, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: builderId)])
                }
                
                if self.emptyCheck(array: [tradieId, self.jobId, chatRoom?.chatRoomId ?? "", builderId, self.milestoneModel?.result.jobName ?? ""]) {
                    let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                    chatVC.tradieId = tradieId
                    chatVC.jobId = self.jobId
                    chatVC.chatRoom = chatRoom!
                    chatVC.builderId = builderId
                    chatVC.jobName = self.milestoneModel?.result.jobName ?? ""
                    chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: tradieId, receiverId: builderId, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderId), otherUserUnreadCount: 0, jobId: self.jobId)
                    self.push(vc: chatVC)
                } else {
                    CommonFunctions.showToastWithMessage("Failed to fetch details")
                }
            })
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popUpView.popOut()
        popupBackButton.fadeOut()
    }
}
