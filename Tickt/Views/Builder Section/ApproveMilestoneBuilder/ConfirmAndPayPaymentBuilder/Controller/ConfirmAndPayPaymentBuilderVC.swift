//
//  ConfirmAndPayPaymentBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import UIKit

protocol ConfirmAndPayPaymentBuilderVCDelegate: AnyObject {
    func getDeletedCard(cardId: String)
}

class ConfirmAndPayPaymentBuilderVC: BaseVC {

    enum SectionArray {
        case cards
        case addAnother
        case addBank
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: CustomBoldLabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var payButton: CustomBoldButton!
    
    //MARK:- Variables
    var canPay: Bool = true
    var sectionArray: [SectionArray] = [.cards, .addAnother,.addBank]
    var viewModel = ConfirmAndPayPaymentBuilderVM()
    var paymentDetailModel = ApproveDeclineMilestoneModel()
    weak var delegate: ConfirmAndPayPaymentBuilderVCDelegate? = nil
    
    //MARK:- LfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewOutlet.reloadData()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case payButton:
            if validate() {
                viewModel.approveMilestone(model: paymentDetailModel)
            }
        default:
            break
        }
    }
}
