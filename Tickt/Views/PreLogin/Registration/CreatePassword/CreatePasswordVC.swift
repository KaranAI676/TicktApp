//
//  CreatePasswordVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/03/21.
//

import UIKit

class CreatePasswordVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///Nav View
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    ///
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var textViewOutlet: CustomTextView!
    
    //MARK:- Variables    
    var number: String = ""
    var viewModel = CreatePasswordVM()
    var screenType: ScreenType = .createAccount
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case self.backButton:
            self.backButtonAction()
        case self.signUpButton:
            self.signUpButtonAction()
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension CreatePasswordVC {
    
    private func initialSetup() {
        ///
        passwordTextField.delegate = self
        viewModel.delegate = self
        textViewOutlet.passDelegate = self
        ///
//        self.pageController.isHidden = (screenType != .add)
        self.dotImageView.isHidden = (screenType != .createAccount)
        passwordTextField.setupPasswordTextField()
        setupDotImage()
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_4")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_4")
        default:
            break
        }
    }
    
    private func signUpButtonAction() {        
        switch screenType {
        case .createAccount:
            if validate() {
                kAppDelegate.signupModel.password = passwordTextField.text!.byRemovingLeadingTrailingWhiteSpaces
                if kUserDefaults.isTradie() {
                    let tradeVC = WhatIsYourTradeVC.instantiate(fromAppStoryboard: .registration)
                    mainQueue { [weak self] in
                        self?.navigationController?.pushViewController(tradeVC, animated: true)
                    }
                } else {
                    let companyDetail = CompanyDetailsVC.instantiate(fromAppStoryboard: .registration)
                    mainQueue { [weak self] in
                        self?.navigationController?.pushViewController(companyDetail, animated: true)
                    }
                }
            }
        case .edit:
            if validate() {
                self.viewModel.createNewPassword(password: passwordTextField.text!.byRemovingLeadingTrailingWhiteSpaces, number: number)
            }
        default:
            break
        }
    }
    
    private func backButtonAction() {
        switch screenType {
        case .createAccount, .edit:
            if let vc = self.navigationController?.viewControllers.first(where: {$0 is AddPhoneNumberVC}) {
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                self.pop()
            }
        default:
            break
        }
    }
    
    private func validate() -> Bool {
        
        if !passwordTextField.text!.byRemovingLeadingTrailingWhiteSpaces.checkIfValid (.password) {
            if passwordTextField.text!.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
                self.passwordErrorLabel.text = Validation.errorEnterPassword
//                CommonFunctions.showToastWithMessage(Validation.errorEnterPassword)
            }
            else if passwordTextField.text!.byRemovingLeadingTrailingWhiteSpaces.count < 8 {
                self.passwordErrorLabel.text = Validation.errorPasswordLength
//                CommonFunctions.showToastWithMessage(Validation.errorPasswordLength)
            } else {
                self.passwordErrorLabel.text = Validation.errorValiPassword
                CommonFunctions.showToastWithMessage(Validation.errorValiPassword)
            }
            return false
        }
        self.passwordErrorLabel.text = CommonStrings.emptyString
        return true
    }
}

//MARK:- TextField Delegates
//==========================
extension CreatePasswordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let inputMode = textField.textInputMode else {
            return false
        }
        
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        
        guard let userEnteredString = textField.text else { return false }
        let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.length <= 40
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
}

extension CreatePasswordVC: CreatePasswordDelegate {
    
    func success() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}

//MARK:- CustomTextView: Delegate
//===============================
extension CreatePasswordVC: CustomTextViewDelegate {
    
    func getPassword(password: String) {
        
    }
}
