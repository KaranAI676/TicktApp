//
//  CheckApproveBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 17/05/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CheckApproveBuilderVC: BaseVC {
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    ///
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var editMilestoneButton: UIButton!
    @IBOutlet weak var lodgeDisputeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    ///
    @IBOutlet weak var postedByView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: CustomBoldLabel!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var reviewLabel: CustomRegularLabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var upperForwardButton: UIButton!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomForwardButton: UIButton!
    
    //MARK:- Variables
    var model: CheckApproveBuilderModel? {
        didSet {
            self.tableViewOutlet.reloadData()
        }
    }
    var jobId: String = ""
    var viewModel = CheckApproveBuilderVM()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.popUpView.popOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.popUpView.popOut()
    }
    
    deinit {
        kAppDelegate.totalMilestonesNonApproved = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.popUpView.popOut()
        disableButton(sender)
        switch sender {
        case backButton:
            self.pop()
        case editButton:
            let _ = self.popUpView.alpha == 0 ? self.popUpView.popIn() : self.popUpView.popOut()
        case editMilestoneButton:
            goToEditMilestoneVC()
        case lodgeDisputeButton:
            goToLodgeDisputeVC()
        case cancelButton:
            goToCancelJobVC()
        case bottomForwardButton:
            self.goToDetailVC()
        case upperForwardButton:
            goToTradieVC()
        case messageButton:
            sender.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sender.isUserInteractionEnabled = true
            }
            goToMessageVC()
        default:
            break
        }
    }
}

extension CheckApproveBuilderVC {
    
