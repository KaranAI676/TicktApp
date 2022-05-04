//
//  MilestoneListing+Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 15/06/21.
//

import Foundation

//MARK:- AddMilestone: Delegate
//=============================
extension MilestoneListingVC: AddMilestoneDelegate {
    
    func getMilestone(milestone: MilestoneModel) {
        if screenType == .milestoneChangeRequest {
            tempMilestoneArray.append(milestone)
        }
        milestonesArray.append(milestone)
        manageDotColor()
        tableViewOutlet.reloadData()
    }
    
    func getUpdatedMilestone(milestone: MilestoneModel, index: Int) {
        milestonesArray[index] = milestone
        manageDotColor()
        if screenType == .milestoneChangeRequest {
            milestonesArray[index].isEdit = tempMilestoneArray[index] != milestone
        }
        tableViewOutlet.reloadData()
    }
}


//MARK:- TemplatesListingVC: Delegate
//===================================
extension MilestoneListingVC: TemplatesListingVCDelegate {
    func getMilestones(milestonesArray: [MilestonesModel]) {
        let array: [MilestoneModel] = milestonesArray.map({ eachModel in
            MilestoneModel(eachModel)
        })
        self.milestonesArray = array
        self.tableViewOutlet.reloadData()
    }
}


//MARK:- MilestoneListingVM: Delegate
//===================================
extension MilestoneListingVC: MilestoneListingVMDelegate {
    
    func successEditTemplate() {
        goToSuccessVC(.saveTemplate)
        delegate?.updatedTemplates(milestoneCount: milestonesArray.count)
    }
    
    func successEditMilestone() {
        goToSuccessVC(.milestoneChangeRequest)
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
