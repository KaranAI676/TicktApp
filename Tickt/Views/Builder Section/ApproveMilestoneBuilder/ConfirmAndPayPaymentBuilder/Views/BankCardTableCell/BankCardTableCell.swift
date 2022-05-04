//
//  BankCardTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import UIKit

class BankCardTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainCOntainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var accontNumberLabel: UILabel!
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var selectionButton: UIButton!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath, Bool)-> Void)? = nil
    var cardModel: CardListResultModel? = nil {
        didSet {
            populateUI()
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
    @IBAction func buttonTapeped(_ sender: UIButton) {
        guard let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            buttonClosure?(index, !selectionButton.isSelected)
        }
    }
}

extension BankCardTableCell {
    
    private func populateUI() {
        guard let model = cardModel else { return }
        selectionButton.isSelected = model.isSelected ?? false
        selectionButton.isUserInteractionEnabled = false
        cardView.borderWidth = 1
        cardView.borderColor = selectionButton.isSelected ? AppColors.themeBlue : AppColors.backViewGrey
        cardView.backgroundColor = selectionButton.isSelected ? AppColors.backGorundWhite : .white
        ///
        cardNameLabel.text = model.funding.getFormattedCardName()
        accontNumberLabel.text = model.last4.geFormattedAccountNo()
    }
}