    private func initialSetup() {
        setupTableView()
        popUpView.alpha = 0
        viewModel.delegate = self
        hitApi()
        NotificationCenter.default.addObserver(self, selector: #selector(getApprovedDeclinedMilestone(_:)), name: NotificationName.milestoneAcceptDecline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeRequestBuilderRefresh), name: NotificationName.changeRequestBuilder, object: nil)
    }
    
    func hitApi() {
        self.viewModel.getMilestonesList(self.jobId)
    }
    
    private func setupTableView() {
        self.tableViewOutlet.refreshControl = refresher
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        self.tableViewOutlet.registerCell(with: CheckApproveBottomTableCell.self)
        self.tableViewOutlet.registerCell(with: CheckApproveTableCell.self)
    }
    
    private func populateData() {
        guard let model = self.model?.result else { return }
        self.navTitleLabel.text = model.jobName
        self.userNameLabel.text = model.tradie?.tradieName
        self.reviewLabel.text = ("\(model.tradie?.ratings ?? 0), \(model.tradie?.reviews ?? 0) reviews")
        self.profileImageView.sd_setImage(with: URL(string:(model.tradie?.tradieImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
    }
    
    private func setPlaceHolder() {
        self.postedByView.isHidden = !((self.model?.result.milestones?.count ?? 0) > 0)
        self.editButton.isHidden = self.postedByView.isHidden
    }
    
    private func goToApproveDeclineVC(_ index: Int) {
        
        let vc = ApproveDeclineDetailBuilderVC.instantiate(fromAppStoryboard: .approveDeclineDetailBuilder)
        if let modelObject = self.model?.result,
           let milestoneObject = modelObject.milestones?[index],
           let status = MilestoneStatus.init(rawValue: modelObject.milestones?[index].status ?? 0) {
            TicketMoengage.shared.postEvent(eventType: .milestoneCheckedAndApproved(category: "", timestamp: "", milestoneNumber: index))
            ///
            vc.canDecline = milestoneObject.declinedCount <= 5
            kAppDelegate.totalMilestonesNonApproved = getRemainingNonApprovedMilestones()
            ///
            let milestoneData = PaymentDetailBuilderModel(milestoneId: milestoneObject.milestoneId,
                                              milestoneName: milestoneObject.milestoneName,
                                              milestoneStatus: status,
                                              milestoneAmount: milestoneObject.milestoneAmount,
                                              taxes: milestoneObject.taxes,
                                              platformFees: milestoneObject.platformFees,
                                              total: milestoneObject.total,
                                              hoursWorked: milestoneObject.hoursWorked,
                                              hourlyRate: milestoneObject.hourlyRate)
            vc.paymentDetailModel = ApproveDeclineMilestoneModel(jobId: modelObject.jobId ?? "",
                                                                 jobName: modelObject.jobName ?? "",
                                                                 tradieId: modelObject.tradieId ?? "",
                                                                 milestoneData: milestoneData)
            self.push(vc: vc)
        }
    }
    
    private func getRemainingNonApprovedMilestones() -> Int {
        let nonApprovedModel = model?.result.milestones?.filter({ eachModel in
            return (eachModel.status == 0) || (eachModel.status == 1)
        })
        return nonApprovedModel?.count ?? 0
    }
    
    private func goToDetailVC() {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.jobId = self.jobId
        vc.screenType = .activeJob
        self.push(vc: vc)
    }

    private func goToMessageVC() {
        let tradieId = model?.result.tradieId ?? ""
        let builderId = kUserDefaults.getUserId()
        let conversationId = ChatHelper.getConversationId(jobId: jobId, tradieId: tradieId, buidlerId: builderId)
        ChatHelper.checkInboxExistsFor(jobId: jobId, otherUserId: builderId, userId: tradieId, completion: { (exists) in
            var chatRoom: ChatRoom?
            if !exists {
                ChatHelper.updateInboxForConversationId(roomId: conversationId, tradieId: tradieId, builderId: builderId, unreadCount: 0, jobId: self.jobId, jobName: self.model?.result.jobName ?? "")
            }
            ChatHelper.getChatRoomDetails(roomId: conversationId, completion: {
                  [weak self] (room) in
                guard let self = self else { return }
                if room != nil, !(room?.chatRoomId.isEmpty)! {
                    chatRoom = room
                } else {
                    chatRoom = ChatHelper.createRoom(jobId: self.jobId, tradieId: tradieId, builderId: builderId, type: .single, members: [ChatMember(userId: tradieId), ChatMember(userId: builderId)])
                }
                
                if self.emptyCheck(array: [tradieId, self.jobId, chatRoom?.chatRoomId ?? "", builderId, self.model?.result.jobName ?? ""]) {
                    let chatVC = SingleChatVC.instantiate(fromAppStoryboard: .chat)
                    chatVC.tradieId = tradieId
                    chatVC.jobName = self.model?.result.jobName ?? ""
                    chatVC.jobId = self.jobId                    
                    chatVC.chatRoom = chatRoom!
                    chatVC.builderId = builderId
                    chatVC.chatController = SingleChatController(roomId: chatRoom!.chatRoomId, senderId: builderId, receiverId: tradieId, chatRoom: chatRoom!, chatMember: ChatMember(userId: builderId), otherUserUnreadCount: 0, jobId: self.jobId)
                    self.push(vc: chatVC)
                } else {
                    CommonFunctions.showToastWithMessage("Failed to fetch details")
                }
            })
        })
    }
    
    private func goToTradieVC() {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.jobId = self.jobId
        vc.tradieId = self.model?.result.tradie?.tradieId ?? ""
        vc.jobName = self.model?.result.jobName ?? ""
        self.push(vc: vc)
    }
    
    private func goToCancelJobVC() {
        let vc = CancelJobBuilderVC.instantiate(fromAppStoryboard: .cancelJobBuilder)
        vc.jobId = self.jobId
        vc.jobName = self.model?.result.jobName ?? ""
        push(vc: vc)
    }
    
    private func goToLodgeDisputeVC() {
        let vc = LodgeDisputeVC.instantiate(fromAppStoryboard: .lodgeDispute)
        vc.jobId = self.jobId
        vc.jobName = self.model?.result.jobName ?? ""
        push(vc: vc)
    }
    
    private func goToEditMilestoneVC() {
        let vc = MilestoneListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .milestoneChangeRequest
        vc.jobName = self.model?.result.jobName ?? ""
        vc.jobId = jobId
        vc.tradieId = self.model?.result.tradieId ?? ""
        let milestoneArray = self.model?.result.milestones?.map({ eachModel -> MilestoneModel in
            return MilestoneModel(eachModel)
        })
        if var object = milestoneArray {
            for i in 0..<object.count {
                object[i].order = i+1
            }
            vc.milestonesArray = object
            vc.tempMilestoneArray = object
            vc.constantMilestoneArray = object
            push(vc: vc)
        }
    }
    
    private func checkRemainingMilestones() {
        let index = model?.result.milestones?.firstIndex(where: { eachModel -> Bool in
            return eachModel.status == 0
        })
        
        if index == nil {
            self.pop()
        }
    }
    
    private func enableFirstCompletedMilestone() {
        let index = model?.result.milestones?.firstIndex(where: { eachModel -> Bool in
            return (MilestoneStatus.init(rawValue: eachModel.status) ?? .notComplete) == .completed
        })
        if let index = index {
            model?.result.milestones?[index].statusButtonCanInteract = true
        }
        tableViewOutlet.reloadData()
    }
    
    
    @objc func changeRequestBuilderRefresh() {
        self.viewModel.getMilestonesList(self.jobId)
    }
    
    
    @objc func pullToRefresh() {
        self.viewModel.getMilestonesList(self.jobId, isPullToRefresh: true)
    }
    
    @objc func getApprovedDeclinedMilestone(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let milestoneId = userInfo[ApiKeys.milestoneId] as? String, let status = userInfo[ApiKeys.status] as? Int {
            let index = model?.result.milestones?.firstIndex(where: { eachModel -> Bool in
                return eachModel.milestoneId == milestoneId
            })
            
            if let index = index {
                model?.result.milestones?[index].status = status
                if MilestoneStatus.init(rawValue: status) ?? .notComplete == .declined {
                    model?.result.milestones?[index].declinedCount += 1
                }
                enableFirstCompletedMilestone()
                tableViewOutlet.reloadData()
            }
        }
    }
}

extension CheckApproveBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.setPlaceHolder()
        return self.model?.result.milestones?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CheckApproveTableCell.self)
        cell.tableView = tableView
        ///
        guard let model = self.model?.result else { return UITableViewCell() }
        cell.model = model.milestones?[indexPath.row]
        cell.buttonClosure = { [weak self] (index, type) in
            guard let self = self else { return }
            switch type {
            case .status:
                let bool = self.model?.result.milestones?[index.row].isSelected ?? false
                self.model?.result.milestones?[index.row].isSelected = !bool
                tableView.reloadData()
            case .checkApprove:
                self.goToApproveDeclineVC(indexPath.row)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popUpView.popOut()
    }
}

//MARK:- CheckApproveBuilderVM: Delegate
//======================================
extension CheckApproveBuilderVC: CheckApproveBuilderVMDelegate {
    
    func success(model: CheckApproveBuilderModel) {
        self.model = model
        populateData()
        enableFirstCompletedMilestone()
        refresher.endRefreshing()
    }
    
    func failure(error: String) {
        refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(error)
    }
}
