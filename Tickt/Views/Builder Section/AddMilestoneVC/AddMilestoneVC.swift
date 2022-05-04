//
//  AddMilestoneVC.swift
//  Tickt
//
//  Created by S H U B H A M on 22/03/21.
//

import UIKit

protocol AddMilestoneDelegate: AnyObject {
    
    func getMilestone(milestone: MilestoneModel)
    func getUpdatedMilestone(milestone: MilestoneModel, index: Int)
}

class AddMilestoneVC: BaseVC {
    
    enum CellTypes {
        case milestoneName
        case photoEvidence
        case milestoneDuration
        case recommendedHours
    }
    
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var addMilestone: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
    //MARK:- Variables
    var jobName = ""
    weak var delegate: AddMilestoneDelegate? = nil
    var milestoneCount: Int = 1
    var isComingFromChangeRequest: Bool = false
    var screenType: ScreenType = .addMilestone
    var index: Int = 0
    private var arrayOfCellTypes: [CellTypes] = [.milestoneName, .photoEvidence, .milestoneDuration, .recommendedHours]
    var model = MilestoneModel()
    var recommendedHours: Int?
    var recommendedMinutes: Int?
    let datePicker = UIPickerView()
    var pickerDaysYear = [
            ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"],
        ["0","15","30","45"]]
    
    
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
            self.pop()
        case addMilestone:
            if validateMilestone() {
                self.delegate?.getMilestone(milestone: model)
                self.addAnotherMilestoneSetup()
            }
        case continueButton:
            if validateMilestone() {
                self.screenType == .addMilestone ? self.delegate?.getMilestone(milestone: model) : self.delegate?.getUpdatedMilestone(milestone: model, index: index)
                self.pop()
            }
        default:
            break
        }
        disableButton(sender)
    }
}

extension AddMilestoneVC {
    
    private func initialSetup() {
        setupTableView()
        setupUI()
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        setupTimePicker()
    }
    
    private func setupUI() {
        setupDefaultText()
        if isComingFromChangeRequest {
            navTitleLabel.isHidden = false
            navTitleLabel.text = jobName
            let title = screenType == .edit ? "Save changes" : "Continue"
            self.addMilestone.isHidden = true
            continueButton.setTitleForAllMode(title: title)
        }else {
            self.addMilestone.isHidden = self.screenType == .edit
        }
    }
    
    private func addAnotherMilestoneSetup() {
        self.model = MilestoneModel()
        self.milestoneCount += 1
        setupDefaultText()
        self.tableViewOutlet.reloadData()
    }
    
    private func setupTableView() {
        ///
        tableViewOutlet.isHidden = false
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        ///
        tableViewOutlet.registerCell(with: CommonTextFieldsTableCell.self)
        tableViewOutlet.registerCell(with: ChooseButtonWithLeftTitleTableCell.self)
        tableViewOutlet.registerCell(with: CommonRatioButtonWithTileTableCell.self)
        
        collectionViewOutlet.isHidden = true
    }
    
    private func goToAddMilestoneVC() {
        let vc = AddMilestoneVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.milestoneCount = self.milestoneCount + 1
        self.push(vc: vc)
    }
    
    private func goToCalendarVC(index: IndexPath) {
        let vc = CalendarVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.delegate = self
        vc.startDateToDisplay = self.model.fromDate.date
        vc.endDateToDisplay = self.model.toDate.date
        vc.screenType = .addMilestone
        self.push(vc: vc)
    }
    
    private func setupDefaultText() {
        switch screenType {
        case .addMilestone:
            self.screenTitleLabel.text = "Milestone \(self.milestoneCount)"
        case .edit:
            self.screenTitleLabel.text = isComingFromChangeRequest ? "Milestone \(self.index+1)" : "Edit the milestone \(self.index+1)"
             
        default:
            break
        }        
    }
    
    private func setupTimePicker() {
        if pickerDaysYear[0].count < (self.recommendedHours ?? 0) {
            var array = [String]()
            for i in pickerDaysYear[0].count..<pickerDaysYear[0].count + (self.recommendedHours ?? 0) {
                array.append("\(i+1)")
            }
            self.pickerDaysYear[0].append(contentsOf: array)
            self.datePicker.reloadAllComponents()
        }
        
        if var hours = self.recommendedHours, var minutes = self.recommendedMinutes {
            hours = self.recommendedHours == 0 ? self.recommendedHours! : self.recommendedHours!
            minutes = self.recommendedMinutes == 0 ? self.recommendedMinutes! : self.recommendedMinutes!
            self.datePicker.selectRow(hours, inComponent: 0, animated: false)
            self.datePicker.selectRow((minutes/5), inComponent: 1, animated: false)
        }else {
            self.datePicker.selectRow(0, inComponent: 0, animated: false)
            self.datePicker.selectRow(0, inComponent: 1, animated: false)
        }
    }
    
    @objc private func doneButton() {
        self.recommendedHours = Int(pickerDaysYear[0][datePicker.selectedRow(inComponent: 0)]) ?? 0
        self.recommendedMinutes = Int(pickerDaysYear[1][datePicker.selectedRow(inComponent: 1)]) ?? 0
        self.model.recommendedHours = String(format:"%02i:%02i", self.recommendedHours ?? 0, self.recommendedMinutes ?? 0)
        self.tableViewOutlet.reloadData()
    }
}

