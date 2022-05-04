//
//  MilestoneLisitng+Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 15/06/21.
//

import Foundation

extension MilestoneListingVC {
    
    func initialSetup() {
        setupTableView()
        setupGesture()
        setupScreen()
        viewModel.delegate = self
        if !milestonesArray.isEmpty {
            kAppDelegate.datesDict = [:]
            manageDotColor()
        }
    }
    
    private func setupScreen() {
        if screenType == .edit || screenType == .creatingJob {
            saveTemplateButton.isHidden = true
            milestonesArray = kAppDelegate.postJobModel?.milestones ?? []
            tableViewOutlet.reloadData()
        } else if screenType == .milestoneChangeRequest {
            saveTemplateButton.isHidden = true
            saveTemplateButton.setTitleForAllMode(title: "Done")
            descriptionLabel.isHidden = false
            navTitle.isHidden = false
            continueButton.setTitleForAllMode(title: "Send to tradie")
            screenTitleLabel.text = "Change request"
            descriptionLabel.text = "You can  add/remove/change a milestones here. The changes will be sent to the Tradie to accept before being implemented"
            navTitle.text = jobName
        } else if screenType == .republishJob || screenType == .editQuoteJob {
            saveTemplateButton.isHidden = true
            milestonesArray = kAppDelegate.postJobModel?.milestones ?? []
            tableViewOutlet.reloadData()
        } else if screenType == .editTemplates {
            saveTemplateButton.isHidden = true
            useTemplate.isHidden = true
            continueButton.setTitleForAllMode(title: "Save")
        }
    }
    
    private func setupGesture() {
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        tableViewOutlet.addGestureRecognizer(longpress)
    }
    
    private func setupTableView() {
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        ///
        self.tableViewOutlet.registerCell(with: MilestoneTableCell.self)
    }
    
