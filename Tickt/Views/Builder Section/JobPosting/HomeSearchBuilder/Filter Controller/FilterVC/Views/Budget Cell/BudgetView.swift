//
//  BudgetView.swift
//  Tickt
//
//  Created by Admin on 03/05/21.
//

import UIKit

class BudgetView: UIView {      
        
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var perHourButton: UIButton!
    @IBOutlet weak var fixedPriceButton: UIButton!
    @IBOutlet weak var bottomListViewContainer: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var closeButtonAction: (()-> ())?
    var budgetAction: ((_ payType: String)-> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup() {
        widthConstraint.constant = (kScreenWidth - 56) / 2
        bottomListViewContainer.addShadow(cornerRadius: 0, color: .darkGray, offset: CGSize(width: 1, height: 1), opacity: 0.2, shadowRadius: 1)
    }    
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        defer {
            dismissView()
        }
        switch sender {
        case perHourButton:
            budgetAction?(PayType.perHour.rawValue)
        case fixedPriceButton:
            budgetAction?(PayType.fixedPrice.rawValue)
        default:
            closeButtonAction?()
        }
    }
    
    func dismissView() {
        bottomListViewContainer.popOut()
        removeFromSuperview()
    }
}
