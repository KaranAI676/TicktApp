//
//  NotificationBuilderVC + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 18/07/21.
//

import Foundation

extension NotificationBuilderVC: NotificationBuilderVMDelegate {
    func markSingleNotificationRead(indexPath: IndexPath) {
        viewModel.model?.result.list[indexPath.row].read = 1
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadRows(at: [indexPath], with: .automatic)
        }
        refreshNotificationCount?(1)
    }
    
    func markAllRead() {
        for index in 0..<(viewModel.model?.result.list.count ?? 0) {            
            viewModel.model?.result.list[index].read = 1
        }
        tableViewOutlet.reloadData()
        refreshNotificationCount?(nil)
    }
    
    func success() {
        tableViewOutlet.reloadData()
        refresher.endRefreshing()
        viewModel.model?.result.list.count ?? 0 == 0 ? showWaterMarkLabel(message: "No notification found") : hideWaterMarkLabel()
    }
    
    func failure(message: String) {
        refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(message)
    }
}
