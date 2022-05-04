//
//  RevenueList+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 13/07/21.
//

import Foundation

extension RevenueListVC: TableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailModel?.result.milestones.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: RevenueMilestoneCell.self)
        let milestone = detailModel?.result.milestones[indexPath.row]
        cell.milestone = milestone
        updateDashLine(status: milestone?.status ?? "", cell: cell, indexPath: indexPath)
        return cell
    }
    
    func updateDashLine(status: String, cell: RevenueMilestoneCell, indexPath: IndexPath) {
        if let jobStatus = JobStatus(rawValue: status) {
            switch jobStatus {
            case .paymentApproved:
                if indexPath.row < completedMilestone {
                    cell.setFontColor(status: true)
                    cell.setDashView(color: AppColors.themeBlue, isShow: true)
                } else {
                    cell.setFontColor(status: false)
                    if indexPath.row == (detailModel?.result.milestones.count ?? 0) - 1 {
                        cell.setDashView(color: AppColors.appGrey, isShow: false)
                    } else {
                        cell.setDashView(color: AppColors.appGrey, isShow: true)
                    }
                }
            default:
                cell.setFontColor(status: false)
                if indexPath.row == (detailModel?.result.milestones.count ?? 0) - 1 {
                    cell.setDashView(color: AppColors.appGrey, isShow: false)
                } else {
                    cell.setDashView(color: AppColors.appGrey, isShow: true)
                }
            }
            cell.layoutIfNeeded()
        }
    }
}
