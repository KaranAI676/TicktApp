//
//  TabItems.swift
//  Tickt
//
//  Created by Admin on 09/04/21.
//

import UIKit
import Foundation

enum TabItem: String, CaseIterable {
    case home = "Home"
    case job = "Job"
    case chat = "Chat"
    case profile = "Profile"
        
    var viewController: UIViewController {
        switch self {
        case .home:
            return TradieHomeVC.instantiate(fromAppStoryboard: .home)
        case .job:
            return TradieHomeVC.instantiate(fromAppStoryboard: .home)
        case .chat:
            return TradieHomeVC.instantiate(fromAppStoryboard: .home)
        case .profile:
            return TradieHomeVC.instantiate(fromAppStoryboard: .home)
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "Home_unselected")
        case .job:
            return #imageLiteral(resourceName: "jobsInactive")
        case .chat:
            return #imageLiteral(resourceName: "Chat_unselected")
        case .profile:
            return #imageLiteral(resourceName: "accountInactive")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "Home_selected")
        case .job:
            return #imageLiteral(resourceName: "jobsActive")
        case .chat:
            return #imageLiteral(resourceName: "Chat_selected")
        case .profile:
            return #imageLiteral(resourceName: "accountActive")
        }
    }
    
    var displayTitle: String {
        return self.rawValue
    }
}
