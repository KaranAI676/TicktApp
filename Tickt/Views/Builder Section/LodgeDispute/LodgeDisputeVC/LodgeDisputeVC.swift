//
//  LodgeDisputeVC.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import UIKit

class LodgeDisputeVC: BaseVC {

    enum SectionArray {
        case reasons
        case detail
        case images
        case uploadPlaceHolder
        
        var title: String {
            switch self {
            case .detail:
                return "Details (Optional)"
            default:
                return ""
            }
        }
        
        var height: CGFloat {
            switch self {
            case .detail:
                return 30
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
        
        var color: UIColor {
            switch self {
            case .detail:
                return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            default:
                return .clear
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
    @IBOutlet weak var tableViewOutlet: UITableView!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var jobId: String = ""
    var jobName: String = ""
    var viewModel = LodgeDisputeVM()
    var lodgeDisputeModel = LodgeDisputeModel()
    var sectionArray: [SectionArray] = []
    var reasonsModel: [DisputeModel]? = nil
    
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
                viewModel.lodgeDispute(model: lodgeDisputeModel)
            }
        default:
            break
        }
        disableButton(sender)
    }
}
