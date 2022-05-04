//
//  SearchRevenue+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation

extension SearchRevenueVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfModel.isEmpty ? 1 : arrayOfModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfModel.isEmpty ? 1 : arrayOfModel[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrayOfModel.isEmpty {
            let cell = tableView.dequeueCell(with: NoDataFoundTableCell.self)
            return cell
        } else {
            let revenueData = arrayOfModel[indexPath.section].rows[indexPath.row]
            if let jobStatus = JobStatus(rawValue: revenueData.status?.uppercased() ?? ""), jobStatus == .active {
                let cell = tableView.dequeueCell(with: ActiveRevenueJobCell.self)
                cell.revenueModel = revenueData
                return cell
            } else {
                let cell = tableView.dequeueCell(with: PastRevenueJobCell.self)
                cell.revenueModel = revenueData
                return cell
            }
        }        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = arrayOfModel.isEmpty ? "" : arrayOfModel[section].section
        header.headerLabel.font = UIFont.systemFont(ofSize: 14)
        header.headerLabel.textColor = AppColors.themeGrey
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !arrayOfModel.isEmpty {
            let revenueList = RevenueListVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
            let revenueData = arrayOfModel[indexPath.section].rows[indexPath.row]
            revenueList.jobId = revenueData.jobId ?? ""
            if let jobStatus = JobStatus.init(rawValue: revenueData.status?.uppercased() ?? ""), jobStatus == .active {
                revenueList.isActiveJob = true
            } else {
                revenueList.isActiveJob = false
            }
            push(vc: revenueList)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfModel.isEmpty {
            return tableView.bounds.height
        }else {
            return UITableView.automaticDimension
        }
    }
}
