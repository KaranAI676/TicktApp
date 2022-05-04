//
//  LoginVC.swift
//  Tickt
//
//  Created by Admin on 04/03/21.
//

import UIKit
import TTTAttributedLabel

class LoginVC: BaseVC {
    
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scollViewOutlet: UIScrollView!
    @IBOutlet weak var fullNameContainerView: UIView!
    @IBOutlet weak var fullNameTitleLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var textViewOutlet: CustomTextView!
    @IBOutlet weak var signupAttributedLabel: TTTAttributedLabel!
    @IBOutlet weak var forgottenButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var linkedInLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
                
    var passwordFilled = false
    var viewModel = LoginViewModel()
    var hideBackButton: Bool = false
    var isComingFromCreate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchLocation()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        kAppDelegate.signupModel = SignupModel()
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

extension LoginVC {
    
    private func initialSetup() {
        self.viewModel.delegate = self
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        textViewOutlet.passDelegate = self
        backButton.isHidden = hideBackButton
        emailTextField.setupPasswordTextField()
        signupAttributedLabel.text = "Don't have an account? Sign up"
        setupPrivacyPolicyAndTermsAndConditions(label: signupAttributedLabel)
    }
    
    func goToForgottenVC() {
        let vc = AddPhoneNumberVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCreateAccountVC() {
        
        if let vc = self.navigationController?.viewControllers.first(where: {$0 is CreateAccountVC}) {
            self.navigationController?.popToViewController(vc, animated: true)
        } else {
            let vc = CreateAccountVC.instantiate(fromAppStoryboard: .registration)
            push(vc: vc)            
        }
    }
}

//MARK:- TTTAttributedLabel & TTTAttributedLabelDelegate
//======================================================

extension LoginVC: TTTAttributedLabelDelegate {
    
    func setupPrivacyPolicyAndTermsAndConditions(label:TTTAttributedLabel) {
        
        guard let linkString: NSString = label.text! as? NSString else{ return }
        
        let linkAttributedString = NSAttributedString(string:linkString as String, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle(), NSAttributedString.Key.foregroundColor: UIColor.black])
          
          
          label.setText(linkAttributedString)
        
          label.linkAttributes = [NSAttributedString.Key.foregroundColor: AppColors.highlightedBlue , NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 14)]
       
        let secondTextString: NSRange = linkString.range(of: "Sign up")
        label.addLink(toPhoneNumber: "Sign up" , with: secondTextString)
        label.delegate = self
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        if phoneNumber == "Sign up" {
            if let vc = self.navigationController?.viewControllers.first(where: {$0 is CreateAccountVC}) {
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                goToCreateAccountVC()
            }
        }
    }
}
