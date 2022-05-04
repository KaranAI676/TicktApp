//
//  Moengage.swift
//  Sway
//
//  Created by Admin on 26/10/21.
//

import Foundation
import Segment_MoEngage
import MoEngage
import Mixpanel


enum TicketMoengageCase {
    case logout(success_status:Bool,current_page:String) //Done
    case appOpen(app_open:Bool) //Done
    case signup(status:Bool,source:String,name:String,email:String,platform:String) //Done
    case searchedForTradies(timestamp:String,category:String,location:String,maxbudget: NSNumber,lengthOfHire:NSNumber,startDate:Date,endDate:Date) //Done
    case viewedTradieProfile(name:String,category:String,location:NSNumber) //Done
    case postedaJob(timestamp:String,category:String,location:String,numberOfMilestones:Int,startDate:Date,endDate:Date) //Done
    case viewQuote(timestamp:String) //Done
    case acceptQuote(timestamp:String)
    case cancelQuotedJob(timestamp:String)
    case milestoneCheckedAndApproved(category:String,timestamp:String,milestoneNumber:Int)
    case madePayment(category:String,timestamp:String)
    case milestoneDeclined(timestamp:String)
    case savedTradie(category:String,timestamp:String)
    case chat(timestamp:String)
    case viewedReviews(timestamp:String)
    case leftVoucher(timestamp:String)
    case paymentSuccess(timestamp:String)
    case paymentFailure(timestamp:String)
    case editMilestones(timestamp:String)
    case cancelJob(timestamp:String)
    case republishedJob(timestamp:String)
    case addedInfoAboutCompany(timestamp:String)
    case addedPortfolio(timestamp:String)
    case addedPaymentDetails(timestamp:String)
    case addedReview(timestamp:String)  //Done
    case acceptCancellation(timestamp:String)
    case rejectCancellation(timestamp:String)
    case viewedBuilderProfile(name:String,category:String,location:String)  //Done
    case quotedAJob(timestamp:String,category:String,location:String,numberOfMilestones:Int,amount:Double) //Done
    case askedAQuestion(timestamp:String) //Done
    case appliedForAJob(timestamp:String) //Done
    case milestoneCompleted(category:String,timestamp:String,milestoneNumber:Int)  //Done
    case viewedApprovedMilestone(category:String,timestamp:String,milestoneNumber:Int) //Done
    
    
    
    var keyValues:[String:MixpanelType] {
        let timeStamp = Date().toString(dateFormat: Date.DateFormat.yyyyMMddTHHmmssssZZZZZ.rawValue)
        switch self {
        case .logout(let success_status,let current_page):
            return ["success_status":success_status,"current_page":current_page]
        case .appOpen(let app_open):
            return ["app_open":app_open]
        case .signup(let status,let source,let name,let email,let platform):
            return ["success_status":status,"name":name,"sign up source":source,"email":email,"Platform":platform]
        case .searchedForTradies(let timestamp, let category,let location, let maxbudget,let lengthOfHire, let startDate, let endDate):
            return ["timestamp":timestamp,"category":category,"location":location,"Max budget" :maxbudget,"length of hire":lengthOfHire,"start date":startDate,"end date":endDate]
        case .viewedTradieProfile(let Name,let category,let location):
            return ["Name":Name,"category":category,"location":location]
        case .postedaJob(_,let category, let location,let numberOfMilestones, let startDate, let endDate):
            return ["timestamp":timeStamp,"category":category,"location":location,"Number of milestonese":numberOfMilestones,"start date":startDate,"end date":endDate]
        case .viewQuote(_):
            return ["timestamp":timeStamp]
        case .acceptQuote(_):
            return ["timestamp":timeStamp]
        case .cancelQuotedJob(_):
            return ["timestamp":timeStamp]
        case .milestoneCheckedAndApproved(let category,_,let milestoneNumber):
            return ["Category":category,"Timestamp":timeStamp,"Milestone number":milestoneNumber]
        case .madePayment(let category,_):
            return ["Category":category,"Timestamp":timeStamp]
        case .milestoneDeclined(let timestamp):
            return ["Timestamp":timestamp]
        case .savedTradie(let category,_):
            return ["Category":category,"Timestamp":timeStamp]
        case .chat(_):
            return ["Timestamp":timeStamp]
        case .viewedReviews(_):
            return ["Timestamp":timeStamp]
        case .leftVoucher(_):
            return ["Timestamp":timeStamp]
        case .paymentSuccess(_):
            return ["Timestamp":timeStamp]
        case .paymentFailure(_):
            return ["Timestamp":timeStamp]
        case .editMilestones(_):
            return ["Timestamp":timeStamp]
        case .cancelJob(_):
            return ["Timestamp":timeStamp]
        case .republishedJob(_):
            return ["Timestamp":timeStamp]
        case .addedInfoAboutCompany(_):
            return ["Timestamp":timeStamp]
        case .addedPortfolio(_):
            return ["Timestamp":timeStamp]
        case .addedPaymentDetails(_):
            return ["Timestamp":timeStamp]
        case .addedReview(_):
            return ["Timestamp":timeStamp]
        case .acceptCancellation(_):
            return ["Timestamp":timeStamp]
        case .rejectCancellation(_):
            return ["Timestamp":timeStamp]
        case .viewedBuilderProfile(let Name,let category,let location):
            return ["Name":Name,"category":category,"location":location]
        case .quotedAJob(_,let category,let location,let numberOfMilestones,let amount):
            return ["Timestamp":timeStamp,"category":category,"location":location,"Number of milestones":numberOfMilestones,"Amount":amount]
        case .askedAQuestion(_):
            return ["Timestamp":timeStamp]
        case .appliedForAJob(_):
            return ["Timestamp":timeStamp]
        case .milestoneCompleted(let category,_,let milestoneNumber):
            return ["Category":category,"Timestamp":timeStamp,"Milestone number":milestoneNumber]
        case .viewedApprovedMilestone(let category,_,let milestoneNumber):
            return ["Category":category,"Timestamp":timeStamp,"Milestone number":milestoneNumber]
        }
    }
    
