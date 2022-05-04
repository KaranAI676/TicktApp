//
//  AddPaymentDetailsBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddPaymentDetailsBuilderVCDelegate: AnyObject {
    func getNewlyAddedCard(model: CardListResultModel)
}

class AddPaymentDetailsBuilderVC: BaseVC {

    enum ArrayType: Int, CaseIterable {
        case month
        case year
    }
    
    enum SectionArray {
        case cardNumber
        case cardHolderName
        case ExpirationDate
        
        var title: String {
            switch self {
            case .cardNumber:
                return "Card Number"
            case .cardHolderName:
                return "Cardholder Name"
            case .ExpirationDate:
                return "Expiration Date"
            }
        }
        
        var height: CGFloat {
            switch self {
            case .ExpirationDate:
                return CGFloat.leastNonzeroMagnitude
            default:
                return 30
            }
        }
        
        var keyBoardType: UIKeyboardType {
            switch self {
            case .cardNumber:
                return .numberPad
            case .cardHolderName:
                return .alphabet
            case .ExpirationDate:
                return .numberPad
            }
        }
        
        var color: UIColor {
            return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
        }
        
        var font: UIFont {
            return UIFont.systemFont(ofSize: 15)
        }
    }
    
    enum ScreenType {
        case addDetails
        case editDetails
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: CustomBoldLabel!
    @IBOutlet weak var subScreenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var payButton: CustomBoldButton!
    
    //MARK:- Variables
    var model = AddPaymentDetailBuilderModel()
    var viewModel = AddPaymentDetailsBuilderVM()
    var sectionArray: [SectionArray] = []
    let expirationDatePicker = UIPickerView()
    var monthYearArray = [[String]]()
    var isComingFromProfile: Bool = false
    var screenType: ScreenType = .addDetails
    weak var delegate: AddPaymentDetailsBuilderVCDelegate? = nil
    
    //MARK:- LifeCycle Methods
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
            pop()
        case payButton:
            if validate() {
                switch screenType {
                case .addDetails:
                    viewModel.addCardDetail(model: model)
                case .editDetails:
                    viewModel.editCardDetail(model: model)
                }
            }
        default:
            break
        }
    }
}

extension AddPaymentDetailsBuilderVC {
    
    private func initialSetup() {
        setupExpirationPickerView()
        sectionArray = [.cardNumber, .cardHolderName, .ExpirationDate]
        setupTableView()
        payButton.setTitleForAllMode(title: (screenType == .editDetails) ? "Save Changes" : "Save")
        viewModel.delegate = self
    }
    
    private func setupExpirationPickerView() {
//        expirationDatePicker.tag = 1
        monthYearArray = []
        /// Months
        var months: [String] = []
        for i in 1...12 {
            months.append(String(format:"%02i", i))
        }
        monthYearArray.append(months)
        
        /// Years
        var years = [String]()
        for i in 0..<10 {
            years.append((Date().plus(years: UInt(i))).toString(dateFormat: "YY"))
        }
        monthYearArray.append(years)
        
        if (monthYearArray[1][expirationDatePicker.selectedRow(inComponent: expirationDatePicker.numberOfComponents - 1)]) == Date().toString(dateFormat: "YY") {
            months = []
            for i in Date().month...12 {
                months.append(String(format:"%02i", i))
            }
        }
        monthYearArray[0] = months
        ///
        self.expirationDatePicker.delegate = self
        self.expirationDatePicker.dataSource = self
    }
    
