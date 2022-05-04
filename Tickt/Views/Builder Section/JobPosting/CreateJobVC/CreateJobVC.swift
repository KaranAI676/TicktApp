//
//  CreateJobVCViewController.swift
//  Tickt
//
//  Created by S H U B H A M on 22/03/21.
//

import UIKit
import TagCellLayout

class CreateJobVC: BaseVC {
    
    enum CellTypes {
        case jobName
        case categories
        case jobType
        case specialisation
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var arrayOfCells: [CellTypes] = [.jobName, .categories, .jobType, .specialisation]
    var tradeModel: TradeModel?
    var jobTypeModel = JobTypeModel()
    var viewModel = CreateJobVM()
    var screenType: ScreenType = .creatingJob
    private var jobName: String = ""
    ///
    var selectedIndexOfTrade: Int? = nil
    var model = JobTypeModel()
    var removeControllers = false
    
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
            if screenType == .edit {
                self.pop()
                return
            }
            kAppDelegate.postJobModel = nil
            self.dismiss(animated: true)
            self.pop()
        case continueButton:
            if validate() {
                if screenType == .edit {
                    self.pop()
                    return
                }
                goToLocationVC()
            }
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension CreateJobVC {
    
    private func initialSetup() {
        
        if removeControllers {
            if let _ = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                let controllers = navigationController?.viewControllers ?? []
                var removingController = controllers
                
                for vc in controllers {
                    if !(vc.isKind(of: TabBarController.self) || vc.isKind(of: CreateJobVC.self)) {
                        removingController.remove(object: vc)
                    }
                }
                navigationController?.viewControllers = removingController
            }
        }
        
        viewModel.delegate = self
        setupTableView()
        if screenType == .creatingJob {
            kAppDelegate.postJobModel = CreateJobModel()
            viewModel.getTradeList()
            viewModel.getJobTypeList()
        }else if screenType == .republishJob {
            screenTitleLabel.text = "Republish a job"
            viewModel.getTradeList()
            viewModel.getJobTypeList()
        } else if screenType == .editQuoteJob {
            screenTitleLabel.text = "Edit job"
            viewModel.getTradeList()
            viewModel.getJobTypeList()
        }else {
            self.jobName = kAppDelegate.postJobModel?.jobName ?? ""
            self.tradeModel = kAppDelegate.postJobModel?.allTradeModel
            self.jobTypeModel = kAppDelegate.postJobModel?.allJobType ?? JobTypeModel()
            let index = self.tradeModel?.result?.trade?.firstIndex(where: { eachModel -> Bool in
                return eachModel.isSelected == true
            })
            if let index = index {
                selectedIndexOfTrade = index
            }
            tableViewOutlet.reloadData()
        }
    }
    
    private func setupTableView() {
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        self.tableViewOutlet.registerCell(with: CommonTextFieldsTableCell.self)
        self.tableViewOutlet.registerCell(with: CommonCollectionViewWithTitleTableCell.self)
        self.tableViewOutlet.registerCell(with: DynamicHeightCollectionViewTableCell.self)
        self.tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
    }
    
