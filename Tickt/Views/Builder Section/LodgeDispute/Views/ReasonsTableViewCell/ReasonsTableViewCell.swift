//
//  ReasonsTableViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 16/06/21.
//

import UIKit

class ReasonsTableViewCell: UITableViewCell {

    enum CellType {
        case reason
        case option
        case dispute
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var reasonNameLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var updateModel: ((IndexPath, Bool)->Void)? = nil
    var reasonsModel: ReasonsModel? {
        didSet {
            populateUI(.reason)
        }
    }

    var disputeModel: DisputeModel? {
        didSet {
            populateUI(.dispute)
        }
    }
    
    var optionsModel: SupportChatOptionModel? {
        didSet {
            populateUI(.option)
        }
    }

    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            updateModel?(index, !selectionButton.isSelected)
        }
    }
}

extension ReasonsTableViewCell {
    
    private func populateUI(_ cellType: CellType) {
        switch cellType {
        case .reason:
            guard let model = reasonsModel else { return }
            reasonNameLabel.text = model.reasonType.reason
            selectionButton.isSelected = model.isSelected
            ///
            selectionButton.setImage(#imageLiteral(resourceName: "checkBoxUnselected"), for: .normal)
            selectionButton.setImage(#imageLiteral(resourceName: "icCheck"), for: .selected)
        case .option:
            guard let model = optionsModel else { return }
            reasonNameLabel.text = model.optionType.optionName
            selectionButton.isSelected = model.isSelected
            ///
            selectionButton.setImage(#imageLiteral(resourceName: "checkBoxUnselected"), for: .normal)
            selectionButton.setImage(#imageLiteral(resourceName: "bulletSelection"), for: .selected)
        case .dispute:
            guard let model = disputeModel else { return }
            reasonNameLabel.text = model.reasonType.reason
            selectionButton.isSelected = model.isSelected
            ///
            selectionButton.setImage(#imageLiteral(resourceName: "checkBoxUnselected"), for: .normal)
            selectionButton.setImage(#imageLiteral(resourceName: "icCheck"), for: .selected)
        }
    }
}
