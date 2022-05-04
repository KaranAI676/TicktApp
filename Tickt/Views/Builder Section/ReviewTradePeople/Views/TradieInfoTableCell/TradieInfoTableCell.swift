//
//  TradieInfoTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 26/05/21.
//

import UIKit

class TradieInfoTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var userNameLabel: CustomBoldLabel!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var ratingLabel: CustomRegularLabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var buttonClosure: (()->Void)? = nil
    var tradieModel: PastJobTradieData? = nil {
        didSet {
            populateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonClosure?()
    }
}

extension TradieInfoTableCell {
    
    private func populateUI() {
        guard let model = self.tradieModel else { return }
        userNameLabel.text = model.tradieName
        ratingLabel.text = "\(model.ratings ?? 0), \(model.reviews ?? 0) reviews"
        profileImageView.sd_setImage(with: URL(string:(model.tradieImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
    }
}
