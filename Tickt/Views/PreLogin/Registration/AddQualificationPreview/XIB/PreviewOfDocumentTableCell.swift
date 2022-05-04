//
//  PreviewOfDocumentTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 09/03/21.
//

import UIKit

class PreviewOfDocumentTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var documentNameLabel: UILabel!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath)->Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let tableView = self.tableView {
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(index)
            }
        }
    }
}
