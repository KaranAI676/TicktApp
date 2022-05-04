//
//  PaymentDetailVC.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//
import Stripe
class PaymentDetailVC: BaseVC {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var sendButton: CustomBoldButton!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!    
    @IBOutlet weak var bsbNumberField: CustomBsbField!
    @IBOutlet weak var accountNameField: CustomMediumField!
    @IBOutlet weak var accountNumberField: CustomMediumField!
    @IBOutlet weak var addIdButton: UIButton!
    @IBOutlet weak var idVerificationMsgView: UIView!
    @IBOutlet weak var infoViewbtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var fromBuilder : Bool = false
    
    var isEdit = false {
        didSet {
            isEdit ? sendButton.setTitle("Save", for: .normal) : sendButton.setTitle("Submit", for: .normal)
            settingButton.isHidden = isEdit
        }
    }
    var isFromProfile = false
    var bankDetail: BankDetail?
    let viewModel = PaymentDetailVM()
    var deleteAccountAction: (()->())?
    var addAccountAction: ((_ bankDetail: BankDetail)->())?
    var isIdVerified = false
    var isAccountSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        bsbNumberField.font = UIFont.kAppDefaultFontMedium(ofSize: 16)
    }
    
    func initialSetup() {
        viewModel.delegate = self
        jobNameLabel.text = MilestoneVC.milestoneData.jobName
        bsbNumberField.font = UIFont.kAppDefaultFontRoman(ofSize: 16)
        bsbNumberField.applyLeftPadding(padding: 10)
        accountNameField.applyLeftPadding(padding: 10)
        accountNumberField.applyLeftPadding(padding: 10)
        setbankData()
        if let detail = bankDetail, detail.userId.isNotNil {
            settingButton.isHidden = false
        } else {
            settingButton.isHidden = true
        }
        if !fromBuilder {
            if isFromProfile {
                viewModel.delegate = self
                viewModel.getBankDetails()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: NotificationName.refreshBankDetails, object: nil)
    }
    
    func setbankData() {
        popUpView.popOut()
        if let detail = bankDetail, detail.userId.isNotNil {
            isIdVerified = detail.accountVerified ?? false
            //            let firstString = bankDetail!.bsbNumber![0..<3]
            //            let secondString = bankDetail!.bsbNumber![3..<6]
            bsbNumberField.text = bankDetail!.bsbNumber // firstString + "-" + secondString
            accountNameField.text = bankDetail?.accountName
            accountNumberField.text = bankDetail?.accountNumber
            editButton.isHidden = false
            isEdit = false
            isAccountSaved = true
        } else {
            isEdit = true
            bsbNumberField.text = ""
            accountNameField.text = ""
            accountNumberField.text = ""
            editButton.isHidden = true
        }
        if !fromBuilder {
            if isFromProfile {
                editButton.isHidden = true
                isEdit = true
            }
        }
        
        if isIdVerified {
            addIdButton.setTitle("    ID Verfied", for: .normal)
            addIdButton.setImage(#imageLiteral(resourceName: "icCheck"), for: .normal)
        }else{
            addIdButton.setTitle("Add ID Verfication", for: .normal)
            addIdButton.setImage(nil, for: .normal)
        }
        
        if fromBuilder {
            addIdButton.isHidden = true
        }else{
            addIdButton.isHidden = false
        }
    }
    @objc func refreshScreen() {
        if !fromBuilder {
            viewModel.delegate = self
            viewModel.getBankDetails()
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender {
        case backButton:
            pop()
        case sendButton:
            if fromBuilder {
                
                if validate() {
                    
                    let bankAccount = STPBankAccountParams()
                    bankAccount.accountNumber = accountNumberField.text!
                    bankAccount.accountHolderName = accountNameField.text!
                    bankAccount.currency = "$234"
                    STPAPIClient.shared.createToken(withBankAccount: bankAccount) { (token, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print(token ?? "")
                        }
                    }
                }
                return
            }
            
            if validate() {
                if let detail = bankDetail {
                    let bsb = bsbNumberField.text!
                    if isFromProfile {
                        if detail.userId.isNotNil, isEdit {
                            viewModel.addBankAccount(param: [ApiKeys.accountName: accountNameField.text!,
                                                             ApiKeys.accountNumber: accountNumberField.text!,
                                                             ApiKeys.bsbNumber: bsb, ApiKeys.userId: bankDetail?.userId ?? ""], isEdit: true)
                        } else {
                            viewModel.addBankAccount(param: [ApiKeys.accountName: accountNameField.text!,
                                                             ApiKeys.accountNumber: accountNumberField.text!,
                                                             ApiKeys.bsbNumber: bsb], isEdit: false)
                        }
                    } else {
                        if detail.userId.isNotNil, !isEdit { //User has not made any changes
                            viewModel.uploadImages()
                        } else {
                            if detail.userId.isNotNil, isEdit {
                                viewModel.addBankAccount(param: [ApiKeys.accountName: accountNameField.text!,
                                                                 ApiKeys.accountNumber: accountNumberField.text!,
                                                                 ApiKeys.bsbNumber: bsb, ApiKeys.userId: bankDetail?.userId ?? ""], isEdit: true)
                            } else {
                                viewModel.addBankAccount(param: [ApiKeys.accountName: accountNameField.text!,
                                                                 ApiKeys.accountNumber: accountNumberField.text!,
                                                                 ApiKeys.bsbNumber: bsb], isEdit: false)
                            }
                        }
                    }
                    mainQueue { [weak self] in
                        self?.endEditing()
                    }
                }
            }
        case settingButton:
            let _ = popUpView.alpha == 0 ? popUpView.popIn() : popUpView.popOut()
        case editButton:
            isEdit = true
            let _ = popUpView.alpha == 0 ? popUpView.popIn() : popUpView.popOut()
            accountNameField.becomeFirstResponder()
        case deleteButton:
            let _ = popUpView.alpha == 0 ? popUpView.popIn() : popUpView.popOut()
            AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                                 alertTitle: "Delete account",
                                                 alertMessage: "Are you sure you want to delete this account?",
                                                 acceptButtonTitle: "Delete",
                                                 declineButtonTitle: "Cancel") {
                self.viewModel.delegate = self
                self.viewModel.deleteBankAccount()
            } dismissCompletion: {
                
            }
            break
        default:
            break
        }
        disableButton(sender)
        
    }
    
    @IBAction func addIdbtnTap(_ sender: UIButton) {
        if isIdVerified {
            CommonFunctions.showToastWithMessage("Your ID is already verified.")
        } else {
            let stripeId = bankDetail?.stripeAccountId ?? ""
            if !stripeId.isEmpty {
                let nextVc = UploadDocumentVC.instantiate(fromAppStoryboard: .uploadDocuments)
                nextVc.stripeID = bankDetail?.stripeAccountId ?? ""
                push(vc: nextVc)
            } else {
                CommonFunctions.showToastWithMessage("Please add bank account first.")
            }
        }
    }
    
    @IBAction func infoBtnTap(_ sender: UIButton) {
        let nextVc = IDVerficationToolTipVC.instantiate(fromAppStoryboard: .uploadDocuments)
        self.push(vc: nextVc)
    }
    
    func validate() -> Bool {
        if accountNameField.text!.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyAccountName)
            return false
        }
        
        if bsbNumberField.text!.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyBSBNumber)
            return false
        }
        
        if bsbNumberField.text!.count < 6 {
            CommonFunctions.showToastWithMessage(Validation.invalidBSBNumber)
            return false
        }
        
        if accountNumberField.text!.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyAccountNumber)
            return false
        }
        
        
        if !isIdVerified && isAccountSaved {
            CommonFunctions.showToastWithMessage(Validation.verifyID)
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popUpView.popOut()
    }
}
