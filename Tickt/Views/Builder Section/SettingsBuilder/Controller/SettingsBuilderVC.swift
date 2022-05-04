//
//  SettingsBuilder.swift
//  Tickt
//
//  Created by S H U B H A M on 11/07/21.
//

import UIKit

//CHAT: 1,
//PAYMENT: 2,
//ADMIN_UPDATE: 3,
//MILESTONE_UPDATE: 4,
//REVIEW: 5,
//VOUCH: 6,
//CHANGE_REQUEST: 7,
//CANCELATION: 8,
//DISPUTE: 9,
//QUESTION: 10

//case CHAT = "Chat"
//case PAYMENT = "Payment"
//case ADMIN_UPDATE = "Admin update"
//case MILESTONE_UPDATE = "Milestone Update"
//case REVIEW = "REVIEW"
//case VOUCH = "Vouch"
//case CHANGE_REQUEST = "Change Request"
//case CANCELATION = "Cancelation"
//case DISPUTE = "Dispute"
//case QUESTION = "Question"

class SettingsBuilderVC: BaseVC {
    
    enum SectionArray: String {
        
        case CHAT = "Chat"
        case PAYMENT = "Payment"
        case ADMIN_UPDATE = "New updates from admin"
        case MILESTONE_UPDATE = "Milestone updates"
        case REVIEW = "Job review updates"
        case CHANGE_REQUEST = "Change request updates"
        case CANCELATION = "Cancelation updates"
        case DISPUTE = "Dispute updates"
        case QUESTION = "Job queries updates"
        
        
//        var sectionSubText: String {
//            switch self {
//            case .message:
//                return "Receive messages from users, including messages about new applicants"
//            case .reminders:
//                return "Receive reminders about new applicants, reviews and others related to your activity on the Tickt"
//            case .CHAT:
//                return "Receive chats from users, including messages about new applicants"
//            case .PAYMENT:
//                return "Receive payments from users, including messages about new applicants"
//            case .ADMIN_UPDATE:
//                return "Receive admin update, including messages about new applicants"
//            case .MILESTONE_UPDATE:
//                return "Receive milestone update, including messages about new applicants"
//            case .REVIEW:
//                return "Receive review from users, including messages about new applicants"
//            case .VOUCH:
//                return "Receive vouch from users, including messages about new applicants"
//            case .CHANGE_REQUEST:
//                return "Receive changerequest from users, including messages about new applicants"
//            case .CANCELATION:
//                return "Receive cancellation from users, including messages about new applicants"
//            case .DISPUTE:
//                return "Receive dispute from users, including messages about new applicants"
//            case .QUESTION:
//                return "Receive question from users, including messages about new applicants"
//
//            }
//        }
        
        var sectionHeight: CGFloat {
            switch self {
//            case .message:
//                return 30
//            case.reminders:
//                return 45
            case .CHAT, .PAYMENT,.ADMIN_UPDATE,.MILESTONE_UPDATE, .REVIEW, .CHANGE_REQUEST,.CANCELATION,.DISPUTE, .QUESTION:
                return 20
            
            }
        }
        
        var keyValue: String {
            switch self {
////            case .message:
////                return "messages"
////            case.reminders:
//                return "reminders"
           
            case .CHAT:
                return "Chats"
            case .PAYMENT:
                return "Payments"
            case .ADMIN_UPDATE:
                return "New updates from admin"
            case .MILESTONE_UPDATE:
                return "Milestone update"
            case .REVIEW:
                return "Job review updates"
            case .CHANGE_REQUEST:
                return "Chnage requests updates"
            case .CANCELATION:
                return "Cancelation updates"
            case .DISPUTE:
                return "Dispute updates"
            case .QUESTION:
                return "Job queries updates"
                
            }
        }
        
        
        var keyIndex: Int {
            switch self {
            case .CHAT:
                return 1
            case .PAYMENT:
                return 2
            case .ADMIN_UPDATE:
                return 3
            case .MILESTONE_UPDATE:
                return 4
            case .REVIEW:
                return 5
            case .CHANGE_REQUEST:
                return 7
            case .CANCELATION:
                return 8
            case .DISPUTE:
                return 9
            case .QUESTION:
                return 10
                
            }
        }
        
    }
    
    
    enum TradieSectionArray: String {
        case CHAT = "Chat"
        case PAYMENT = "Payment"
        case New_ADMIN_UPDATE = "New updates from admin"
        case MILESTONE_UPDATE = "Milestone Updates"
        case JOB_REVIEW = "Job review updates"
        case VOUCH = "Vouch updates"
        case CHANGE_REQUEST = "Change Request updates"
        case CANCELATION = "Cancelation updates"
        case DISPUTE = "Dispute updates"
        case JOBANSWERs = "Job answer updates"
        
    
        var sectionHeight: CGFloat {
            switch self {
            case .CHAT, .PAYMENT,.New_ADMIN_UPDATE,.MILESTONE_UPDATE, .JOB_REVIEW,.VOUCH, .CHANGE_REQUEST,.CANCELATION,.DISPUTE, .JOBANSWERs:
                return 20
            
            }
        }
        
