//
//  CancelJobBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 01/06/21.
//

import UIKit

class CancelJobBuilderVC: BaseVC {

    enum SectionArray {
        case reasons
        case note
        
        var title: String {
            switch self {
            case .reasons:
                return ""
            case .note:
                return "Add note (optional)"
            }
        }
        
        var height: CGFloat {
            switch self {
            case .reasons:
                return CGFloat.leastNonzeroMagnitude
            case .note:
                return 30
            }
        }
        
        var color: UIColor {
            switch self {
            case .reasons:
                return .clear
            case .note:
                return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            }
        }
        
        var font: UIFont {
            switch self {
            default:
                return UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var jobId: String = ""
    var jobName: String = ""
    var viewModel = CancelJobBuilderVM()
    var cancelJobModel = CancelJobBuilderModel()
    var sectionArray: [SectionArray] = []
    var reasonsModel: [ReasonsModel]? = nil
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case continueButton:
            if validate() {
                viewModel.cancelJob(model: cancelJobModel)
            }
        default:
            break
        }
        disableButton(sender)
    }
}
