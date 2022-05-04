//
//  MilestoneListingVC.swift
//  Tickt
//
//  Created by S H U B H A M on 19/03/21.
//

import UIKit

protocol MilestoneListingVCDelegate: AnyObject {
    func updatedTemplates(milestoneCount: Int)
}

class MilestoneListingVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveTemplateButton: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    /// Buttons
    @IBOutlet weak var useTemplate: UIButton!
    @IBOutlet weak var addMilestone: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var jobName: String = ""
    var jobId: String = ""
    var tradieId: String = ""
    var templateId: String = ""
    var templateName: String = ""
    var milestonesArray = [MilestoneModel]()
    var viewModel = MilestoneListingVM()
    var screenType: ScreenType = .creatingJob
    ///
    var delegate: MilestoneListingVCDelegate? = nil
    var isRearranged: Bool = false
    var constantMilestoneArray = [MilestoneModel]()
    var tempMilestoneArray = [MilestoneModel]() /// Used to compare the previous & newly edit model
    var deletedMilestone = [MilestoneModel]() /// Used for change request
    
    var milestoneColorsArray = [UIColor]()
        
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
            backButtonAction()
        case saveTemplateButton:
            saveTemplateButtonAction()
        case addMilestone:
            goToAddMilestoneVC()
        case continueButton:
            continueButtonAction()
        case useTemplate:
            goToTemplateListVC()
        default:
            break
        }
        disableButton(sender)
    }
}