extension AddMilestoneVC: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: TableViewCollectionViewCell.self, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

//MARK:- TableView Delegates
extension AddMilestoneVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrayOfCellTypes[indexPath.row] {
        case .milestoneName:
            let cell = tableView.dequeueCell(with: CommonTextFieldsTableCell.self)
            cell.tableView = tableView
            cell.populateUI(titleName: "Milestone Name", placeHolder: "Milestone Name")
           // cell.textFieldTextField.autocapitalizationType = .words
            cell.textFieldTextField.text = self.model.milestoneName
            cell.textFieldTextField.keyboardType = .default
            cell.textFieldTextField.delegate = self
            cell.textFieldTextField.addTarget(self, action: #selector(textFieldDidChange(_:)) , for: .editingChanged)
            return cell
        case .photoEvidence:
            let cell = tableView.dequeueCell(with: CommonRatioButtonWithTileTableCell.self)
            cell.tableView = tableView
            cell.checkButton.isSelected = self.model.isPhotoevidence
            ///
            cell.selectionButtonClosure = { [weak self] (index) in
                guard let self = self else { return }
                self.model.isPhotoevidence = !self.model.isPhotoevidence
                self.tableViewOutlet.reloadData()
            }
            return cell
        case .milestoneDuration:
            let cell = tableView.dequeueCell(with: ChooseButtonWithLeftTitleTableCell.self)
            cell.tableView = tableView
            cell.timeLabel.text = self.model.displayDateFormat.isEmpty ? "Choose" : self.model.displayDateFormat
            cell.chooseButtonClosure = { [weak self] (index) in
                guard let self = self else { return }
                self.goToCalendarVC(index: index)
            }
            return cell
        case .recommendedHours:
            let cell = tableView.dequeueCell(with: CommonTextFieldsTableCell.self)
            cell.tableView = tableView
            cell.populateUI(titleName: "Estimated Hours(Optional)", placeHolder: "Estimated Hours")
            cell.textFieldTextField.text = self.model.recommendedHours
            cell.textFieldTextField.inputView = datePicker
            cell.textFieldTextField.delegate = self
            cell.textFieldTextField.addTarget(self, action: #selector(textFieldDidChange(_:)) , for: .editingChanged)
            return cell
        }
    }
}

extension AddMilestoneVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return true }
        switch self.arrayOfCellTypes[index.row] {
        case .milestoneName:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumericPunctuation, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 50)
        case .recommendedHours:
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.empty, textField: textField.text ?? "", string: string, range: range)
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return }
        if arrayOfCellTypes[index.row] == .recommendedHours {
            setupTimePicker()
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButton))
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return }
        
        switch self.arrayOfCellTypes[index.row] {
        case .milestoneName:
            self.model.milestoneName = text.byRemovingLeadingTrailingWhiteSpaces
        case .recommendedHours:
            self.model.recommendedHours = text.byRemovingLeadingTrailingWhiteSpaces
        default:
            break
        }
    }
}

//MARK:- Validation
extension AddMilestoneVC {
    
    private func validateMilestone() -> Bool {
        
        if self.model.milestoneName.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter the milestone name")
            return false
        }
        
//        if self.model.fromDate.backendFormat.isEmpty {
//            CommonFunctions.showToastWithMessage("Please select the milestone duration")
//            return false
//        }
        
//        if self.model.recommendedHours.isEmpty {
//            CommonFunctions.showToastWithMessage(Validation.errorEmptyHour)
//            return false
//        }
        
        if self.model.recommendedHours == "00:00" {
            CommonFunctions.showToastWithMessage(Validation.errorInvalidHour)
            return false
        }
        
        return true
    }
}

extension AddMilestoneVC: CalendarDelegate {
    
    func getSelectedDates(dates: [Date]) {
        
        func getToDate() -> Date? {
            if let toDate = dates.last, dates.count > 1 {
                self.model.toDate.backendFormat = toDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
                self.model.toDate.date = toDate.removeTimeStamp()
                return toDate
            }else {
                self.model.toDate.date = nil
                self.model.toDate.backendFormat = ""
                return nil
            }
        }
        
        if let fromDate = dates.first {
            self.model.fromDate.backendFormat = fromDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
            self.model.fromDate.date = fromDate.removeTimeStamp()
            self.model.displayDateFormat = CommonFunctions.getFormattedDates(fromDate: fromDate, toDate: getToDate())
            self.tableViewOutlet.reloadData()
        }else {
            self.model.fromDate = MilestoneDates()
            self.model.toDate = MilestoneDates()
            self.model.displayDateFormat = CommonStrings.emptyString
            self.tableViewOutlet.reloadData()
        }
    }
}


extension AddMilestoneVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerDaysYear.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDaysYear[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 && (pickerDaysYear[0].count - 1 == row) {
            var array = [String]()
            for i in (pickerDaysYear[0].count - 1)..<(pickerDaysYear[0].count - 1) + 10 {
                array.append("\(i+1)")
            }
            self.pickerDaysYear[0].append(contentsOf: array)
            self.datePicker.reloadAllComponents()
        }
        return pickerDaysYear[component][row]
    }
}
