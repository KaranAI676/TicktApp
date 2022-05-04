//
//  JobDescriptionVC.swift
//  Tickt
//
//  Created by S H U B H A M on 18/03/21.
//

import IQKeyboardManagerSwift

class JobDescriptionVC: BaseVC {
    
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
    @IBOutlet weak var detailtextView: UITextView!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var detailErrorLabel: UILabel!
    @IBOutlet weak var descriptionCountLabel: UILabel!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textViewHeightConst: NSLayoutConstraint!
    
    //MARK:- Variables
    var screenType: ScreenType = .creatingJob
    ///
    var maxLength: Int = 1000
    var placeHolder: String = "This Job..."
    var placeHolderColor: UIColor = #colorLiteral(red: 0.6, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
    var placeHolderFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
    var textColor: UIColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
    var textFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kAppDelegate.setUpKeyboardSetup(status: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kAppDelegate.setUpKeyboardSetup(status: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            if screenType == .edit {
                self.pop()
                return
            }
            //            kAppDelegate.postJobModel?.jobDescription = ""
            //            self.pop()
            else if screenType == .creatingJob {
                //  kAppDelegate.postJobModel?.jobDescription = ""
                self.pop()
            }else {
                self.pop()
            }
        case continueButton:
            if validate() {
                if screenType == .edit {
                    self.pop()
                    return
                }
                goToPaymentVC()
            }
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension JobDescriptionVC {
    
    private func initialSetup() {
        self.setupTextView()
        ///
        detailtextView.resignFirstResponder()
        
        if self.screenType == .creatingJob {
            self.detailtextView.text = kAppDelegate.postJobModel?.jobDescription ?? ""
            self.updateDescriptionCount(textCount: self.detailtextView.text.count)
            self.setupTextView(!detailtextView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty)
        }else if self.screenType == .edit {
            self.detailtextView.text = kAppDelegate.postJobModel?.jobDescription ?? nil
            self.updateDescriptionCount(textCount: self.detailtextView.text.count)
            self.setupTextView(true)
        }else if screenType == .republishJob || screenType == .editQuoteJob {
            self.detailtextView.text = kAppDelegate.postJobModel?.jobDescription ?? nil
            self.updateDescriptionCount(textCount: self.detailtextView.text.count)
            self.setupTextView(!detailtextView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty)
        }
    }
    
    private func setupTextView(_ edit: Bool = false) {
        self.detailtextView.delegate = self
        if edit {
            self.detailtextView.font = textFont
            self.detailtextView.textColor = textColor
        }else {
            self.detailtextView.text = placeHolder
            self.detailtextView.font = placeHolderFont
            self.detailtextView.textColor = placeHolderColor
        }
    }
    
    private func goToPaymentVC() {
        let vc = PaymentVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = screenType
        self.push(vc: vc)
    }
    
    private func updateDescriptionCount(textCount: Int) {
        self.descriptionCountLabel.text = "\(textCount)/\(maxLength)"
    }
}

//MARK:- UITextField: Delegates
//=============================
extension JobDescriptionVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true//CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumericPunctuation, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 5000000)
    }
}

//MARK:- Validation
//=================
extension JobDescriptionVC {
    
    private func validate() -> Bool {
        let text = self.detailtextView.text!.byRemovingLeadingTrailingWhiteSpaces
        if text.isEmpty || text == placeHolder {
            CommonFunctions.showToastWithMessage("Please enter the job description")
            return false
        }else {
            kAppDelegate.postJobModel?.jobDescription = text
        }
        return true
    }
}

//MARK:- UITextField Delegate
//===========================
extension JobDescriptionVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewDidChangeSelection(textView)
        if let text = textView.text {
            textView.text = text.byRemovingLeadingTrailingWhiteSpaces
            if text == placeHolder {
                textView.text = ""
                textView.font = textFont
                textView.textColor = textColor
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if detailtextView.contentSize.height > detailtextView.frame.size.height {
            if textView.contentSize.height < textView.frame.size.height {
                self.textViewHeightConst.constant = 34
            } else {
                self.textViewHeightConst.constant = self.detailtextView.contentSize.height
                self.textViewHeightConst.constant = self.detailtextView.contentSize.height
            }
        } else if textView.contentSize.height < textView.frame.size.height {
            self.textViewHeightConst.constant = self.detailtextView.contentSize.height
        }
        
        let height = self.view.frame.height - 330
        if height <  self.textViewHeightConst.constant {
            self.textViewHeightConst.constant = height
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewDidChangeSelection(textView)
        if let text = textView.text {
            textView.text = text.byRemovingLeadingTrailingWhiteSpaces
            if text == "" {
                textView.text = placeHolder
                textView.font = placeHolderFont
                textView.textColor = placeHolderColor
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            textView.resignFirstResponder()
            return false
        }
        let txtt: NSString = textView.text as NSString
        let newString = txtt.replacingCharacters(in: range, with: text)
        if text == placeHolder {
            textView.text = ""
        }
        
        if newString.count <= self.maxLength {
            self.updateDescriptionCount(textCount: newString.byRemovingLeadingTrailingWhiteSpaces.count)
        }
        return newString.count <= self.maxLength
        
    }
}
