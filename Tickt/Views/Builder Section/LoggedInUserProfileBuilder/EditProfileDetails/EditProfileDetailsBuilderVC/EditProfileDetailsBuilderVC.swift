//
//  EditProfileDetailsBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import UIKit

class EditProfileDetailsBuilderVC: BaseVC {

    enum SectionType: String {
        
        case fullName = "Full Name"
        case mobileNumber = "Mobile Number"
        case email = "Email"
        case changePassword = ""
        case companyName = "Company Name"
        case yourPosition = "Your Position"
        case abn = "Australian Business Number (ABN)"
        case businessName = "Business Name"
        case qualificationDocument = "Qualification Documents"
        
        var placeHolder: String {
            switch self {
            case .fullName:
                return "Full Name"
            case .mobileNumber:
                return "402 296 237"
            case .email:
                return "Email"
            case .changePassword:
                return ""
            case .companyName:
                return "Company Name"
            case .yourPosition:
                return "Your Position"
            case .abn:
                return "Australian Business Number (ABN)"
            case .businessName:
                return "Business Name"
            case .qualificationDocument:
                return ""
            }
        }
        
        var titleSize: CGFloat {
            switch self {
            default:
                return 30
            }
        }
        
        var keyBoardType: UIKeyboardType {
            switch self {
            case .abn, .mobileNumber:
                return .numberPad
            case .email:
                return .emailAddress
            default:
                return .alphabet
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
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    //MARK:- Variables
    var currentIndex = 0
    var model = EditProfileDetailsModel()
    var viewModel = EditProfileDetailsVM()
    var selectedImages = [(Data, String, Int, String, String)]() //Data, FileName, Index, Id, FileType
    var sectionArray: [SectionType] = [.fullName, .mobileNumber, .email, .changePassword, .companyName, .yourPosition, .businessName ,.abn]
    
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
            disableButton(sender)
        case bottomButton:
            if validate() {
                viewModel.editBasicDetails(model: model)
            }
        default:
            break
        }
    }
}

extension EditProfileDetailsBuilderVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        viewModel.getBasicDetails()
        sectionArray = getSectionArray()
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: DocumentCell.self)
        tableViewOutlet.registerCell(with: TitleLabelTableCell.self)
        tableViewOutlet.registerCell(with: DescriptionTableCell.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: AddQualificationDocument.self)
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: PhoneNumberTextfieldTableCell.self)
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    @objc func didChangeText(textfield: UITextField) {
        guard let index = textfield.tableViewIndexPath(self.tableViewOutlet) else { return }
        switch self.sectionArray[index.section] {
        case .mobileNumber:
            textfield.text = textfield.text?.removeSpaces
            textfield.text?.insert(separator: " ", every: 3)
        case .abn:
            textfield.text = textfield.text?.removeSpaces
            textfield.text?.insert(separator: " ",from: 2, every: 3)
        default:
            break
        }
    }
    
    func goToChangePasswordVC() {
        let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .changePassword)
        push(vc: vc)
    }
    
    func goToNextVC() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
            mainQueue { [weak self] in
                NotificationCenter.default.post(name: NotificationName.refreshProfile, object: nil, userInfo: nil)
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            pop()
        }
    }
    
    func goToChangeEmailVC() {
        let vc = ChangeEmailVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        vc.model.currentEmail = model.email
        push(vc: vc)
    }
}


extension EditProfileDetailsBuilderVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let index = textField.tableViewIndexPath(tableViewOutlet) else { return true }
        switch self.sectionArray[index.section] {
        case .fullName, .yourPosition,.businessName:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphabets, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)
        case .companyName:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumericPunctuation, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)

        case .mobileNumber:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 9 + 2) /// 9Digits + 2Spaces
        case .email, .changePassword, .qualificationDocument:
            return true
        case .abn:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 11 + 3) /// 11Digits + 3Spaces
            
        }
    }
}

extension EditProfileDetailsBuilderVC {
    
    private func validate() -> Bool {
        
        if model.fullName.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter full name")
            return false
        }
        
        if model.mobileNumber.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter mobile number")
            return false
        }
        
        if model.email.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter email address")
            return false
        }
        
        if !model.email.isValidEmail() {
            CommonFunctions.showToastWithMessage(Validation.errorEmailEmpty)
            return false
        }
        
        if (model.abn?.count ?? 0) < 11 {
            CommonFunctions.showToastWithMessage(Validation.errorAbnNumber)
            return false
        } else if !(model.abn?.isValidABN() ?? false) {
            CommonFunctions.showToastWithMessage(Validation.invalidABNNumber)
            return false
        }
        
        if !kUserDefaults.isTradie() {
            if model.companyName?.isEmpty ?? false {
                CommonFunctions.showToastWithMessage("Please enter company name")
                return false
            }
            
            if model.position?.isEmpty ?? false {
                CommonFunctions.showToastWithMessage("Please enter your position")
                return false
            }
            
            if model.abn?.isEmpty ?? false {
                CommonFunctions.showToastWithMessage("Please enter ABN number")
                return false
            }
            
            if (model.abn?.count ?? 0) < 11 {
                CommonFunctions.showToastWithMessage(Validation.errorAbnNumber)
                return false
            } else if !(model.abn?.isValidABN() ?? false) {
                CommonFunctions.showToastWithMessage(Validation.invalidABNNumber)
                return false
            }
        }else{
            if model.businessName?.trim == "" {
                CommonFunctions.showToastWithMessage(Validation.errorBusinessNameEmpty)
                return false
            } else if model.businessName?.trim.count ?? 0 < 3 {
                CommonFunctions.showToastWithMessage(Validation.errorBusinessName)
                return false
            }
        }
        return true
    }
}


extension EditProfileDetailsBuilderVC: EditProfileDetailsVMDelegate {
    
    func didGetTradeList() {
        openQualificationVC()
    }
    
    func getSectionArray() -> [SectionType] {
        if kUserDefaults.isTradie() {
            return [.fullName, .mobileNumber, .email,.businessName, .abn, .changePassword, .qualificationDocument]
        } else {
            return [.fullName, .mobileNumber, .email, .changePassword, .companyName, .yourPosition,.abn]
        }
    }
    
    func success(model: EditProfileDetailsModel) {
        self.model = model
        tableViewOutlet.reloadData()
    }
    
    func successEdit() {
        goToNextVC()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
