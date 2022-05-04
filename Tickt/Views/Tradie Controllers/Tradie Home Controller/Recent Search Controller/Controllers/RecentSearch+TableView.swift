//
//  RecentSearch+TableView.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit
import Foundation

extension RecentSearchVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearchEnabled {
            return CGFloat.leastNormalMagnitude
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearchEnabled {
            return nil
        }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.defaultReuseIdentifier) as? SearchHeaderView else {
            return UIView()
        }
        headerView.backView.backgroundColor = .white
        headerView.headerLabel.text = LS.recentSearches
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnabled {
            return searchModel?.result?.count ?? 0
        }
        return recentSearchModel?.result?.resultData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.defaultReuseIdentifier, for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        if isSearchEnabled {
            cell.searchData = searchModel?.result![indexPath.row]
        } else {
            cell.searchData = recentSearchModel?.result?.resultData![indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        if !isSearchEnabled {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
                guard let self = self else { return }
                self.viewModel.deleteRecentJobs(id: self.recentSearchModel?.result?.resultData![indexPath.row].recentSearchId ?? "", indexPath: indexPath)
                completionHandler(true)
            }
            deleteAction.image = #imageLiteral(resourceName: "delete")
            deleteAction.backgroundColor = .white
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetVC = BudgetVC.instantiate(fromAppStoryboard: .search)        
        if isSearchEnabled {
            budgetVC.category = searchModel?.result![indexPath.row]
            kAppDelegate.searchModel.tradeId = [searchModel?.result![indexPath.row].id ?? ""]
            kAppDelegate.searchModel.specializationId = [searchModel?.result![indexPath.row].specializationsId ?? ""]             
        } else {
            budgetVC.category = recentSearchModel?.result?.resultData![indexPath.row]
            kAppDelegate.searchModel.tradeId = [recentSearchModel?.result?.resultData![indexPath.row].id ?? ""]
            kAppDelegate.searchModel.specializationId = [recentSearchModel?.result?.resultData![indexPath.row].specializationsId ?? ""]
        }
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(budgetVC, animated: true)
        }
    }
}
