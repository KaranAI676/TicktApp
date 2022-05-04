//
//  ItemListCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 06/09/21.
//

import UIKit

class ItemListCell: UITableViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var priceLabel: CustomMediumLabel!
    @IBOutlet weak var itemNumberLabel: CustomMediumLabel!
    @IBOutlet weak var itemDescriptionLabel: CustomMediumLabel!
    
    var itemDetail: ItemDetails? {
        didSet {
            itemDescriptionLabel.text = itemDetail?.description
            itemNumberLabel.text = "\(itemDetail?.itemNumber ?? 0)"
            let amount = "\(itemDetail?.totalAmount ?? 0)"
            priceLabel.text = amount.currencyFormatting()
        }
    }
    
    var isEdit: Bool = false {
        didSet {
            editButton.isHidden = !isEdit
        }
    }
    
    var editButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        editButtonAction?()
    }
}

