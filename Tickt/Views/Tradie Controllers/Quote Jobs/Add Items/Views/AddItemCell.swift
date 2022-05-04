//
//  AddItemCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 07/09/21.
//

import UIKit

class AddItemCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteLabel: CustomBoldLabel!
    @IBOutlet weak var addItemLabel: CustomMediumLabel!
    @IBOutlet weak var addItemButton: CustomBoldButton!
    @IBOutlet weak var priceTextField: CustomMediumField!
    @IBOutlet weak var numberTextField: CustomMediumField!
    @IBOutlet weak var totalPriceField: CustomMediumField!
    @IBOutlet weak var quantityTextField: CustomMediumField!
    @IBOutlet weak var descriptionCountLabel: CustomMediumLabel!
    @IBOutlet weak var descriptionTextView: CustomMediumTextView!
    
    var price = ""
    var itemId = ""
    var quoteId = ""
    var isLastItem = false
    var deleteButtonAction: (()->())?
    var addButtonAction: ((_ itemDetail: ItemDetails)->())?
    var currentItemNumber: Int = 1 {
        didSet {
            numberTextField.text = "\(currentItemNumber)"
        }
    }
    
    var editItemDetail: ItemDetails? {
        didSet {
            if editItemDetail != nil {
                price = "\(editItemDetail?.price ?? 0)"
                itemId = editItemDetail?.id ?? ""
                quoteId = editItemDetail?.quoteId ?? ""
                numberTextField.text = "\(editItemDetail?.itemNumber ?? 0)"
                quantityTextField.text = "\(editItemDetail?.quantity ?? 0)"
                descriptionTextView.text = editItemDetail?.description
                priceTextField.text = "$" + "\(editItemDetail?.price ?? 0)"
                totalPriceField.text = "$" + "\(editItemDetail?.totalAmount ?? 0)"
                descriptionCountLabel.text = "\(editItemDetail?.description.count ?? 0) / 220"
                editItemDetail = nil
            }
        }
    }
        
    var isEditItem: Bool = false {
        didSet {
            deleteLabel.isHidden = !(!isLastItem && isEditItem)
            deleteButton.isHidden = !(!isLastItem && isEditItem)
            
            if isEditItem {
                addItemLabel.text = "Edit Item"
                addItemButton.setTitle("Save Item", for: .normal)
            } else {
                addItemLabel.text = "Add Item"
                addItemButton.setTitle("Add Item", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceTextField.applyLeftPadding(padding: 10)
        totalPriceField.applyLeftPadding(padding: 10)
        numberTextField.applyLeftPadding(padding: 10)
        quantityTextField.applyLeftPadding(padding: 10)
        descriptionTextView.applyLeftPadding(padding: 8)
        priceTextField.delegate = self
        quantityTextField.delegate = self
        descriptionTextView.delegate = self
        priceTextField.addTarget(self, action: #selector(textFieldDidChangeText(_:)) , for: .editingChanged)
        quantityTextField.addTarget(self, action: #selector(textFieldDidChangeText(_:)) , for: .editingChanged)
    }
    
    func validateItem() -> Bool {
        if descriptionTextView.text!.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter item description.")
            return false
        }
        
        if priceTextField.text!.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter item price.")
            return false
        }
        
        if quantityTextField.text!.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter quantity")
            return false
        }
        
        if quantityTextField.text! == "0" {
            CommonFunctions.showToastWithMessage("Quantity cannot be 0")
            return false
        }
                
        return true
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case deleteButton:
            AppRouter.showAppAlertWithCompletion(vc: nil, alertType: .bothButton,
                                                 alertTitle: "Delete Item",
                                                 alertMessage: "Are you sure you want to delete this item?",
                                                 acceptButtonTitle: "Delete",
                                                 declineButtonTitle: "Cancel") { [weak self] in
                self?.deleteButtonAction?()
            } dismissCompletion: { }
        case addItemButton:
            if validateItem() {
                endEditing(true)
                guard let priceAmount = priceTextField.text else { return }
                let priceText = priceAmount.replace(string: "$", withString: "")
                let finalPrice = priceText.replace(string: ",", withString: "")
                let totalAmount = "\(finalPrice.doubleValue * quantityTextField.text!.doubleValue)"
                // let totalAmount = "\(priceTextField.text!.doubleValue * quantityTextField.text!.doubleValue)"
                if isEditItem {
                    let itemDetail = ItemDetails(id: itemId, status: 0, price: Double.getDouble(price), quoteId: quoteId, quantity: Int.getInt(quantityTextField.text!), itemNumber: Int.getInt(numberTextField.text!), totalAmount: Double.getDouble(totalAmount), description: descriptionTextView.text)
                    addButtonAction?(itemDetail)
                } else {
                    let itemDetail = ItemDetails(id: "1", status: 0, price: Double.getDouble(price), quoteId: "", quantity: Int.getInt(quantityTextField.text!), itemNumber: Int.getInt(numberTextField.text!), totalAmount: Double.getDouble(totalAmount), description: descriptionTextView.text)
                    addButtonAction?(itemDetail)
                }
            }
        default:
            break
        }
    }
    
    func clearForm() {
        price = ""
        itemId = ""
        quoteId = ""
        priceTextField.text = ""
        totalPriceField.text = ""
        quantityTextField.text = "1"
        deleteLabel.isHidden = true
        deleteButton.isHidden = true
        descriptionTextView.text = ""
        addItemLabel.text = "Add Item"
        descriptionCountLabel.text = "0 / 220"
        numberTextField.text = "\(currentItemNumber)"
        addItemButton.setTitle("Add Item", for: .normal)
    }
}

