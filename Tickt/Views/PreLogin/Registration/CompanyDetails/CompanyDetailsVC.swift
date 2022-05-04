//
//  CompanyDetailsVC.swift
//  Tickt
//
//  Created by S H U B H A M on 12/03/21.
//

import UIKit

class CompanyDetailsVC: BaseVC {
    
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///Nav View
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var scollViewOutlet: UIScrollView!
    /// Company Name
    @IBOutlet weak var companyNameContainerView: UIView!
    @IBOutlet weak var companyNameTitleLabel: UILabel!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNameErrorLabel: UILabel!
    /// Your Position
    @IBOutlet weak var positionContainerView: UIView!
    @IBOutlet weak var positionTitleLabel: UILabel!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var positionErrorLabel: UILabel!
    /// ABN Number
    @IBOutlet weak var abnNumberContainerView: UIView!
    @IBOutlet weak var abnNumberTitleLabel: UILabel!
    @IBOutlet weak var abnNumberTextField: UITextField!
    @IBOutlet weak var abnNumberErrorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel = CompanyDetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchLocation()
    }
    
    func fetchLocation() {
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.requestLocatinPermission { (status) in
            if status {
                LocationManager.sharedInstance.startLocationUpdates()
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case signUpButton:
            if validate() {
                kAppDelegate.signupModel.position = positionTextField.text!
                kAppDelegate.signupModel.abnNumber = abnNumberTextField.text!.removingWhitespaces()
                kAppDelegate.signupModel.companyName = companyNameTextField.text!
                viewModel.registerUser()
            }
        default:
            break
        }
        disableButton(sender)
    }
    
    func validate() -> Bool {
                
        if companyNameTextField.text!.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            companyNameErrorLabel.text = Validation.errorCompanyEmpty
            return false
        } else {
            companyNameErrorLabel.text = ""
        }
                        
        if positionTextField.text!.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            positionErrorLabel.text = Validation.errorPositionEmpty
            return false
        } else {
            positionErrorLabel.text = ""
        }
                
        if abnNumberTextField.text!.removingWhitespaces().isEmpty {
            abnNumberErrorLabel.text = Validation.errorAbnNumberEmpty
            return false
        } else if abnNumberTextField.text!.removingWhitespaces().count < 11 {
            abnNumberErrorLabel.text = Validation.errorAbnNumber
            return false
        } else if !abnNumberTextField.text!.removingWhitespaces().isValidABN() {
            abnNumberErrorLabel.text = Validation.invalidABNNumber            
            return false
        } else {
            abnNumberErrorLabel.text = ""
        }
        
        return true
    }        
}

extension CompanyDetailsVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        companyNameTextField.delegate = self
        positionTextField.delegate = self
        abnNumberTextField.delegate = self
        setupDotImage()
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_0")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_5")
        default:
            break
        }
    }
}

//MARK:- UITextFieldDelegate
//==========================
extension CompanyDetailsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case companyNameTextField:
            positionTextField.becomeFirstResponder()
        case positionTextField:
            abnNumberTextField.becomeFirstResponder()
        case abnNumberTextField:
            abnNumberTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case self.companyNameTextField:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphabets, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 51)
        case self.positionTextField:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphabets, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)
        case self.abnNumberTextField:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 14)
        default:
            return true
        }
    }
}