    private func setBUttonTitle(title: String) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else { return }
            self.saveTemplateButton.setTitle(title, for: .normal)
            self.saveTemplateButton.setTitle(title, for: .selected)
        })
    }
    
    func setPlaceholder() {
        self.placeHolderView.isHidden = (milestonesArray.count > 0)
        if screenType != .milestoneChangeRequest, screenType != .editTemplates {
            self.saveTemplateButton.isHidden = !(self.placeHolderView.isHidden)
        }
    }
    
    func goToSuccessVC(_ screenType: ScreenType) {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = screenType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAddMilestoneVC(forEdit: Bool = false, index: Int? = nil) {
        let vc = AddMilestoneVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.isComingFromChangeRequest = screenType == .milestoneChangeRequest
        vc.jobName = jobName
        vc.delegate = self
        vc.milestoneCount = self.milestonesArray.count + 1
        if let index = index, forEdit {
            vc.model = self.milestonesArray[index]
            let recommentedArray = self.milestonesArray[index].recommendedHours.split(separator: ":")
            switch recommentedArray.count {
            case 2:
                vc.recommendedHours = Int(recommentedArray[0])
                vc.recommendedMinutes = Int(recommentedArray[1])
            case 1:
                vc.recommendedHours = Int(recommentedArray[0])
                vc.recommendedMinutes = 0
            default:
                break
            }
            vc.index = index
            vc.screenType = .edit
        }
        self.push(vc: vc)
    }
    
    private func goToSaveTemplateVC() {
        let vc = SaveTemplateVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.milestoneArray = self.milestonesArray
        self.push(vc: vc)
    }
    
    private func goToUploadMediaVC() {
        let vc = CreateJobUploadMediaVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = screenType
        self.push(vc: vc)
    }
    
    func goToTemplateListVC() {
        let vc = TemplatesListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.delegate = self
        vc.screenType = .creatingJob
        self.push(vc: vc)
    }
    
    func handledTheButtonVisibility() {
        switch screenType {
        case .milestoneChangeRequest:
            self.useTemplate.isHidden = true
            if constantMilestoneArray == milestonesArray || milestonesArray.isEmpty {
                continueButton.isHidden = true
                useTemplate.isHidden = screenType == .milestoneChangeRequest ? true : false
                addMilestone.backgroundColor = AppColors.themeYellow
            } else {
                continueButton.isHidden = false
                useTemplate.isHidden = true
                addMilestone.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            }
        case .editTemplates:
            continueButton.isHidden = milestonesArray.isEmpty || milestonesArray == constantMilestoneArray
            addMilestone.backgroundColor = continueButton.isHidden ? AppColors.themeYellow : #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        default:
            if milestonesArray.isEmpty {
                self.continueButton.isHidden = true
                self.useTemplate.isHidden = screenType == .milestoneChangeRequest ? true : false
                self.addMilestone.backgroundColor = AppColors.themeYellow
            } else {
                self.continueButton.isHidden = false
                self.useTemplate.isHidden = true
                self.addMilestone.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            }
        }
    }
    
    func deleteMilestone(indexPath: IndexPath, tableView: UITableView, completion: @escaping (Bool)-> Void) {
        
        AppRouter.showAppAlertWithCompletion(vc: self, alertMessage: "Are you sure, want to delete the milestone?", acceptButtonTitle: "Delete", declineButtonTitle: "Cancel", completion: {
            if self.screenType == .milestoneChangeRequest, (self.tempMilestoneArray.count - 1) >= indexPath.row {
                let deletedModel = self.tempMilestoneArray.remove(at: indexPath.row)
                if let _ = self.constantMilestoneArray.firstIndex(where: { eachModel -> Bool in
                    return eachModel.milestoneId == deletedModel.milestoneId
                }) {
                    self.deletedMilestone.append(deletedModel)
                }
            }
            ///
            self.milestonesArray.remove(at: indexPath.row)
            if indexPath.row < self.milestoneColorsArray.count {
                self.milestoneColorsArray.remove(at: indexPath.row)
            }
            self.manageDotColor()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }, dismissCompletion: {
            completion(false)
        })
    }
    
    private func setMilestoneOrderValue() {
        for i in 0..<milestonesArray.count {
            milestonesArray[i].order = i+1
        }
    }
    
    func isMilestonesRearranged() -> Bool {
        let array = tempMilestoneArray.compactMap({  eachModel -> MilestoneModel? in
            return eachModel.status.isNil ? nil : eachModel
        })
        
        for i in 0..<array.count {
            if i <= milestonesArray.count {
                if !(array[i].order == milestonesArray[i].order) {
                    return true
                }
            }
        }
        return false
    }
}


//MARK:- ButtonActions
//====================
extension MilestoneListingVC {
    
    func backButtonAction() {
        var message = "If you go back, you will lose your newly created milestones."
        kAppDelegate.datesDict = [:]
        if screenType == .edit || screenType == .creatingJob {
            self.pop()
            return
        }
        if milestonesArray.isEmpty {
            kAppDelegate.postJobModel?.milestones.removeAll()
            self.pop()
            return
        }
        
        if screenType == .milestoneChangeRequest || screenType == .republishJob || screenType == .editQuoteJob {
            self.pop()
            return
        }
        
        if screenType == .editTemplates, constantMilestoneArray == milestonesArray {
            pop()
            return
        } else {
            message = "If you go back, you will lose all your changes."
        }
        
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                             alertTitle: "Heads Up",
                                             alertMessage: message,
                                             acceptButtonTitle: "Ok",
                                             declineButtonTitle: "Cancel") {
            kAppDelegate.postJobModel?.milestones.removeAll()
            self.pop()
        } dismissCompletion: {
            
        }
    }
    
    func saveTemplateButtonAction() {
        if self.tableViewOutlet.isEditing {
           self.tableViewOutlet.isEditing = false
            screenType == .milestoneChangeRequest ? (saveTemplateButton.isHidden = true) : self.setBUttonTitle(title: "Save as template")
            tableViewOutlet.reloadData()
        } else {
            if validate() {
                goToSaveTemplateVC()
            }
        }
    }
    
    func continueButtonAction() {
        switch screenType {
        case .milestoneChangeRequest:
            if validate() {
                AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                                     alertTitle: "Alert",
                                                     alertMessage: "Are you sure you want to change request?",
                                                     acceptButtonTitle: "Ok",
                                                     declineButtonTitle: "Cancel") {
                    self.viewModel.editMilestone(jobId: self.jobId,
                                                 tradieId: self.tradieId,
                                                 model: self.milestonesArray,
                                                 deletedModel: self.deletedMilestone,
                                                 isRearranged: self.isRearranged,
                                                 addedNewMilestone: self.milestonesArray.count > self.constantMilestoneArray.count)
                } dismissCompletion: {
                    
                }                
            }
        case .editTemplates:
            viewModel.editTemplates(templateId: templateId, templateName: templateName, model: milestonesArray)
        default:
            if validate() {
                if screenType == .edit {
                    self.pop()
                    return
                }
                self.goToUploadMediaVC()
            }
        }
    }
}