    var name:String {
        switch self {
        case .logout:
            return "Logout"
        case .appOpen:
            return "App open"
        case .signup:
            return "Sign Up"
        case .searchedForTradies:
            return "Post approved"
        case .viewedTradieProfile:
            return "Viewed tradie profile"
        case .postedaJob:
            return "Posted a job"
        case .viewQuote:
            return "View Quote"
        case .acceptQuote:
            return "Accept quote"
        case .cancelQuotedJob:
            return "Cancel quoted job"
        case .milestoneCheckedAndApproved:
            return "Milestone Checked and approved"
        case .madePayment:
            return "Made Payment"
        case .milestoneDeclined :
            return "Milestone declined"
        case .savedTradie:
            return "Saved tradie"
        case .chat :
            return "Chat"
        case .viewedReviews :
            return "Viewed reviews"
        case .leftVoucher :
            return "Left voucher"
        case .paymentSuccess :
            return "Payment success"
        case .paymentFailure :
            return "Payment failure"
        case .editMilestones :
            return "Edit milestones"
        case .cancelJob :
            return "Cancel job"
        case .republishedJob :
            return "Republished job"
        case .addedInfoAboutCompany :
            return "Added info about company"
        case .addedPortfolio :
            return "Added portfolio"
        case .addedPaymentDetails :
            return "Added payment details"
        case .addedReview:
            return "Added review"
        case .acceptCancellation:
            return "Accept cancellation"
        case .rejectCancellation:
            return "Reject Cancellation"
        case  .viewedBuilderProfile:
            return "Viewed builder profile"
        case .quotedAJob:
            return "Quoted a job"
        case .askedAQuestion:
            return "Asked a question"
        case .appliedForAJob:
            return "Applied for a job"
        case .milestoneCompleted:
            return "Milestone completed"
        case .viewedApprovedMilestone:
            return "Viewed approved milestone"
        }
    }
}

class TicketMoengage {
    static let shared = TicketMoengage()
    //    private var user:User?
    
    func setupMoengage(launchOptions:[UIApplication.LaunchOptionsKey: Any]?){
        
        var sdkConfig = MOSDKConfig.init(appID: "9MGBIF1KHFC5GXE7YHMXRPEE")
        // Separate initialization methods for Dev and Prod initializations
        #if DEBUG
        MoEngage.sharedInstance().initializeTest(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
        MoEngage.sharedInstance().initializeLive(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        //Mix panel initializate
        MoEngage.enableSDKLogs(true)
        Mixpanel.initialize(token: "8515ed0c7941706b0b6c1cecf99c36bb")
    }
    
    func postEvent(eventType:TicketMoengageCase){
        let mutableDictionary = NSMutableDictionary(dictionary: eventType.keyValues)
        
        MoEngage.sharedInstance().trackEvent(eventType.name, with: MOProperties(attributes: mutableDictionary))
        Mixpanel.mainInstance().track(event: eventType.name, properties: eventType.keyValues)
        
    }
    
    func resetUser(){
        //  self.user = nil
        MoEngage.sharedInstance().resetUser()
        //        Analytics.shared().reset()
        Mixpanel.mainInstance().reset()
    }
    
    func setUser() {
        MoEngage.sharedInstance().setUserUniqueID(kUserDefaults.getUserId())
        MoEngage.sharedInstance().setUserLastName(kUserDefaults.getUsername())
        MoEngage.sharedInstance().setUserFirstName(kUserDefaults.getFirstName())
        MoEngage.sharedInstance().setUserEmailID(kUserDefaults.getUserEmail())
        let mixpanelInstance = Mixpanel.initialize(token: "8515ed0c7941706b0b6c1cecf99c36bb")
        mixpanelInstance.identify(distinctId: kUserDefaults.getUserId())
        mixpanelInstance.people.set(properties: ["first_name":kUserDefaults.getFirstName(),"last_name":kUserDefaults.getFirstName(),"$email":kUserDefaults.getUserEmail()])
        
    }
}
