//
//  TableViewCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 24/03/21.
//

import UIKit

class TableViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    private var arrayOfCellTypes: [AddMilestoneVC.CellTypes] = [.milestoneName, .photoEvidence, .milestoneDuration, .recommendedHours]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

}

extension TableViewCollectionViewCell {
    
    private func configUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        ///
        tableViewOutlet.registerCell(with: CommonTextFieldsTableCell.self)
        tableViewOutlet.registerCell(with: ChooseButtonWithLeftTitleTableCell.self)
        tableViewOutlet.registerCell(with: CommonRatioButtonWithTileTableCell.self)
    }
}

extension TableViewCollectionViewCell: TableDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrayOfCellTypes[indexPath.row] {
        case .milestoneName:
            let cell = tableView.dequeueCell(with: CommonTextFieldsTableCell.self)
            cell.tableView = tableView
            cell.populateUI(titleName: "Milestone Name", placeHolder: "Milestone Name")
            cell.textFieldTextField.keyboardType = .default
//            cell.textFieldTextField.delegate = self
            return cell
        case .photoEvidence:
            let cell = tableView.dequeueCell(with: CommonRatioButtonWithTileTableCell.self)
            cell.tableView = tableView
            cell.selectionButtonClosure = { [weak self] (index) in
                guard let _ = self else { return }
                CommonFunctions.showToastWithMessage("Under Development")
            }
            return cell
        case .milestoneDuration:
            let cell = tableView.dequeueCell(with: ChooseButtonWithLeftTitleTableCell.self)
            cell.tableView = tableView
            cell.chooseButtonClosure = { [weak self] (index) in
                guard let _ = self else { return }
                CommonFunctions.showToastWithMessage("Under Development")
            }
            return cell
        case .recommendedHours:
            let cell = tableView.dequeueCell(with: CommonTextFieldsTableCell.self)
            cell.tableView = tableView
            cell.populateUI(titleName: "Recommended hours", placeHolder: "Recommended hours")
            cell.textFieldTextField.keyboardType = .numberPad
//            cell.textFieldTextField.delegate = self
            return cell
        }
    }
}
