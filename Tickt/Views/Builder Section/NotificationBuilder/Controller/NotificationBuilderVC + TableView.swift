//
//  NotificationBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 18/07/21.
//

import Foundation

extension NotificationBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model?.result.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: NotificationTableCell.self)
        cell.tableView = tableView
        viewModel.hitPagination(index: indexPath.row)
        cell.topConstraint.constant = indexPath.row == 0 ? 20 : 40
        cell.model = viewModel.model?.result.list[indexPath.row]
        cell.buttonClosure = { [weak self] index in
            guard let _ = self else { return }
            CommonFunctions.showToastWithMessage("Under development")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel.model?.result.list[indexPath.row],
           let typeValue = model.notificationType,
           let type = PushNotificationTypes(rawValue: typeValue) {
            redirectionNotification(type: type, model: model)
            viewModel.readSingleNotification(notificationId: model.id ?? "", indexPath: indexPath)
        }
    }
}
