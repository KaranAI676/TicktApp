//
//  HourVC.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//

class HourVC: BaseVC {
  
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: CustomBoldButton!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var hourField: CustomRomanField!
    
    var formattedHour = ""
    var recommendedHours: Int?
    var recommendedMinutes: Int?
    let pickerView = UIPickerView()
    var pickerValues = [(0..<24).indices.map {"\($0)"}, (0..<11).indices.map {"\($0*5)"}]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        setupTimePicker()
        hourField.inputView = pickerView
        hourField.applyLeftPadding(padding: 10)
        jobNameLabel.text = MilestoneVC.milestoneData.jobName
    }
    
    func setupTimePicker() {
        if pickerValues[0].count < (recommendedHours ?? 0) {
            var array = [String]()
            for i in pickerValues[0].count..<pickerValues[0].count + (recommendedHours ?? 0) {
                array.append("\(i+1)")
            }
            pickerValues[0].append(contentsOf: array)
            pickerView.reloadAllComponents()
        }
        
        if var hours = recommendedHours, var minutes = recommendedMinutes {
            hours = recommendedHours == 0 ? recommendedHours! : recommendedHours!
            minutes = recommendedMinutes == 0 ? recommendedMinutes! : recommendedMinutes!
            pickerView.selectRow(hours, inComponent: 0, animated: false)
            pickerView.selectRow(minutes, inComponent: 1, animated: false)
        } else {
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView.selectRow(0, inComponent: 1, animated: false)
        }
    }
    
    @objc func doneButton() {
        recommendedHours = Int(pickerValues[0][pickerView.selectedRow(inComponent: 0)]) ?? 0
        recommendedMinutes = Int(pickerValues[1][pickerView.selectedRow(inComponent: 1)]) ?? 0
        formattedHour = String(format:"%02i:%02i", recommendedHours ?? 0, recommendedMinutes ?? 0)
        hourField.text = formattedHour
    }
        
    private func validate() -> Bool {

        if formattedHour.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyHour)
            return false
        }
        
        if formattedHour == "00:00" {
            CommonFunctions.showToastWithMessage(Validation.errorInvalidHour)
            return false
        }
        
        return true
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case sendButton:
            if validate() {
                MilestoneVC.milestoneData.actualHours = formattedHour
                if MilestoneVC.milestoneData.payType == PayType.perHour.rawValue {
                    let totalHour = Double.getDouble((recommendedHours ?? 0) * 60 + (recommendedMinutes ?? 0)) / 60.0
                    MilestoneVC.milestoneData.totalAmount = MilestoneVC.milestoneData.amount * Double.getDouble(totalHour)
                } else {
                    MilestoneVC.milestoneData.totalAmount = MilestoneVC.milestoneData.amount
                }
                let addPaymentVC = AddPaymentVC.instantiate(fromAppStoryboard: .jobDashboard)
                push(vc: addPaymentVC)
            }
        default:
            break
        }
        disableButton(sender)
    }
}