extension AddItemCell: UITextFieldDelegate, UITextViewDelegate {
            
    
    @objc func textFieldDidChangeText(_ textField: UITextField) {
        if let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces, textField == priceTextField {
            var newText = text.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
            newText = newText.replace(string: ",", withString: CommonStrings.emptyString)
            if newText.isEmpty || (newText.count == 1 && newText == CommonStrings.dot) {
                textField.text = CommonStrings.emptyString
                price = newText
            } else {
                price = newText
                textField.text = newText.getFormattedPrice()
            }
            let amount = "\(Double.getDouble(quantityTextField.text) * Double.getDouble(price))"
            totalPriceField.text = amount.numberFormatting()
        } else {
            let amount = "\(Double.getDouble(textField.text) * Double.getDouble(price))"
            totalPriceField.text = amount.numberFormatting()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if updatedText.count <= 220 {
            descriptionCountLabel.text = "\(updatedText.count) / 220"
        }
        return updatedText.count <= 220
    }
}

extension AddItemCell {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.byRemovingLeadingTrailingWhiteSpaces
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? CommonStrings.emptyString
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if textField == priceTextField {
            
            if updatedText == "0" || updatedText == "$0" || updatedText == "$." {
                return false
            }
            
            var dollarRemovedCurrentText = currentText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
            var dollarRemovedUpdatedText = updatedText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
            ///
            dollarRemovedCurrentText = dollarRemovedCurrentText.replace(string: ",", withString: CommonStrings.emptyString)
            dollarRemovedUpdatedText = dollarRemovedUpdatedText.replace(string: ",", withString: CommonStrings.emptyString)

            if dollarRemovedUpdatedText.isValidPrice {
                return true
            } else {
                if dollarRemovedUpdatedText.last == "." || dollarRemovedCurrentText.last == "." {
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
        } else if textField == quantityTextField {
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range)
        }
        return true
    }
}

extension String {
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutSymbolDot = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
        let stringWithoutComma = stringWithoutSymbolDot.replacingOccurrences(of: ".", with: "")
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 0
        styler.maximumFractionDigits = 0
        styler.currencySymbol = "$"
        styler.numberStyle = .currency
        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return styler.string(from: result)!
        }

        return self
    }
}


/*
 
 
 
 DidChange
 let newText = text.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
 if newText.isEmpty || (newText.count == 1 && newText == CommonStrings.dot) {
     textField.text = CommonStrings.emptyString
     price = newText
 } else {
//                textField.text = CommonStrings.dollar + newText
     if newText.contains(".") {
         textField.text = CommonStrings.dollar + newText
     } else {
         textField.text = newText.currency
     }
     price = newText.replace(string: ",", withString: "")
 }
 
 
 
 Should Change
 if updatedText == "0" || updatedText == "$0" || updatedText == "$." {
     return false
 }
 let dollarRemovedCurrentText = currentText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
 let dollarRemovedUpdatedText = updatedText.replace(string: CommonStrings.dollar, withString: CommonStrings.emptyString)
 
 let dollarRemovedUpdatedTrxtt = dollarRemovedUpdatedText.replace(string: ",", withString: CommonStrings.emptyString).replacingOccurrences(of: " ", with: "")
 if dollarRemovedUpdatedTrxtt.isValidPrice {
     return true
 } else {
     if dollarRemovedUpdatedText.last == "." || dollarRemovedCurrentText.last == "." || dollarRemovedUpdatedTrxtt == "." {
         if string == CommonStrings.emptyString {
             return true
         } else {
             if string == "." {
                 return !currentText.contains(CommonStrings.dot)
             }
         }
     } else {
         return false
     }
 }

 
*/


