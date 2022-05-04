//
//  CommonRadioButtonTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 13/04/21.
//

import UIKit

class CommonRadioButtonTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var radioButtonOutlet: UIButton!
    @IBOutlet weak var nameTextLabel: UILabel!
    ///
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath) -> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = self.tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            buttonClosure?(index)
        }
    }
}

extension CommonRadioButtonTableCell {
    
    func populateUI(title: String? = nil, name: String) {
        self.titleLabel.isHidden = title == nil
        self.topConstraint.constant = title == nil ? 0 : 24
        self.titleLabel.text = title
        self.nameTextLabel.text = name
    }
}