        var keyValue: String {
            switch self {
            case .CHAT:
                return "Chats"
            case .PAYMENT:
                return "Payments"
            case .New_ADMIN_UPDATE:
                return "New updates from admin"
            case .MILESTONE_UPDATE:
                return "Milestone Update"
            case .JOB_REVIEW:
                return "Job review updates"
            case .VOUCH:
                return "Vouch updates"
            case .CHANGE_REQUEST:
                return "Chnage Requests updates"
            case .CANCELATION:
                return "Cancelation updates"
            case .DISPUTE:
                return "Dispute updates"
            case .JOBANSWERs:
                return "Job answer updates"
                
            }
        }
        
        var keyIndex: Int {
            switch self {
            case .CHAT:
                return 1
            case .PAYMENT:
                return 2
            case .New_ADMIN_UPDATE:
                return 3
            case .MILESTONE_UPDATE:
                return 4
            case .JOB_REVIEW:
                return 5
            case .VOUCH:
                return 6
            case .CHANGE_REQUEST:
                return 7
            case .CANCELATION:
                return 8
            case .DISPUTE:
                return 9
            case .JOBANSWERs:
                return 10
                
            }
        }
        
    }
    
    enum CellArray: String {
        case subText = ""
        case email = "Email"
        case push = "Push-notifications"
        case smsMessages = "SMS messages"
        
        var keyValue: String {
            switch self {
            case .subText:
                return ""
            case .email:
                return "email"
            case .push:
                return "pushNotification"
            case .smsMessages:
                return "smsMessages"
            }
        }
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var model: SettingsBuilderResultModel? = nil
    var selectedPushArray = [Int]()
    var viewModel = SettingsBuilderVM()
   // var sectionArray: [SectionArray] = [.message, .reminders,.CHAT, .PAYMENT,.ADMIN_UPDATE,.MILESTONE_UPDATE, .REVIEW,.VOUCH, .CHANGE_REQUEST,.CANCELATION,.DISPUTE, .QUESTION]
    var sectionArray: [SectionArray] = [.CHAT, .PAYMENT,.ADMIN_UPDATE,.MILESTONE_UPDATE, .REVIEW, .CHANGE_REQUEST,.CANCELATION,.DISPUTE, .QUESTION]
    var tradieSectionArray: [TradieSectionArray] = [.CHAT, .PAYMENT,.New_ADMIN_UPDATE,.MILESTONE_UPDATE, .JOB_REVIEW,.VOUCH, .CHANGE_REQUEST,.CANCELATION,.DISPUTE, .JOBANSWERs]
    var cellArray: [CellArray] = [.subText, .email, .push, .smsMessages]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        pop()
    }
}

/*
 
 const USER_TRADIE_NOTIF = [
   { value: 'Chat', number: 1 },
   { value: 'Payment', number: 2 },
   { value: 'New updates from admin', number: 3 },
   { value: 'Milestone updates', number: 4 },
   { value: 'Job review updates', number: 5 },
   { value: 'Vouches updates', number: 6 },
   { value: 'Change request updates', number: 7 },
   { value: 'Cancelation updates', number: 8 },
   { value: 'Dispute updates', number: 9 },
   { value: 'Job answers updates', number: 10 }
 ];
 const USER_BUILDER_NOTIF = [
   { value: 'Chat', number: 1 },
   { value: 'Payment', number: 2 },
   { value: 'New updates from admin', number: 3 },
   { value: 'Milestone updates', number: 4 },
   { value: 'Job review updates', number: 5 },
   { value: 'Change request updates', number: 7 },
   { value: 'Cancelation updates', number: 8 },
   { value: 'Dispute updates', number: 9 },
   { value: 'Job queries updates', number: 10 }
 ];
 
 
 
 */
