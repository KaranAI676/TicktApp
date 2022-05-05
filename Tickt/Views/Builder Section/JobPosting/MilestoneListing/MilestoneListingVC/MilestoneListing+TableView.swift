//
//  MilestoneListing+TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 15/06/21.
//

import Foundation

extension MilestoneListingVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setPlaceholder()
        handledTheButtonVisibility()
        return milestonesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: MilestoneTableCell.self)
        cell.tableView = tableView
        ///
        cell.setTheDottedLine()
        let model = self.milestonesArray[indexPath.row]
        cell.milestoneName.text = model.milestoneName
        cell.evidenceLabel.isHidden = !(model.isPhotoevidence)
        cell.editButton.isHidden = !cell.evidenceLabel.isHidden
        cell.selectionButton.isSelected = model.isSelected
        cell.editButton.isHidden = !cell.selectionButton.isSelected
        cell.timeLabel.text = model.recommendedHours.isEmpty ? model.displayDateFormat : "\(model.displayDateFormat), \(model.recommendedHours + " hours")"
        ///
        if screenType == .milestoneChangeRequest {
            let statusType = MilestoneStatus.init(rawValue: milestonesArray[indexPath.row].status ?? 0) ?? .notComplete
            cell.makeCellDisable(!(statusType == .notComplete || statusType == .changeRequest))
        }
        ///Closures
        cell.selectionButtonClosure = { [weak self] index in
            guard let self = self else { return }
            let statusType = MilestoneStatus.init(rawValue: self.milestonesArray[index.row].status ?? 0) ?? .notComplete
            if self.screenType == .milestoneChangeRequest, statusType != .notComplete, statusType != .changeRequest {
                return
            }
            self.milestonesArray[index.row].isSelected = !self.milestonesArray[index.row].isSelected
            self.tableViewOutlet.reloadData()
        }
        cell.editButtonClosure = { [weak self] index in
            guard let self = self else { return }
            let statusType = MilestoneStatus.init(rawValue: self.milestonesArray[index.row].status ?? 0) ?? .notComplete
            if self.screenType == .milestoneChangeRequest, statusType != .notComplete, statusType != .changeRequest {
                return
            }
            self.goToAddMilestoneVC(forEdit: true, index: index.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            ///
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.deleteMilestone(indexPath: indexPath, tableView: tableView, completion: { bool in
                completionHandler(bool)
            })
        }
            ///
        let image = #imageLiteral(resourceName: "delete")
        let size = CGSize(width: image.size.width, height: image.size.height + 16)
        deleteAction.image = UIGraphicsImageRenderer(size: size).image { context in
        let centralizedRect = CGRect(origin: .zero, size: image.size)
            image.draw(in: centralizedRect)
        }
        deleteAction.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let statusType = MilestoneStatus.init(rawValue: milestonesArray[indexPath.row].status ?? 0) ?? .notComplete
        return screenType == .milestoneChangeRequest ? (statusType == .notComplete || statusType == .changeRequest) : true
    }
}

//MARK:- HandledDeleting: Delegates
//=================================
extension MilestoneListingVC {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        ///
        if screenType == .milestoneChangeRequest {
            let statusType = MilestoneStatus.init(rawValue: milestonesArray[destinationIndexPath.row].status ?? 0) ?? .notComplete
            if statusType == .notComplete || statusType == .changeRequest {
                let mover = milestonesArray.remove(at: sourceIndexPath.row)
                milestonesArray.insert(mover, at: destinationIndexPath.row)
                isRearranged = isMilestonesRearranged()
                handledTheButtonVisibility()
            }else {
                self.tableViewOutlet.reloadData()
            }
        }else {
            let mover = milestonesArray.remove(at: sourceIndexPath.row)
            milestonesArray.insert(mover, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
