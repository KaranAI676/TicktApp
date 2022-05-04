//
//  VoucherTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import UIKit

class VoucherTableCell: UITableViewCell {

    //MARK:- IB OUtlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNmaeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voucherLabel: UILabel!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var openRecommendedButton: UIButton!
    
    //MARK:- Variables
    var tableView: UITableView?
    var vouchesData: TradieProfileVouchesData? {
        didSet {
            populateUI()
        }
    }
    var openRecommendedClosure: ((IndexPath)-> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Action
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            openRecommendedClosure?(index)
        }
    }
}

extension VoucherTableCell {
    
    private func populateUI() {
        guard  let model = vouchesData else { return }
        profileImageView.sd_setImage(with: URL(string: model.builderImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        userNmaeLabel.text = model.builderName
        dateLabel.text = model.date
        jobNameLabel.text = model.jobName
        descriptionLabel.text = model.vouchDescription
        voucherLabel.attributedText = "Vouch for \(model.tradieName)".underLinedString()
    }
}
