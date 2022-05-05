//
//  PaymentVC.swift
//  Tickt
//
//  Created by S H U B H A M on 19/03/21.
//

import UIKit

class PaymentVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    /// TextFields
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var detailTextField: UITextField!
    /// DropDown
    @IBOutlet weak var dropDownStackView: UIStackView!
    @IBOutlet weak var dropDownContainerView: UIView!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var openListButton: UIButton!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    ///
    @IBOutlet weak var bottomListViewContainer: UIView!
    @IBOutlet weak var bottomListStackView: UIStackView!
    @IBOutlet weak var perHourButton: UIButton!
    @IBOutlet weak var fixedHourButton: UIButton!
    @IBOutlet weak var fixedPriceBackView: UIView!
    @IBOutlet weak var budgetButton: UIButton!
    @IBOutlet weak var quoteButton: UIButton!
    
    //MARK:- Variables
    var price: String = ""
    var screenType: ScreenType = .creatingJob
    var paymentType: PaymentType = .perHour
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeDropDownList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
                pop()
        case continueButton:
            if validate() {
                goToCalendarVC()
            }
        case perHourButton:
            if !budgetButton.isSelected { return }
            bottomListViewContainer.popOut(completion: { [weak self] bool in
                guard let self = self else { return }
                self.paymentType = .perHour
                self.dropDownTextField.text = self.paymentType.rawValue
                self.dropDownContainerView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                self.dropDownImageView.transform = self.dropDownImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        case fixedHourButton:
            if !budgetButton.isSelected { return }
            bottomListViewContainer.popOut(completion: { [weak self] bool in
                guard let self = self else { return }
                self.paymentType = .fixedPrice
                self.dropDownTextField.text = self.paymentType.rawValue
                self.dropDownContainerView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                self.dropDownImageView.transform = self.dropDownImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        case openListButton:
            if !budgetButton.isSelected { return }
            detailTextField.resignFirstResponder()
            dropDownImageView.transform = dropDownImageView.transform.rotated(by: CGFloat(Double.pi))
            let _ = bottomListViewContainer.alpha != 0 ? bottomListViewContainer.popOut() : bottomListViewContainer.popIn()
            bottomListViewContainer.alpha != 0 ? dropDownContainerView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]) : dropDownContainerView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        case budgetButton:
            detailTextField.isUserInteractionEnabled = true
            quoteButton.isSelected = false
            budgetButton.isSelected = true
            dropDownContainerView.alpha = 1
            
        case quoteButton:
            detailTextField.isUserInteractionEnabled = false
            quoteButton.isSelected = true
            budgetButton.isSelected = false
            dropDownContainerView.alpha = 0.5
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension PaymentVC {
    
    private func initialSetup() {
        bottomListViewContainer.alpha = 0
        detailTextField.delegate = self
        dropDownTextField.delegate = self
        dropDownContainerView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        fixedPriceBackView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        fixedHourButton.contentHorizontalAlignment = .left
        perHourButton.contentHorizontalAlignment = .left
        
        if screenType == .republishJob || screenType == .editQuoteJob || screenType == .creatingJob {
            if !(kAppDelegate.postJobModel?.paymentAmount ?? "").isEmpty && kAppDelegate.postJobModel?.paymentAmount ?? "" != "0.0" {
                detailTextField.text = kAppDelegate.postJobModel?.paymentAmount.getFormattedPrice()
                dropDownTextField.text = kAppDelegate.postJobModel?.paymentType.rawValue
                price = kAppDelegate.postJobModel?.paymentAmount ?? ""
                detailTextField.isUserInteractionEnabled = true
                quoteButton.isSelected = false
                budgetButton.isSelected = true
                dropDownContainerView.alpha = 1
            }else{
                detailTextField.text = ""//kAppDelegate.postJobModel?.paymentAmount.getFormattedPrice()
                dropDownTextField.text = kAppDelegate.postJobModel?.paymentType.rawValue
                price = kAppDelegate.postJobModel?.paymentAmount ?? ""
                detailTextField.isUserInteractionEnabled = false
                quoteButton.isSelected = true
                budgetButton.isSelected = false
                dropDownContainerView.alpha = 0.5
            }
            
         //   if screenType == .editQuoteJob && kAppDelegate.postJobModel?.isQuoteJob ?? false{
            if kAppDelegate.postJobModel?.isQuoteJob ?? false{
                budgetButton.isEnabled = false
            }else{
                budgetButton.isEnabled = true
            }
        }
        
        detailTextField.addTarget(self, action: #selector(textFieldDidChange) , for: .editingChanged)
        bottomListViewContainer.dropShadow(color: #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.8078431373, alpha: 1), opacity: 0.2, offSet: CGSize(width: 10, height: 5), radius: 3, scale: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces {
            var newText = text.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
            newText = newText.replace(string: ",", withString: CommonStrings.emptyString)
            if newText.isEmpty || (newText.count == 1 && newText == CommonStrings.dot) {
                textField.text = CommonStrings.emptyString
                price = newText
            } else {
                price = newText
                textField.text = newText.getFormattedPrice()
            }
        }
    }
    
    private func goToCalendarVC() {
        let vc = CalendarVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = screenType
        push(vc: vc)
    }
    
    private func closeDropDownList() {
        if bottomListViewContainer.alpha == 0 {
            return
        }
        bottomListViewContainer.popOut()
        dropDownContainerView.makeRoundToCorner(cornerRadius: 3, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        dropDownImageView.transform = dropDownImageView.transform.rotated(by: CGFloat(Double.pi))
    }
    
}

//MARK:- UITextField: Delegate
//============================
extension PaymentVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case detailTextField:
            closeDropDownList()
            return true
        case dropDownTextField:
            return false
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.byRemovingLeadingTrailingWhiteSpaces
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? CommonStrings.emptyString
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText == "0" || updatedText == "$0" || updatedText == "$." {
            return false
        }
        
        var dollarRemovedCurrentText = currentText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
        var dollarRemovedUpdatedTrxt = updatedText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
        ///
        dollarRemovedCurrentText = dollarRemovedCurrentText.replace(string: ",", withString: CommonStrings.emptyString)
        dollarRemovedUpdatedTrxt = dollarRemovedUpdatedTrxt.replace(string: ",", withString: CommonStrings.emptyString)
        
        /// This block of code used to restrict the user, Once the price entered of Six digits. eg: 123456
//        if dollarRemovedUpdatedTrxt.count > 6 && !(dollarRemovedCurrentText.contains(CommonStrings.dot)) {
//            return false
//        }
        /// This block of code used to handle the decimal part of the price. eg: 12345.12
        if dollarRemovedUpdatedTrxt.isValidPrice {
            return true
        } else {
            if dollarRemovedUpdatedTrxt.last == "." || dollarRemovedCurrentText.last == "." {
                if string == CommonStrings.emptyString {
                    return true
                } else {
                    if string == "." {
                        return !currentText.contains(CommonStrings.dot)
                    }
                }
            }
            else { return false }
        }
        return true
    }
}

extension PaymentVC {
    
    private func validate() -> Bool {
        if quoteButton.isSelected {
            kAppDelegate.postJobModel?.isQuoteJob = quoteButton.isSelected
        } else {
            
            if price.isEmpty {
                CommonFunctions.showToastWithMessage("Please enter the amount")
                return false
            } else {
                kAppDelegate.postJobModel?.paymentAmount = price.byRemovingLeadingTrailingWhiteSpaces
                kAppDelegate.postJobModel?.paymentType = paymentType
                kAppDelegate.postJobModel?.isQuoteJob = false
            }
        }
        return true
    }
}
