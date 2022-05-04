//
//  AddAbnVC.swift
//  Tickt
//
//  Created by S H U B H A M on 09/03/21.
//

import UIKit

class AddAbnVC: BaseVC {

    
    //MARK:- IBOutlets
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///Nav View
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var abnNumberContainerView: UIView!
    @IBOutlet weak var abnNumberTitleLabel: UILabel!
    @IBOutlet weak var abnNumberTextField: UITextField!
    @IBOutlet weak var abnNumberErrorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var businessNamTextField: CustomABNField!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessNameContainerView: UIView!
    @IBOutlet weak var businessNameErrorLabel: UILabel!
    
    
    
    var viewModel = AddAbnVM()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchLocation()
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case self.backButton:
            pop()
        case self.signUpButton:
            if validate() {
                kAppDelegate.signupModel.abnNumber = abnNumberTextField.text!.removingWhitespaces()
                kAppDelegate.signupModel.businessName = businessNamTextField.text!.removingWhitespaces()
                viewModel.uploadImages()
            }
        default:
            break
        }
        disableButton(sender)
    }
    
    func validate() -> Bool {
        
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
        
        if businessNamTextField.text!.removingWhitespaces().isEmpty {
            businessNameErrorLabel.text = Validation.errorBusinessNameEmpty
            return false
        } else if businessNamTextField.text!.removingWhitespaces().count < 3 {
            businessNameErrorLabel.text = Validation.errorBusinessName
            return false
        } else {
            businessNameErrorLabel.text = ""
        }
        
        return true
    }
    
    func fetchLocation() {
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.requestLocatinPermission { (status) in
            if status {
                LocationManager.sharedInstance.startLocationUpdates()                
            }
        }
    }
}

extension AddAbnVC {
    
    private func initialSetup() {
        abnNumberTextField.delegate = self
        viewModel.delegate = self
        setupDotImage()
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_8")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_0")
        default:
            break
        }
    }
}

//MARK:- TextFileds Delegate
//==========================
extension AddAbnVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == abnNumberTextField {
        return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 14)
        }else{
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumeric, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)
        }
    }
}
