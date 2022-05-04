//
//  CreateAccountVC.swift
//  Tickt
//
//  Created by S H U B H A M on 04/03/21.
//

import UIKit
import TTTAttributedLabel
import AuthenticationServices

class CreateAccountVC: BaseVC {

    //MARK:- IB Outlets
    ///
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!    
    @IBOutlet weak var dotImageView: UIImageView!
    ///Nav View
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var scollViewOutlet: UIScrollView!
    /// FullName
    @IBOutlet weak var fullNameContainerView: UIView!
    @IBOutlet weak var fullNameTitleLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    /// Email
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    /// Basic
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var termsAndConditionLabel: TTTAttributedLabel!
    @IBOutlet weak var loginAttributedLabel: TTTAttributedLabel!
    @IBOutlet weak var signUpButton: UIButton!
    /// Social Login
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var linkedInLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
        
    var viewModel = CreateAccountVM()
    
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
    
    private func initialSetup() {
        viewModel.delegate = self
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        setDefaultText()
        setupPrivacyPolicyAndTermsAndConditions(label: termsAndConditionLabel)
        setupPrivacyPolicyAndTermsAndConditions(label: loginAttributedLabel)
        dotImageView.isHidden = true
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_0")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_0")
        default:
            break
        }
    }
    
    private func setDefaultText() {
        loginAttributedLabel.text = "Already have an account? Log in"
        switch kUserDefaults.getUserType() {
        case 1:
            termsAndConditionLabel.text = "I agree to the Tickt Privacy Policy and Terms & Conditions"
        case 2:
            termsAndConditionLabel.text = "I agree to Privacy Policy and Terms & Conditions"
        default:
            break
        }
    }
    
    private func goToLoginVC() {
        let vc = LoginVC.instantiate(fromAppStoryboard: .registration)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TTTAttributedLabel & TTTAttributedLabelDelegate
//======================================================
extension CreateAccountVC: TTTAttributedLabelDelegate {
    
    func setupPrivacyPolicyAndTermsAndConditions(label:TTTAttributedLabel) {
        
        guard let linkString: NSString = label.text! as? NSString else{ return }
        
        let linkAttributedString = NSAttributedString(string:linkString as String, attributes:  [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),  NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle(), NSAttributedString.Key.foregroundColor: UIColor.black])
                
        label.setText(linkAttributedString)
      
        label.linkAttributes = [NSAttributedString.Key.foregroundColor: AppColors.highlightedBlue , NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 13)]
        switch label {
        case loginAttributedLabel:
            let firstTextString: NSRange = linkString.range(of: "Log in")
            label.addLink(toPhoneNumber: "Log in" , with: firstTextString)
        case termsAndConditionLabel:
            let secondTextString: NSRange = linkString.range(of: "Terms & Conditions")
            label.addLink(toPhoneNumber: "Terms & Conditions" , with: secondTextString)
            
            let firstTextString: NSRange = linkString.range(of: "Privacy Policy")
            label.addLink(toPhoneNumber: "Privacy Policy" , with: firstTextString)
        default:
            break
        }
        
        label.delegate = self
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        if phoneNumber != nil {
            if phoneNumber == "Privacy Policy" {
                let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
                vc.screenType = .privacy
                push(vc: vc)
            }
            
            if phoneNumber == "Terms & Conditions" {
                let vc = WebViewController.instantiate(fromAppStoryboard: .registration)
                vc.screenType = .terms
                push(vc: vc)                
            }
        }
        
        if phoneNumber == "Log in" {
            if let vc = self.navigationController?.viewControllers.first(where: {$0 is LoginVC}) {
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                goToLoginVC()
            }
        }
    }
}
