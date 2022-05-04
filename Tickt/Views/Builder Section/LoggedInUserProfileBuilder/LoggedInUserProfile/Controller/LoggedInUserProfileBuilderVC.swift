//
//  LoggedInUserProfileBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 23/06/21.
//

import UIKit

class LoggedInUserProfileBuilderVC: BaseVC {

    enum SectionArray {
        case top
        case ratingBlock
        case options
    }
    
    enum CellTypes: String {
        case profileInformation = "Profile information"
        case paymentDetails = "Payment details"
        case bankingDetails = "Banking details"
        case myPayments = "My payments"
        case savedJobs = "Saved jobs"
        case milestoneTemplates = "Milestone templates"
        case paymentsHistory = "Payments history"
        case settings = "Settings"
        case savedTradespeople = "Saved tradespeople"
        case supportChat = "Support chat"
        case appGuide = "App Guide"
        case privacyPolicy = "Privacy Policy"
        case termsOfUse = "Terms of use"
        case logout = "Log out"
        
        var font: UIFont {
            switch self {
            case .appGuide, .privacyPolicy, .termsOfUse, .logout:
                return UIFont.systemFont(ofSize: 14)
            default:
                return UIFont.kAppDefaultFontBold(ofSize: 14)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .logout:
                return AppColors.tabBarSelected
            default:
                return AppColors.themeBlue
            }
        }
        
        var optionImage: UIImage? {
            switch self {
            case .profileInformation:
                return #imageLiteral(resourceName: "iconPersonalProfile")
            case .paymentDetails, .bankingDetails:
                return #imageLiteral(resourceName: "iconWallet")
            case .milestoneTemplates:
                return #imageLiteral(resourceName: "icTemplate")
            case .paymentsHistory, .myPayments:
                return #imageLiteral(resourceName: "icRevenue")
            case .settings:
                return #imageLiteral(resourceName: "icSetting")
            case .savedTradespeople, .savedJobs:
                return #imageLiteral(resourceName: "icJob")
            case .supportChat:
                return #imageLiteral(resourceName: "icMessage")
            case .appGuide:
                return #imageLiteral(resourceName: "iconTutorial")
            case .privacyPolicy:
                return #imageLiteral(resourceName: "iconTerms")
            case .termsOfUse:
                return #imageLiteral(resourceName: "iconTerms")
            case .logout:
                return nil
            }
        }
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    ///
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var selectedImage: UIImage?
    var sectionArray: [SectionArray] = [.top, .ratingBlock, .options]
    var cellArray: [CellTypes] = []
    var viewModel = LoggedInUserProfileBuilderVM()
    var model: LoggedInUserProfileBuilderModel? = nil
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
