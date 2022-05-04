//
//  RevenueList+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation

extension RevenueListVC: RevenueListDelegate {
    
    func failure(message: String) {
        
    }
    
    func success(model: RevenueDetailModel) {
        if isActiveJob {
            activeImageView.sd_setImage(with: URL(string: model.result.builderImage), placeholderImage: nil)
            activeAmoutLabel.text = model.result.totalEarning
            activeJobNameLabel.text = model.result.jobName
        } else {
            completedImageView.sd_setImage(with: URL(string: model.result.builderImage), placeholderImage: nil)
            completeAmountLabel.text = model.result.totalEarning
            completeJobLabel.text = model.result.jobName
            jobDateLabel.text = CommonFunctions.getFormattedDates(fromDate: model.result.fromDate.convertToDateAllowsNil(), toDate: model.result.toDate?.convertToDateAllowsNil())
        }
        
        detailModel = model
        if let firstIndex = model.result.milestones.firstIndex(where: {$0.status == JobStatus.paymentPending.rawValue}) {
            completedMilestone = firstIndex - 1
        } else {
            completedMilestone = model.result.milestones.count - 1
        }
        milestoneTableView.reloadData()
    }    
}
