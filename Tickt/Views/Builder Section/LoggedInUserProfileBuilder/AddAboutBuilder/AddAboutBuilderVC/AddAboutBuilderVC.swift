//
//  AddAboutBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import UIKit

protocol AddAboutBuilderVCDelegate: AnyObject {
    func getUpdatedAbout(text: String)
}

class AddAboutBuilderVC: BaseVC {

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
    var about: String? = nil
    var maxLength: Int = 1000
    var placeHolder = kUserDefaults.isTradie() ? "Describe your skills and experience..." : "Our company specialises in.."
    var placeHolderColor: UIColor = #colorLiteral(red: 0.6, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
    var placeHolderFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
    var textColor: UIColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
    var textFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
    weak var delegate: AddAboutBuilderVCDelegate? = nil
    
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
            pop()
        case continueButton:
            delegate?.getUpdatedAbout(text: detailtextView.text.byRemovingLeadingTrailingWhiteSpaces)
            pop()
        default:
            break
        }
        disableButton(sender)
    }
}

extension AddAboutBuilderVC {
    
    private func initialSetup() {
        setupTextView()
        detailtextView.resignFirstResponder()
        if let text = about {
            detailtextView.text = text
            updateDescriptionCount(textCount: self.detailtextView.text.count)
            setupTextView(true)
        }
        if kUserDefaults.isTradie() {
            detailTitleLabel.text = "About yourself"
        }
    }
    
    private func setupTextView(_ edit: Bool = false) {
        detailtextView.placeholder = placeHolder
        screenTitleLabel.text = kUserDefaults.isTradie() ? "About you" : "About company"
        descriptionLabel.text = kUserDefaults.isTradie() ? "Additional information about your skills and experience can help builders to make an easy decision to invite you for jobs." : "Additional information about your company can help attract more applicants to your jobs."
        detailtextView.delegate = self
        if edit {
            detailtextView.font = textFont
            detailtextView.textColor = textColor
        } else {
            detailtextView.text = placeHolder
            detailtextView.font = placeHolderFont
            detailtextView.textColor = placeHolderColor
        }
    }
    
    private func updateDescriptionCount(textCount: Int) {
        descriptionCountLabel.text = "\(textCount)/\(maxLength)"
    }
}

extension AddAboutBuilderVC: UITextViewDelegate {
    
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
                textViewHeightConst.constant = 34
            } else {
                textViewHeightConst.constant = self.detailtextView.contentSize.height
                textViewHeightConst.constant = self.detailtextView.contentSize.height
            }
        } else if textView.contentSize.height < textView.frame.size.height {
            textViewHeightConst.constant = self.detailtextView.contentSize.height
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
            updateDescriptionCount(textCount: newString.byRemovingLeadingTrailingWhiteSpaces.count)
        }
        return newString.count <= self.maxLength
    }
}
