//
//  VerifyPhoneNumberVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/03/21.
//

import UIKit

class VerifyPhoneNumberVC: BaseVC {
    
    //MARK:- IB Outlets
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    /// OTP TextFields
    @IBOutlet weak var verificationContainerView: UIView!
    @IBOutlet weak var verificationTitleView: UILabel!
    @IBOutlet weak var verificationTextfieldView: VPMOTPView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var didNotReceiveLabel: UILabel!
    /// Bottom Buttons
    @IBOutlet weak var resendTitleLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK:- Variables
    var model = ChangeEmailModel()
    var validOTP = false
    var timer = Timer()
    var seconds = 61 {
        didSet {
            if seconds <= -1 {
                resendButton.isEnabled = true
                resendTitleLabel.text = "Re-send code"
                timer.invalidate()
                seconds = 61
            } else {
                resendButton.isEnabled = false
                resendTitleLabel.text = getFormattedTime()
            }
        }
    }
    
    var number = ""
    var otpString: String = ""
    var viewModel = VerifyPhoneVM()
    var screenType: ScreenType = .createAccount
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case resendButton:
            setupOtpView()
            resendBtunAction()
        case nextButton:
            nextBtnAction()
        default:
            break
        }
        disableButton(sender)
    }
    
    func validate() -> Bool {
        if otpString.isEmpty || otpString.count < 5 || !validOTP {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyOTP)
            return false
        }
        return true
    }
    
    private func resendBtunAction() {
        switch screenType {
        case .createAccount:
            viewModel.verifyPhoneNumber(phoneNumber: number)
        case .edit:
            viewModel.resendOTPForReset(phoneNumber: number)
        case .changeEmail:
            viewModel.resendEmailOTP(model: model)
        default:
            viewModel.resendOTPOnEmailForCreateAccount()
        }
        otpString = ""
    }
    
    private func nextBtnAction() {
        if validate() {
            switch screenType {
            case .createAccount:
                viewModel.verifyOTPForPhoneForCreateAccount(otpString: otpString)
            case .edit:
                viewModel.verifyOTPForReset(otpString: otpString, email: number)
            case .changeEmail:
                viewModel.verifyEmail(newEmail: model.newEmail, otp: otpString)
            case .verifyEmail:
                viewModel.verifyOTPForEmailForCreateAccount(otpString: otpString)
            default:
                break
            }
        }
    }
    
    func goToCreatePasswordVC() {
        let passwordVC = CreatePasswordVC.instantiate(fromAppStoryboard: .registration)
        passwordVC.number = number
        passwordVC.screenType = screenType
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(passwordVC, animated: true)
        }
    }
}

//MARK:- Private Methods
//=======================
extension VerifyPhoneNumberVC {
    
    private func initialSetup() {
        setupOtpView()
        viewModel.delegate = self
        dotImageView.isHidden = (screenType != .createAccount && screenType != .verifyEmail)
        resendTitleLabel.text = ""
        setDefaultText()
        setupDotImage()
        startTimer()
    }
    
    private func setupDotImage() {
        switch screenType {
        case .createAccount: // Phone Number
            if kUserDefaults.isTradie() {
                dotImageView.image = #imageLiteral(resourceName: "pgTradie_3")
            } else {
                dotImageView.image = #imageLiteral(resourceName: "pgBuilder_3")
            }
        case .edit:
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_1")
        case .changeEmail:
            dotImageView.isHidden = true
        case .verifyEmail:
            if kUserDefaults.isTradie() {
                dotImageView.image = #imageLiteral(resourceName: "pgTradie_1")
            } else {
                dotImageView.image = #imageLiteral(resourceName: "pgBuilder_1")
            }
        default:
            dotImageView.isHidden = true
        }
    }
    
    private func setupOtpView() {
        verificationTextfieldView.otpFieldsCount = 5
        verificationTextfieldView.otpFieldInputType = .numeric
        verificationTextfieldView.otpFieldDisplayType = .square
        verificationTextfieldView.otpFieldDefaultBorderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        verificationTextfieldView.otpFieldDefaultBackgroundColor = AppColors.pureWhite
        verificationTextfieldView.otpFieldEnteredBackgroundColor = AppColors.pureWhite
        verificationTextfieldView.otpFieldBorderWidths = 1
        verificationTextfieldView.otpFieldSeparatorSpace = 18
        verificationTextfieldView.cursorColor = AppColors.themeYellow        
        verificationTextfieldView.otpFieldFont = UIFont.kAppDefaultFontMedium(ofSize: 15)
        verificationTextfieldView.otpFieldEntrySecureType = false
        verificationTextfieldView.otpFieldEnteredBorderColor = AppColors.borderColor
        verificationTextfieldView.otpFieldEnteredBorderColor = AppColors.borderColor
        verificationTextfieldView.delegate = self
        verificationTextfieldView.semanticContentAttribute = .forceLeftToRight
        verificationTextfieldView.initializeUI()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    private func setDefaultText() {
        switch screenType {
        case .createAccount:
            descriptionLabel.text = "We have sent a verification code to your phone. Please check your SMS and enter the 5-digit code."
            didNotReceiveLabel.text = "Didn’t receive a code?"
        case .edit:
            screenTitleLabel.text = "Verify your email"
            descriptionLabel.text = "We have sent a verification code to your email. Please check email and enter the 5-digit code here."
            didNotReceiveLabel.text = "Don’t you receive a code?"
        case .changeEmail, .verifyEmail:
            screenTitleLabel.text = "Verify your email"
            descriptionLabel.text = "We have sent a verification code to your new email address. Please check the 5-digit code there."
            didNotReceiveLabel.text = "Don’t you receive a code?"
            if screenType == .verifyEmail {
                nextButton.setTitleForAllMode(title: "Next")
            } else {
                nextButton.setTitleForAllMode(title: "Save Changes")
            }
        default:
            break
        }
    }
    
    private func getFormattedTime() -> String {
        let minutes = Int(TimeInterval(seconds)) / 60 % 60
        let second = Int(TimeInterval(seconds)) % 60
        return String(format:"%02i:%02i", minutes, second)
    }
    
    @objc func updateTimer() {
        seconds -= 1
    }
}

//MARK:- UITextfield Delegate
//===========================
extension VerifyPhoneNumberVC: UITextFieldDelegate, VPMOTPViewDelegate {
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        self.otpString = otpString
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        if hasEntered {
            validOTP = true
        } else {
            validOTP = false
        }
        return true
    }
        
}