    private func setPrefilledComponents(animation: Bool = false) {
        let expirationMonthYear = model.expirationDate.split(separator: "/")
        
        if let month = expirationMonthYear.first,
           let indexOfMonth = monthYearArray[0].firstIndex(where: { eachModel -> Bool in
            return eachModel == month
           }) {
            self.expirationDatePicker.selectRow(indexOfMonth, inComponent: 0, animated: false)
        }
        
        if expirationMonthYear.count > 1,
           let year = expirationMonthYear.last,
           let indexOfYear = monthYearArray[1].firstIndex(where: { eachModel -> Bool in
            return eachModel == year
           }) {
            self.expirationDatePicker.selectRow(indexOfYear, inComponent: 1, animated: false)
        }
        expirationDatePicker.reloadAllComponents()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: CCVTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    @objc private func doneButton() {
        let month = Int(monthYearArray[0][expirationDatePicker.selectedRow(inComponent: 0)]) ?? 0
        let year = Int(monthYearArray[1][expirationDatePicker.selectedRow(inComponent: 1)]) ?? 0
        model.expirationDate = String(format:"%02i/%02i", month, year)
        model.expirationMonth = month
        model.expirationYear = year
        self.tableViewOutlet.reloadData()
    }
}

extension AddPaymentDetailsBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sectionArray[indexPath.section] {
        case .ExpirationDate:
            let cell = tableView.dequeueCell(with: CCVTableCell.self)
            cell.cvvTextField.delegate = self
            cell.expirationTextField.delegate = self
            cell.expirationTextField.inputView = expirationDatePicker
            cell.expirationTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            cell.cvvTextField.text = "\(model.cvv)"
            cell.expirationTextField.text = model.expirationDate
//            cell.expirationTextField.text?.insert(separator: "/", every: 2)
//            cell.expirationTextField.tag = 1
            ///
            if screenType == .editDetails, sectionArray[indexPath.section] == .ExpirationDate {
                cell.cvvTextField.isUserInteractionEnabled = false
                cell.cvvTextField.textColor = #colorLiteral(red: 0.6, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
            }
            ///
            cell.cvvClosure = { [weak self] (text) in
                guard let self = self else { return }
                self.model.cvv = text
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.tableView = tableView
            cell.commonTextFiled.autocapitalizationType = .words
            cell.commonTextFiled.placeholder = sectionArray[indexPath.section].title
            cell.commonTextFiled.keyboardType = sectionArray[indexPath.section].keyBoardType
            cell.commonTextFiled.delegate = self
            cell.commonTextFiled.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            ///
            if screenType == .editDetails, sectionArray[indexPath.section] == .cardNumber {
                cell.commonTextFiled.isUserInteractionEnabled = false
                cell.commonTextFiled.textColor = #colorLiteral(red: 0.6, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
            }
            ///
            cell.commonTextFiled.autocapitalizationType = .none
            switch sectionArray[indexPath.section] {
            case .cardNumber:
                let number = screenType == .editDetails ? model.cardNumber.geFormattedAccountNo(true) : model.cardNumber
                cell.commonTextFiled.text = number
                didChangeText(textfield: cell.commonTextFiled)
            case .cardHolderName:
                cell.commonTextFiled.autocapitalizationType = .sentences
                cell.commonTextFiled.text = model.holderName
            default:
                break
            }
            cell.updateTextWithIndexClosure = { [weak self] (text, index) in
                guard let self = self else { return }
                switch self.sectionArray[index.section] {
                case .cardNumber:
                    self.model.cardNumber = text
                case .cardHolderName:
                    self.model.holderName = text
                default: break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = sectionArray[section].title
        header.headerLabel.textColor = sectionArray[section].color
        header.headerLabel.font = sectionArray[section].font
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
    
    @objc func didChangeText(textfield: UITextField) {
        guard let index = textfield.tableViewIndexPath(self.tableViewOutlet) else { return }
        
        switch self.sectionArray[index.section] {
        case .cardNumber:
            if let cell = tableViewOutlet.cellForRow(at: index) as? CommonTextfieldTableCell {
                //                    textfield.text = textfield.text?.removeCharacters(char: " ")
                cell.commonTextFiled.text?.removeAll{ !("0"..."9" ~= $0 || $0 == "+") }
                cell.commonTextFiled.text?.insert(separator: " ", every: 4)
            }
        case .ExpirationDate:
            if let cell = tableViewOutlet.cellForRow(at: index) as? CCVTableCell {
                switch textfield {
                case cell.expirationTextField:
                    textfield.text = textfield.text?.removeCharacters(char: "/")
                    textfield.text?.insert(separator: "/", every: 2)
                default:
                    break
                }
            }
        default:
            break
        }
    }
}


extension AddPaymentDetailsBuilderVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return true }
        
        switch self.sectionArray[index.section] {
        case .cardNumber:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 16 + 3) /// 16Digits + 3Spaces
        case .cardHolderName:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphabets, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)
        case .ExpirationDate:
            if let cell = tableViewOutlet.cellForRow(at: index) as? CCVTableCell {
                switch textField {
                case cell.cvvTextField:
                    return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 3)
                case cell.expirationTextField:
                    return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.numbers, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 5)
                default:
                    return true
                }
            } else {
                return true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return }
        if sectionArray[index.section] == .ExpirationDate {
            if let cell = tableViewOutlet.cellForRow(at: index) as? CCVTableCell, cell.expirationTextField == textField {
                setPrefilledComponents()
                textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButton))
            }
        }
    }
}


extension AddPaymentDetailsBuilderVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return monthYearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthYearArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monthYearArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let textField = self.view.viewWithTag(1) as? UITextField {
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButton))
            textField.backgroundColor = .red
            tableViewOutlet.reloadData()
        }
        setupExpirationPickerView()
        pickerView.selectRow(pickerView.selectedRow(inComponent: 0), inComponent: 0, animated: true)
        
        
        
    }
    
    
}


extension AddPaymentDetailsBuilderVC {
    
    private func validate() -> Bool {
        
        if model.cardNumber.isEmpty, screenType != .editDetails {
            CommonFunctions.showToastWithMessage("Please enter the card number")
            return false
        }
        
        if model.cardNumber.count < 16, screenType != .editDetails {
            CommonFunctions.showToastWithMessage("Please enter complete card number")
            return false
        }
        
        if model.holderName.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter cardholder name")
            return false
        }
        
        if model.expirationDate.isEmpty {
            CommonFunctions.showToastWithMessage("Please select the expiration date")
            return false
        }
        
        if model.cvv.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter the CVV")
            return false
        }
        
        if model.cvv.count < 3 {
            CommonFunctions.showToastWithMessage("Please enter a valid CVV")
            return false
        }
        
        return true
    }
}

extension AddPaymentDetailsBuilderVC: AddPaymentDetailsBuilderVMDelegate {
    
    func successAddedCard(model: CardAddedResultModel) {
        delegate?.getNewlyAddedCard(model: CardListResultModel(model))
        pop()
    }
    
    func successEditCard(model: CardAddedResultModel) {
        delegate?.getNewlyAddedCard(model: CardListResultModel(model))
        pop()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
