//
//  MilestoneVC+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

import Foundation

extension MilestoneVC: MilestoneDelegate {
    
    func failure(error: String) {
        milestoneTableView.showEmptyScreen(error)
    }
    
    func didGetMilestone(model: JobMilestoneModel) {
        refreshControl.endRefreshing()
        milestoneModel = model
        
        let rating = model.result.postedBy.ratings == 0.0 ? 0 : (model.result.postedBy.ratings ?? 0)
        let review = model.result.postedBy.reviews ?? 0
        reviewLabel.text = "\(rating), \(review) reviews"
        jobNameLabel.text = model.result.jobName
        MilestoneVC.milestoneData.jobName = model.result.jobName
        nameLabel.text = model.result.postedBy.builderName
        builderImageView.sd_setImage(with: URL(string: model.result.postedBy.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        editButton.isHidden = false
        lastMilestoneId = model.result.milestones?.last?.milestoneId ?? ""
        MilestoneVC.milestoneData = MilestoneObject()
        //First check which is current Milestone.
        if let firstIndex = model.result.milestones?.firstIndex(where: {$0.status == 0 || $0.status == 5 || $0.status == 4}) { // Not Yet Started
            completingMilestone = firstIndex
        } else {
            completingMilestone = model.result.milestones?.count ?? 0
        }
        
        if let declinedMilestone = model.result.milestones?.filter( {$0.status == 3}), declinedMilestone.count > 0 {
            declinedMilestoneCount.text = "\(declinedMilestone.count) Milestones were declined"
            declineMilestoneHeightConstraint.constant = 60
            if declinedMilestone.count == 1 {
                if let firstIndex = model.result.milestones?.firstIndex(where: {$0.status == 3}) {
                    milestoneModel?.result.milestones?[firstIndex].isMilestoneSelected = true
                }
            }
        } else {
            declineMilestoneHeightConstraint.constant = 0
            declinedMilestoneCount.text = ""
        }
        
        //Pure workarround , Fix it later.
        mainQueue { [weak self] in
            self?.milestoneTableView.reloadData { [weak self] in
                self?.milestoneTableView.reloadData()
            }
        }
    }
}
