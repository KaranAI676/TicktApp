//
//  RatingTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import UIKit
import Cosmos

class RatingTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    //MARK:- Variables
    var updateRatingClosure: ((Double)->Void)? = nil
    
    //MARK:- IB Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}

extension RatingTableCell {
    
    private func configUI() {
        setupRatingView()
    }
    
    private func setupRatingView() {
        cosmosView.settings.fillMode = .half
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else { return }
            self.updateRatingClosure?(rating)
        }
    }
}
