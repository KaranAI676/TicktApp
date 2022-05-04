//
//  AddPhoneNumberVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/03/21.
//
//

import UIKit

class AddPhoneNumberVC: BaseVC {
    
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailField: CustomMediumField!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberErrorLabel: UILabel!
    @IBOutlet weak var phoneContainerView: UIStackView!
    @IBOutlet weak var phoneNumberContainerView: UIView!
    @IBOutlet weak var countryCodeTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextField: CustomPhoneField!
    
    var viewModel = AddPhoneNumberVM()
    var screenType: ScreenType = .createAccount
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            backBtnAction()
        case signUpButton:
            signupBtnAction()
        default:
            break
        }
        disableButton(sender)
    }
}

extension AddPhoneNumberVC {
    
    private func initialSetup() {
        countryCodeTextfield.delegate = self
        phoneNumberTextField.delegate = self
        viewModel.delegate = self
        setDefaultText()
        setupDotImage()
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_2")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_2")
        default:
            break
        }
    }
    
    private func setDefaultText() {
        switch screenType {
        case .createAccount:
            screenTitleLabel.text = "Phone number"
            phoneContainerView.isHidden = false
            emailContainerView.isHidden = true
        case .edit:
            phoneNumberTitleLabel.text = "Email address"
            screenTitleLabel.text = "Reset password"
            phoneContainerView.isHidden = true
            emailContainerView.isHidden = false
        default:
            break
        }
        descriptionLabel.isHidden = !(screenType != .createAccount)
        dotImageView.isHidden = (screenType != .createAccount)
    }
    
    private func backBtnAction() {
        switch screenType {
        case .createAccount:
            kAppDelegate.signupModel.phoneNumber = ""
            pop()
        default:
            pop()
        }
    }
    
    private func signupBtnAction() {
        switch screenType {
        case .createAccount:
            if validate() {
                endEditing()
                kAppDelegate.signupModel.phoneNumber = phoneNumberTextField.text!.removeSpaces
                viewModel.verifyPhoneNumber(phoneNumber: phoneNumberTextField.text!.removeSpaces)
            }
        case .edit:
            if validate() {
                endEditing()
                viewModel.verifyEmailForReset(email: emailField.text!.removeSpaces)
            }
        default:
            break
        }
    }
    
    private func validate() -> Bool {
        
        switch screenType {
        case .createAccount:
            if phoneNumberTextField.text!.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
                phoneNumberErrorLabel.text = Validation.errorEmptyPhoneNumber
                return false
            } else {
                phoneNumberErrorLabel.text = CommonStrings.emptyString
            }
            
            if phoneNumberTextField.text!.byRemovingLeadingTrailingWhiteSpaces.count < 9 {
                phoneNumberErrorLabel.text = Validation.invalidPhoneNumber
                return false
            } else {
                phoneNumberErrorLabel.text = CommonStrings.emptyString
            }
        case .edit:
            if emailField.text!.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
                phoneNumberErrorLabel.text = Validation.errorEmailEmpty
                return false
            } else {
                phoneNumberErrorLabel.text = CommonStrings.emptyString
            }
            
            if phoneNumberTextField.text!.byRemovingLeadingTrailingWhiteSpaces.isValidEmail() {
                phoneNumberErrorLabel.text = Validation.errorEmailInvalid
                return false
            } else {
                phoneNumberErrorLabel.text = CommonStrings.emptyString
            }
        default:
            break
        }
        
        return true
    }
}

extension AddPhoneNumberVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryCodeTextfield:
            return false
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if screenType == .createAccount {
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 11)
        } else {
            return true
        }
    }
}
