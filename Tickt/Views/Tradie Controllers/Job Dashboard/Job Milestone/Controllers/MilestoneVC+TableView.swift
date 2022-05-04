//
//  MilestoneVC+TableView.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//

extension MilestoneVC: TableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if milestoneModel.isNotNil {
            return (milestoneModel?.result.milestones?.count ?? 0)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(with: JobMilestoneCell.self)
        let milestone = milestoneModel?.result.milestones?[indexPath.row]
        let status = milestone?.status ?? 0
        cell.milestone = milestone
        updateDashLine(status: status, cell: cell, indexPath: indexPath)
        cell.selectMilestoneAction = { [weak self] in
            self?.checkMilestoneStatus(indexPath: indexPath)
        }
        cell.completeButtonAction = { [weak self] in
            self?.checkCompleteStatus(indexPath: indexPath)
        }
        cell.openImageAction = { [weak self] urlString in
            let previewVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
            previewVC.urlString = urlString
            self?.push(vc: previewVC)
        }
        return cell
    }
    
    //Type of Milestone i.e New or Declined
    func checkMilestoneStatus(indexPath: IndexPath) {
        if let status = milestoneModel?.result.milestones?[indexPath.row].status, let milestoneStatus = MilestoneStatus(rawValue: status) {
            let selectionStaus = milestoneModel?.result.milestones?[indexPath.row].isMilestoneSelected ?? false
            switch milestoneStatus { //First check if any declined milestone is pending
            case .notComplete: //New Milestone
                if let declinedMilestones = milestoneModel?.result.milestones?.filter( {$0.status == 3}), declinedMilestones.count == 0 {
                    if indexPath.row == completingMilestone {
                        updateCompleteCell(indexPath: indexPath, selectStatus: selectionStaus, status: status)
                    }
                }
            default: //Declined Milestone
                updateCompleteCell(indexPath: indexPath, selectStatus: selectionStaus, status: status)
            }
        }
    }
    
    func updateCompleteCell(indexPath: IndexPath, selectStatus: Bool, status: Int) {
        milestoneModel?.result.milestones?.indices.forEach {
            if milestoneModel?.result.milestones?[$0].status == 0 {
                milestoneModel?.result.milestones?[$0].isMilestoneSelected = false
            }
        }
        milestoneModel?.result.milestones?[indexPath.row].isMilestoneSelected = !selectStatus
        if let cell = milestoneTableView.cellForRow(at: indexPath) as? JobMilestoneCell {
            cell.milestone = self.milestoneModel?.result.milestones?[indexPath.row]
            updateDashLine(status: status, cell: cell, indexPath: indexPath)
            if status == 3 {
                milestoneTableView.reloadRows(at: [indexPath], with: .none)
            }
            cell.setNeedsLayout()
            cell.layoutSubviews()
            cell.layoutIfNeeded()
        }
    }
    
    //Update the Dotted Linex
    func updateDashLine(status: Int, cell: JobMilestoneCell, indexPath: IndexPath) {
        if let milestoneStatus = MilestoneStatus(rawValue: status) {
            switch milestoneStatus {
            case .notComplete, .changeRequestAccepted, .changeRequest:
                cell.completeContainerView.isHidden = true
                if indexPath.row < completingMilestone { //Completed Milestone
                    cell.setFontColor(status: true)
                    cell.setDashView1(isShow: false)
                    cell.setDashView(color: AppColors.themeBlue, isShow: true)
                } else if indexPath.row == completingMilestone { //Current Milestone
                    cell.setFontColor(status: false)
                    cell.setDashView1(isShow: false)
                    cell.setDashView(color: AppColors.themeBlue, isShow: false)
                    cell.completeContainerView.isHidden = false
                } else { //Future Milestone
                    cell.setFontColor(status: true)
                    cell.setDashView1(isShow: true)
                    cell.setDashView(color: AppColors.appGrey, isShow: true)
                }
            case .declined:
                cell.setFontColor(status: false)
                if indexPath.row == (milestoneModel?.result.milestones?.count ?? 0) - 1 { //Last Declined Milestone
                    cell.setDashView(color: AppColors.themeBlue, isShow: false)
                    cell.setDashView1(isShow: false)
                } else  {
                    let nextIndex = indexPath.row + 1
                    if nextIndex < (milestoneModel?.result.milestones?.count ?? 0) {
                        let nextMilestoneStatus = milestoneModel?.result.milestones![nextIndex].status ?? 0
                        if nextMilestoneStatus == 3 {
                            cell.setDashView(color: AppColors.themeBlue, isShow: false)
                            cell.setDashView1(isShow: true)
                        } else {
                            cell.setDashView(color: AppColors.themeBlue, isShow: false)
                            cell.setDashView1(isShow: false)
                        }
                    } else {
                        cell.setDashView(color: AppColors.themeBlue, isShow: false)
                        cell.setDashView1(isShow: false)
                    }
                }
                
            default:
                if indexPath.row == (milestoneModel?.result.milestones?.count ?? 0) - 1 { //Last Declined Milestone
                    cell.setFontColor(status: true)
                    cell.setDashView(color: AppColors.themeBlue, isShow: false)
                    cell.setDashView1(isShow: false)
                } else {
                    cell.setFontColor(status: true)
                    cell.setDashView(color: AppColors.themeBlue, isShow: true)
                    cell.setDashView1(isShow: false)
                }
                
            }
            cell.layoutIfNeeded()
        }
    }
    
    //Check if the milestone is allowed to completed or any previous milestone is pending
    func checkCompleteStatus(indexPath: IndexPath) {
        if let milestoneStatus = MilestoneStatus(rawValue: milestoneModel?.result.milestones?[indexPath.row].status ?? 0)  {
            switch milestoneStatus {
            case .notComplete, .changeRequestAccepted, .changeRequest:
                setMilestoneData(indexPath: indexPath)
            default:
                if let firstIndex = milestoneModel?.result.milestones?.firstIndex(where: {$0.status == 3}), indexPath.row == firstIndex {
                    setMilestoneData(indexPath: indexPath)
                }
            }
        }
    }
    
    func setMilestoneData(indexPath: IndexPath) {
        let declinedCount = milestoneModel?.result.milestones?[indexPath.row].declinedCount ?? 0
        if declinedCount < 5 {
            MilestoneVC.milestoneData.jobId = jobId
            MilestoneVC.milestoneData.jobName = milestoneModel?.result.jobName ?? ""
            MilestoneVC.milestoneData.payType = milestoneModel?.result.milestones?[indexPath.row].payType ?? ""
            MilestoneVC.milestoneData.milestoneId = milestoneModel?.result.milestones?[indexPath.row].milestoneId ?? ""
            MilestoneVC.milestoneData.amount = Double.getDouble(milestoneModel?.result.milestones?[indexPath.row].amount)
            if milestoneModel?.result.milestones?[indexPath.row].milestoneId ?? "" == lastMilestoneId {
                MilestoneVC.milestoneData.isLastMilestone = true
            }
            if milestoneModel?.result.milestones?[indexPath.row].isPhotoevidence ?? false {
                let photoVC = PhotoVC.instantiate(fromAppStoryboard: .jobDashboard)
                MilestoneVC.milestoneData.isPhotoEvidence = true
                push(vc: photoVC)
            } else {
                let hourVC = HourVC.instantiate(fromAppStoryboard: .jobDashboard)
                push(vc: hourVC)
            }
        } else {
            AppRouter.showAppAlertWithCompletion(vc: self, alertType: .singleButton, alertTitle: "Milestone", alertMessage: "You have exceeded maximum number of chances to submit the milestone", acceptButtonTitle: "Ok", declineButtonTitle: "Ok") { } dismissCompletion: { }
        }
    }
}
