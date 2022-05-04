//
//  LeaveVouchBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 19/06/21.
//

import UIKit

protocol LeaveVouchBuilderVCDelegate: class {
    func getNewlyAddedVouch(model: TradieProfileVouchesData)
}

class LeaveVouchBuilderVC: BaseVC {

    enum SectionArray {
        case jobs
        case vouchText
        case images
        case uploadPlaceHolder
        
        var title: String {
            switch self {
            case .jobs:
                return "Jobs"
            case .vouchText:
                return "Your vouch"
            default:
                return ""
            }
        }
        
        var height: CGFloat {
            switch self {
            case .vouchText, .jobs:
                return 30
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
        
        var color: UIColor {
            switch self {
            case .vouchText, .jobs:
                return #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            default:
                return .clear
            }
        }
        
        var font: UIFont {
            switch self {
            default:
                return UIFont.kAppDefaultFontMedium(ofSize: 14.0)
            }
        }
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var tradieId: String = ""
    ///
    var jobModel: [JobListingBuilderResult]?
    var model = LeaveVouchBuilderModel()
    var viewModel = LeaveVoucheBuilderVM()
    var sectionArray: [SectionArray] = []
    weak var delegate: LeaveVouchBuilderVCDelegate? = nil
    
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case continueButton:
            if validate() {
                viewModel.addVouch(model: model)
            }
        default:
            break
        }
        disableButton(sender)
    }
}
