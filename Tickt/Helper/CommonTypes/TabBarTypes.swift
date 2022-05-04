//
//  TabBarTypes.swift
//  Tickt
//
//  Created by S H U B H A M on 26/07/21.
//

import Foundation

enum TabBarIndex {
    
    case home
    case jobs
    case create
    case chat
    case profile
    
    var image: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "homeTabIcon")
        case .jobs:
            return #imageLiteral(resourceName: "jobsTabIcon")
        case .create:
            return  #imageLiteral(resourceName: "plus")
        case .chat:
            return  #imageLiteral(resourceName: "chatTabIcon")
        case .profile:
            return #imageLiteral(resourceName: "profileTabIcon")
        }
    }
    
    var tabValue: Int {
        switch self {
        case .home:
            return 0
        case .jobs:
            return 1
        case .create:
            return  2
        case .chat:
            return  kUserDefaults.isTradie() ? 2 : 3
        case .profile:
            return  kUserDefaults.isTradie() ? 3 : 4
        }
    }
    
    var coachMessage: String {
        switch self {
        case .home:
            return kUserDefaults.isTradie() ?
                "Hi \(kUserDefaults.getUsername()), your home screen is your go-to for finding new jobs." :
                "Hi \(kUserDefaults.getUsername()), your home screen is your go-to for finding tradespeople."
        case .jobs:
            return kUserDefaults.isTradie() ?
                "Active Jobs: All the jobs that are approved by both parties\n\nApplied Jobs: All the jobs for which the tradie has applied\n\nPast Jobs: All the cancelled, expired and completed jobs" :
                "Active Jobs: All the jobs that are approved by both parties\n\nOpen Jobs: All the posted jobs or jobs which are in pending state\n\nPast Jobs: All the cancelled, expired and completed jobs"
        case .create:
            return "Here you can post a new job"
        case .chat:
            return kUserDefaults.isTradie() ?
                "Chat with builders on job requirements" :
                "Your chats for jobs and tradespeople are here"
        case .profile:
            return "Manage your profile and settings"
        }
    }
    
    var arrows: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "arrowFacingLeft")
        default:
            return #imageLiteral(resourceName: "arrowFacingRight")
        }
    }
}