//MARK:- Selector Methods
extension MilestoneListingVC {
    
    @objc private func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        tableViewOutlet.isEditing = true
        if screenType == .milestoneChangeRequest || screenType == .editTemplates {
            saveTemplateButton.isHidden = false
        }
        setBUttonTitle(title: "Done")
    }
}

//MARK:- Validate
extension MilestoneListingVC {
    
    private func validate() -> Bool {
        if self.milestonesArray.isEmpty, screenType != .milestoneChangeRequest {
            CommonFunctions.showToastWithMessage("Please add at least one milestone")
            return false
        }
        
        /// Date Validations
        if self.milestonesArray.count > 1 {
            for i in 0..<(self.milestonesArray.count) {
                var boolValue: Bool = true
                /// Sorting
                if i < (self.milestonesArray.count - 1) {
                    boolValue = self.milestonesArray[i].fromDate.date ?? Date() <= self.milestonesArray[i+1].fromDate.date ?? Date()
                    if !boolValue {
                        let msg = self.milestonesArray[i].fromDate.date ?? Date() == self.milestonesArray[i+1].fromDate.date ?? Date() ? "Milestones start date should be different from others" : "Please arrange milestones date wise"
                        CommonFunctions.showToastWithMessage(msg)
                        return false
                    }
                }
                ///
                if !checkDateValidation(i: i) {
                    return false
                }
            }
        } else {
            if self.milestonesArray.count > 0 {
                if !checkDateValidation(i: 0) {
                    return false
                }
            }
        }
        
        if screenType != .milestoneChangeRequest {
            setMilestoneOrderValue()
            kAppDelegate.postJobModel?.milestones = self.milestonesArray
        }
        return true
    }
        
    private func checkDateValidation(i: Int) -> Bool {
        if let milestoneFromDate = self.milestonesArray[i].fromDate.date, let jobFromDate = kAppDelegate.postJobModel?.fromDate.date {
            if milestoneFromDate.isLessThan(jobFromDate) {
                CommonFunctions.showToastWithMessage("Milestone dates should lie between job duration")
                return false
            }
        }
        
//        if let milestoneToDate = self.milestonesArray[i].toDate.date, let jobToDate = kAppDelegate.postJobModel?.toDate.date {
//            if milestoneToDate.isGreaterThan(jobToDate) {
//                CommonFunctions.showToastWithMessage("Milestone dates should lie between job duration")
//                return false
//            }
//        }
        return true
    }
}

//        self.showAlert(title: "Alert", msg: "Are you sure, want to delete the milestone?", cancelTitle: "Cancel", actionTitle: "Delete", actioncompletion: {
//            ///
//            if self.screenType == .milestoneChangeRequest, (self.tempMilestoneArray.count - 1) >= indexPath.row {
//                let deletedModel = self.tempMilestoneArray.remove(at: indexPath.row)
//                if let _ = self.constantMilestoneArray.firstIndex(where: { eachModel -> Bool in
//                    return eachModel.milestoneId == deletedModel.milestoneId
//                }) {
//                    self.deletedMilestone.append(deletedModel)
//                }
//            }
//            ///
//            self.milestonesArray.remove(at: indexPath.row)
//            if indexPath.row < self.milestoneColorsArray.count {
//                self.milestoneColorsArray.remove(at: indexPath.row)
//            }
//            self.manageDotColor()
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            completion(true)
//        }, cancelcompletion: {
//            completion(false)
//        })
