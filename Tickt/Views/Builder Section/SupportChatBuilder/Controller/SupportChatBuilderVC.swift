//
//  SupportChatBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import UIKit

class SupportChatBuilderVC: BaseVC {

    enum SectionArray: String {
        case options = ""
        case message = "Write your message"
        
        var height: CGFloat {
            switch self {
            case .options:
                return CGFloat.leastNonzeroMagnitude
            case .message:
                return 40
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
    @IBOutlet weak var subScreenTitle: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    //MARK:- Variables
    var model = SupportChatBuilderModel()
    var viewModel = SupportChatBuilderVM()
    var sectionArray: [SectionArray] = [.options, .message]
    var optionsModel: [SupportChatOptionModel]? = nil
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case bottomButton:
            if validate() {
                viewModel.supportChat(model: model)
            }
        default:
            break
        }
        disableButton(sender)
    }
}
