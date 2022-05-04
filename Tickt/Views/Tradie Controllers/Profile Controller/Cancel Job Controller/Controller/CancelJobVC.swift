//
//  CancelJobVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 28/05/21.
//

class CancelJobVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var reasonTableView: UITableView!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var continueButton: CustomBoldButton!
    
    var jobId: String = ""
    var jobName: String = ""
    var viewModel = CancelJobVM()
    var lodgeDisputeModel = LodgeDisputeModel()
    var reasonsModel: [ReasonsModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case continueButton:
            if validate() {
                var params: [String: Any] = [:]
                params = [ApiKeys.jobId: jobId]
                if !noteTextView.text!.isEmpty {
                    params[ApiKeys.note] = noteTextView.text!
                }
                if let type = lodgeDisputeModel.reasonType {
                    params[ApiKeys.reason] = type.rawValue
                }
                viewModel.cancelJobService(param: params)
            }
        default:
            break
        }
        disableButton(sender)
    }
    
    func initialSetup() {
        viewModel.delegate = self
        lodgeDisputeModel.jobId = self.jobId
        lodgeDisputeModel.jobName = self.jobName
        jobNameLabel.text = jobName
        reasonsModel = CommonFunctions.getReasonsModel()
        setupTableView()
    }
    
    func setupTableView() {
        reasonTableView.registerCell(with: ReasonsTableViewCell.self)
        reasonTableView.delegate = self
        reasonTableView.dataSource = self
    }
    
    func validate() -> Bool {
        guard let reasonModel = reasonsModel else { return false }
        let selectedReason = reasonModel.first(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        lodgeDisputeModel.reasonType = selectedReason?.reasonType
        if lodgeDisputeModel.reasonType == nil {
            CommonFunctions.showToastWithMessage("Please select a reason")
            return false
        }
        return true
    }
}
