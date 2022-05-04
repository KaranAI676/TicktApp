//
//  BudgetCell.swift
//  Tickt
//
//  Created by Admin on 03/05/21.
//

import UIKit

class BudgetCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var perHourButton: UIButton!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var fixedPriceButton: UIButton!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var bottomListViewContainer: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
        
    var selectButtonClosure: ((_ select: Bool) -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup() {
        heightConstraint.constant = 0
        bottomListViewContainer.addShadow(cornerRadius: 1, color: .darkGray, offset: CGSize(width: 2, height: 2), opacity: 0.4, shadowRadius: 2)
    }
    
    func handleArrowImage(status: Bool) {
        let image = UIImage(named: "dropdown")
        arrowImage.image = status ? image?.rotate(radians: Float.pi) : image
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        switch sender {
        case perHourButton:
            bottomListViewContainer.popOut(completion: { [weak self] bool in
                self?.dropDownTextField.text = PayType.perHour.rawValue
                self?.arrowImage.image = self?.arrowImage.image?.rotate(radians: Float.pi)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.arrowImage.layoutIfNeeded()
                }
            })
        case selectionButton:
            detailTextField.resignFirstResponder()
//            if heightConstraint.constant != 0 {
//                heightConstraint.constant = 0
//                bottomListViewContainer.popOut()
//                selectButtonClosure?(false)
//            } else {
//                heightConstraint.constant = 90
//                bottomListViewContainer.popIn()
//                selectButtonClosure?(true)
//            }
            arrowImage.image = arrowImage.image?.rotate(radians: Float.pi)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.arrowImage.layoutIfNeeded()
            }
            layoutIfNeeded()
            selectButtonClosure?(true)
        case fixedPriceButton:
            bottomListViewContainer.popOut(completion: { [weak self] status in
                self?.dropDownTextField.text = PayType.fixedPrice.rawValue
                self?.arrowImage.image = self?.arrowImage.image?.rotate(radians: Float.pi)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.arrowImage.layoutIfNeeded()
                }
            })
        default:
            break
        }
    }
}
