//
//  TradieProfilefromBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import UIKit

protocol TradieProfilefromBuilderDelegate: AnyObject {
    func getAcceptDeclineTradie(tradieId: String, status: AcceptDecline)
}

class TradieProfilefromBuilderVC: BaseVC {

    enum SectionArray {
        case tradieInfo
        case ratingblocks
        case about
        case portfolio
        case specialisation
        case reviews
        case showAllReviews
        case vouchers
        case jobPosted
        case showAllJobs
        case showAllVouchers
        case leaveVouch
        case bottomButtons
        case invite
        case saveChanges
        
        var title: String {
            switch self {
            case .tradieInfo, .ratingblocks, .showAllVouchers, .showAllReviews, .bottomButtons, .invite, .showAllJobs, .saveChanges, .leaveVouch:
                return CommonStrings.emptyString
            case .specialisation:
                return "Areas of specialisation"
            case .about:
                return kUserDefaults.isTradie() ? "About" : "About us"
            case .jobPosted:
                return "Jobs posted"
            case .portfolio:
                return "Portfolio"
            case .reviews:
                return "Review(s)"
            case .vouchers:
                return "Vouches"
            }
        }
        
        var height: CGFloat {
            switch self {
            case .tradieInfo, .ratingblocks, .showAllVouchers, .showAllReviews, .bottomButtons, .invite, .showAllJobs, .leaveVouch:
                return CGFloat.leastNonzeroMagnitude
            default:
                return 30
            }
        }
    }
    
    var limitedShow:Bool = true
    var showMoreContent:Bool = false

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    //MARK:- Variables
    var jobId = ""
    var isOpenJob = false
    var jobName: String = ""
    var builerId: String = ""
    var tradieId: String = ""
    var noOfTraidesCount: Int = 0
    var showSaveUnsaveButton = false
    var loggedInBuilder: Bool = false
    ///
    let maxVouchCanDisplay = 2
    let maxReviewCanDisplay = 3
    var photosArray: [String]? = nil
    var sectionArray: [SectionArray] = []
    let maxJobsCanDisplay = 2
    var tradieModel: TradieProfilefromBuilderModel?
    var loggedInBuilderModel: BuilderProfileModel? = nil
    var viewModel = TradieProfilefromBuilderVM()
    weak var delegate: TradieProfilefromBuilderDelegate? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case editButton:
            goToEditableOptionVC()
        default:
            break
        }
    }
}
