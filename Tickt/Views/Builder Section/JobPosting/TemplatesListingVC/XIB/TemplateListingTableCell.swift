//
//  TemplateListingTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 02/04/21.
//

import UIKit

class TemplateListingTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var templateNameLabel: UILabel!
    @IBOutlet weak var milestoneCount: UILabel!
    @IBOutlet weak var milestonesTitleLabel: UILabel!
    
    //MARK:- Variables
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TemplateListingTableCell {
    
    func populateUI(name: String, count: String) {
        self.templateNameLabel.text = name
        self.milestoneCount.text = count
    }
}