    private func goToLocationVC() {
        let vc = LocationVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = screenType
        self.push(vc: vc)
    }
}

//MARK:- TableViewDelegate
//========================
extension CreateJobVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch arrayOfCells[section] {
        case .jobName:
            return 1
        case .categories:
            return 1
        case .jobType:
            return self.jobTypeModel.result.resultData.isEmpty ? 0 : 1
        case .specialisation:
            if let index = selectedIndexOfTrade {
                let model = self.tradeModel?.result?.trade?[index].specialisations
                if model?.count ?? 0 > 0 {
                    if self.tradeModel?.result?.trade?[index].specialisations?.first?.name != "All" {
                        var object = SpecializationModel()
                        let filterArray = self.tradeModel?.result?.trade?[index].specialisations?.filter({ (data) -> Bool in
                            return data.isSelected == true
                        })
                        if filterArray?.count == 0 {
                            object.isSelected = true
                        }
                        object.name = "All"
                        self.tradeModel?.result?.trade?[index].specialisations?.insert(object, at: 0)
                    }
                    return 1
                }else{
                    return  0
                }
            }else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.arrayOfCells[indexPath.section] {
        case .jobName:
            let cell = tableView.dequeueCell(with: CommonTextFieldsTableCell.self)
            cell.populateUI(titleName: "Job Name", placeHolder: "Job Name")
            cell.textFieldTextField.autocapitalizationType = .sentences
            cell.textFieldTextField.text = self.jobName
            cell.textFieldTextField.tag = 50
            cell.textFieldTextField.delegate = self
            cell.textFieldTextField.addTarget(self, action: #selector(textFieldDidChange(_:)) , for: .editingChanged)
            return cell
        case .categories:
            let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
            cell.populateUI(title: "Categories", dataArray: self.tradeModel?.result?.trade)
            ///
            cell.modelUpdateClosure = { [weak self] (bool, index) in
                guard let self = self else { return }
                self.selectedIndexOfTrade = bool ? index : nil
                for i in 0..<((self.tradeModel?.result?.trade?.count ?? 0)) {
                    self.tradeModel?.result?.trade?[i].isSelected = false
                }
                self.tradeModel?.result?.trade?[index].isSelected = bool
                tableView.reloadData()
            }
            return cell
        case .jobType:
            let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
            cell.collectionVIewHeightConst.constant = 70
            /// Populate UI
            cell.populateUI (title: "Job type", dataArray: self.jobTypeModel.result.resultData)
            ///
            cell.didSelectClosure = { [weak self] (_, jobTypeIndex, bool) in
                guard let self = self else { return }
                for i in 0..<self.jobTypeModel.result.resultData.count {
                    self.jobTypeModel.result.resultData[i].isSelected = false
                }
                self.jobTypeModel.result.resultData[jobTypeIndex.row].isSelected = bool
                tableView.reloadData()
            }
            return cell
        case .specialisation:
            let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
            
            /// Populate UI
            cell.extraCellSize = CGSize(width: 16, height: 32)
            cell.stackView.spacing = 15
            cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
            if let index = selectedIndexOfTrade, let model = self.tradeModel?.result?.trade?[index].specialisations {
                cell.populateUI(title: "Specialisation", dataArray: model, cellType: .specialisation)
            } else {
                self.selectedIndexOfTrade = nil
                cell.specialisationModel.removeAll()
                cell.collectionViewOutlet.reloadData()
            }
            cell.layoutIfNeeded()
            
            /// Update Model for selection and deselection
            cell.didSelectClosure = { [weak self] (_, specialisationIndex, bool) in
                guard let self = self else { return }
                if let tradeIndex = self.selectedIndexOfTrade {
                    if specialisationIndex.row == 0 && self.tradeModel?.result?.trade?[tradeIndex].specialisations?[specialisationIndex.row].name == "All"{
                        let count = self.tradeModel?.result?.trade?[tradeIndex].specialisations?.count ?? 0
                        for index in 0...(count-1) {
                            self.tradeModel?.result?.trade?[tradeIndex].specialisations?[index].isSelected = false
                        }
                        self.tradeModel?.result?.trade?[tradeIndex].specialisations?[specialisationIndex.row].isSelected = bool
                    }else{
                        if self.tradeModel?.result?.trade?[tradeIndex].specialisations?[0].name == "All"{
                            self.tradeModel?.result?.trade?[tradeIndex].specialisations?[0].isSelected = false
                        }
                        self.tradeModel?.result?.trade?[tradeIndex].specialisations?[specialisationIndex.row].isSelected = bool
                    }
                    
                    tableView.reloadData()
                }
            }
            return cell
        }
    }
}

//MARK:- UITexField: Delegate
extension CreateJobVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 50 {
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumericPunctuation, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 100)
        }else{
            return CommonFunctions.textValidation(allowedCharacters: CommonFunctions.alphaNumeric, textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 100)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.jobName = text.byRemovingLeadingTrailingWhiteSpaces
    }
}

//MARK:- TradeDelegate
//====================
extension CreateJobVC: CreateJobVMDelegate {
    
