//
//  AddPaymentVC.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//

class AddPaymentVC: BaseVC {
            
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalAmountView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var totalAmountLabel: CustomBoldLabel!
    @IBOutlet weak var addAccountButton: CustomBoldButton!
    @IBOutlet weak var selectBankAccount: CustomBoldButton!
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var bankModel: BankModel?
    var accountSelected = false
    let viewModel = AddPaymentVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getBankDetails()
        jobNameLabel.text = MilestoneVC.milestoneData.jobName
        totalAmountLabel.text = "$" + String.getString(MilestoneVC.milestoneData.totalAmount)
        if MilestoneVC.milestoneData.isLastMilestone {
            totalAmountView.isHidden = false
        }
    }
    
    func setBankAccount() {
        statusImageView.image = accountSelected ? #imageLiteral(resourceName: "icCheck") : #imageLiteral(resourceName: "checkBoxUnselected")
        var title = ""
        if let bankAccount = bankModel, bankAccount.result.accountName.isNotNil {
            title = "Continue"
        } else {
            title = "Add bank account details"
        }
        addAccountButton.setTitle(title, for: .normal)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
            disableButton(sender)
        case addAccountButton:
            if validate() {
                let paymentVC = PaymentDetailVC.instantiate(fromAppStoryboard: .jobDashboard)
                paymentVC.bankDetail = bankModel?.result
                push(vc: paymentVC)
                paymentVC.addAccountAction = { [weak self] bankDetail in
                    self?.bankModel = BankModel(message: "", statusCode: 200, status: true, result: bankDetail)
                    self?.checkAccountStatus(status: true)
                }
                paymentVC.deleteAccountAction = { [weak self] in
                    self?.bankModel = BankModel(message: "", statusCode: 200, status: true, result: BankDetail(bsbNumber: nil, accountName: nil, accountNumber: nil, userId: nil,stripeAccountId: nil,accountVerified: false))                    
                    self?.checkAccountStatus(status: false)
                }
                disableButton(sender)
            }
        case selectBankAccount:
            accountSelected = !accountSelected
            setBankAccount()
        default:
            break
        }
    }        
    
    func validate() -> Bool {
        if let bankAccount = bankModel, bankAccount.result.accountName.isNotNil {
            if !accountSelected {
                CommonFunctions.showToastWithMessage(Validation.errorSelectAccount)
                return false
            }
        }
        return true
    }
}
