//
//  BankDetailTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 17/06/21.
//

import UIKit

class BankDetailTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var forwardButtonBackView: UIView!
    @IBOutlet weak var forwardButton: UIButton!
    
    //MARK:- Variables
    var model: CardListResultModel? = nil {
        didSet {
            populateUI()
        }
    }
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath)-> Void)? = nil
    
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
            buttonClosure?(index)
        }
    }
}

extension BankDetailTableCell {
    
    private func populateUI() {
        guard let model = model else { return }
        topLabel.text = model.funding.getFormattedCardName()
        bottomLabel.text = model.last4.geFormattedAccountNo()
    }
}
