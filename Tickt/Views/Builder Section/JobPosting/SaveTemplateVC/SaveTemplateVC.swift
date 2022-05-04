//
//  SaveTemplateVC.swift
//  Tickt
//
//  Created by S H U B H A M on 22/03/21.
//

import UIKit

class SaveTemplateVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    /// TextFields
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var detailErrorLabel: UILabel!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var milestoneArray = [MilestoneModel]()
    var viewModel = SaveTemplateVM()
    
    //MARK:- LifeCycle Method
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
            self.pop()
        case continueButton:
            if let text = self.detailTextField.text?.byRemovingLeadingTrailingWhiteSpaces, !text.isEmpty {
                self.viewModel.saveTemplate(templateName: text, milestoneArray: self.milestoneArray)
            }else {
                CommonFunctions.showToastWithMessage("Please enter template name")
            }
        default:
            break
        }
        disableButton(sender)
    }
}


//MARK:- Private Methods
//======================
extension SaveTemplateVC {
    
    private func initialSetup() {
        detailTextField.delegate = self
        detailTextField.autocapitalizationType = .words
        viewModel.delegate = self
    }
    
    private func goToSuccessVC() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .saveTemplate
        self.push(vc: vc)
    }
}

//MARK:- UITextField: Delegates
//=============================
extension SaveTemplateVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphabets, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)
    }
}


extension SaveTemplateVC: SaveTemplateVMDelegate {
    
    func success() {
        self.goToSuccessVC()
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage("Error: \(error)")
    }
}
