//
//  CommonRatioButtonWithTileTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 22/03/21.
//

import UIKit

class CommonRatioButtonWithTileTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var selectionButtonClosure: ((IndexPath)-> (Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = self.tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            selectionButtonClosure?(index)
        }
    }
}

