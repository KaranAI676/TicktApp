//
//  CancellationTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 07/07/21.
//

import UIKit

class CancellationTableCell: UITableViewCell {

    enum CellType {
        case cr
        case cancel
        case cancelDecline
        case cancelWithButtons
        
        var title: String {
            switch self {
            case .cr:
                return "Change request decline reason"
            case .cancelWithButtons:
                return "Job cancellation request"
            case .cancel:
                return "Job cancellation reason"
            case .cancelDecline:
                return "Job cancellation decline reason"
            }
        }
        
        var isHidden: Bool {
            switch self {
            case .cr, .cancel, .cancelDecline:
                return true
            case .cancelWithButtons:
                return false
            }
        }
    }
    
    enum ButtonTypes {
        case accept
        case reject
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var titlteTopLabel: UILabel!
    @IBOutlet weak var reasonTitleLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    //MARK:- Variables
    var titleReason: (type: CellType, reason: String, description: String) = (.cancelWithButtons,"", "") {
        didSet {
            populateUI()
        }
    }
    var buttonClosure: ((ButtonTypes)-> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case acceptButton:
            buttonClosure?(.accept)
        case declineButton:
            buttonClosure?(.reject)
        default:
            break
        }
    }
}

extension CancellationTableCell {
    
    private func configUI() {
        dropShadow()
    }
    
    private func dropShadow(scale: Bool = true) {
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.8274509804, alpha: 1)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 6
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func populateUI() {
        titlteTopLabel.text = titleReason.type.title
        reasonTitleLabel.text = titleReason.reason
        reasonLabel.text = titleReason.description
        buttonsStackView.isHidden = titleReason.type.isHidden
    }
}
