//
//  CommonTitleWithSwitchTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 11/07/21.
//

import UIKit

class CommonTitleWithSwitchTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var switchClosure: ((IndexPath, Bool)-> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func switchAction(_ sender: UISwitch) {
        guard let tableView = tableView else { return }
        
        if let index = tableViewIndexPath(tableView) {
            switchClosure?(index, sender.isOn)
        }
    }
}