    func success(data: TradeModel) {
        tradeModel = data
        if screenType == .republishJob || screenType == .editQuoteJob {
            setPreSelectedTrade()
        }
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func success(data: JobTypeModel) {
        jobTypeModel = data
        if screenType == .republishJob || screenType == .editQuoteJob{
            setPreSelectedJobType()
        }
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func failure(error: String) {
        
    }
}

//MARK:- Set selected data for Republish job
extension CreateJobVC {
    
    private func setPreSelectedTrade() {
        self.jobName = kAppDelegate.postJobModel?.jobName ?? ""
        guard let preSelectedTradieId = kAppDelegate.postJobModel?.republishCategories?.categoryId else { return }
        let index = tradeModel?.result?.trade?.firstIndex(where: { eachModel in
            return eachModel.id == preSelectedTradieId
        })
        
        if let index = index {
            selectedIndexOfTrade = index
            tradeModel?.result?.trade?[index].isSelected = true
            let currentData = tradeModel?.result?.trade?[index].specialisations
            ///
            for i in 0..<(kAppDelegate.postJobModel?.specialisation?.count ?? 0) {
                if let idIndex = tradeModel?.result?.trade?[index].specialisations?.firstIndex(where: { eachModel -> Bool in
                    return eachModel.id == kAppDelegate.postJobModel?.specialisation?[i].id
                }) {
                    tradeModel?.result?.trade?[index].specialisations?[idIndex].isSelected = true
                }
            }
            let filterArray = tradeModel?.result?.trade?[index].specialisations?.filter({ (data) -> Bool in
                return data.isSelected == true
            })
            
            if tradeModel?.result?.trade?[index].specialisations?.count == filterArray?.count {
                tradeModel?.result?.trade?[index].specialisations = currentData
            }else{
                
            }
            tableViewOutlet.reloadData()
        }
    }
    
    private func setPreSelectedJobType() {
        let preSelectedJobTypeId = kAppDelegate.postJobModel?.jobType.map({ eachModel -> String in
            return eachModel.id
        })

        for i in 0..<(preSelectedJobTypeId?.count ?? 0) {
            if let index = jobTypeModel.result.resultData.firstIndex(where: { eachModel -> Bool in
                return eachModel.id == (preSelectedJobTypeId?[i] ?? "")
            }) {
                jobTypeModel.result.resultData[index].isSelected = true
            }
        }
        tableViewOutlet.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- Validation
extension CreateJobVC {
    
    private func validate() -> Bool {
        
        if let _ = kAppDelegate.postJobModel {
            
            /// Job Name
            if self.jobName.isEmpty {
                
                CommonFunctions.showToastWithMessage("Please enter job name")
                return false
            }else { //Arsh Love
                kAppDelegate.postJobModel?.jobName = self.jobName.byRemovingLeadingTrailingWhiteSpaces
            }
            
            /// Category
            if self.selectedIndexOfTrade == nil {
                CommonFunctions.showToastWithMessage("Please select the category")
                return false
            }else {
                kAppDelegate.postJobModel?.categories = self.tradeModel?.result?.trade?[selectedIndexOfTrade!]
            }
            
            /// Job Type
            let selectedJobType = self.jobTypeModel.result.resultData.filter({ eachModel in
                eachModel.isSelected == true
            })
            if selectedJobType.isEmpty {
                CommonFunctions.showToastWithMessage("Please select job type")
                return false
            }else {
                kAppDelegate.postJobModel?.jobType = selectedJobType
            }
            
            /// Specialisation
            if self.selectedIndexOfTrade == nil {
                CommonFunctions.showToastWithMessage("Please select the category")
                return false
            }else {
                if let model = self.tradeModel?.result?.trade?[selectedIndexOfTrade!].specialisations, model.count > 0 {
                    let selectedSpecialisation = model.filter({ eachModel in
                        eachModel.isSelected == true
                    })
                    if selectedSpecialisation.isEmpty {
                        //                        for i in 0..<(self.tradeModel?.result?.trade?[selectedIndexOfTrade!].specialisations?.count ?? 0) {
                        //                            self.tradeModel?.result?.trade?[selectedIndexOfTrade!].specialisations?[i].isSelected = true
                        //                        }
                        kAppDelegate.postJobModel?.specialisation = self.tradeModel?.result?.trade?[selectedIndexOfTrade!].specialisations
                        
                        self.tableViewOutlet.reloadData()
                        //                        CommonFunctions.showToastWithMessage("Please select atleast one specialisation")
                        //                        return false
                    }else if (selectedSpecialisation.count == 1 && selectedSpecialisation.first?.name == "All") {
                        
                        kAppDelegate.postJobModel?.specialisation = self.tradeModel?.result?.trade?[selectedIndexOfTrade!].specialisations
                        kAppDelegate.postJobModel?.specialisation?.remove(at: 0)
                        self.tableViewOutlet.reloadData()
                        
                    }else {
                        kAppDelegate.postJobModel?.specialisation = selectedSpecialisation
                    }
                }
            }
        }else {
            CommonFunctions.showToastWithMessage("Something went wrong, go back and try again!")
            return false
        }
        
        kAppDelegate.postJobModel?.allTradeModel = self.tradeModel
        kAppDelegate.postJobModel?.allJobType = self.jobTypeModel
        return true
    }
}

