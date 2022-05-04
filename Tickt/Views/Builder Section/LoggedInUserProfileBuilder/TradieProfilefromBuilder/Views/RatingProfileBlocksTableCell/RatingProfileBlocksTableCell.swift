//
//  RatingProfileBlocksTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import UIKit

class RatingProfileBlocksTableCell: UITableViewCell {

    enum cellType {
        case tradieProfile
        case logginProfile
        case loggedInBuilder
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    /// first block
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    /// Second block
    @IBOutlet weak var jobsCompletedImageView: UIImageView!
    @IBOutlet weak var jobsCompletedCountLabel: UILabel!
    @IBOutlet weak var jobsCompltedLabel: UILabel!
    
    //MARK:- Variables
    var model: TradieProfileResult? = nil {
        didSet {
            populateUI(.tradieProfile)
        }
    }
    var loggedinModel: LoggedInUserProfileResultModel? = nil {
        didSet {
            populateUI(.logginProfile)
        }
    }
    var loggedInBuilder: BuilderProfileResult? = nil {
        didSet {
            populateUI(.loggedInBuilder)
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension RatingProfileBlocksTableCell {
    
    private func populateUI(_ cellType: cellType) {
        switch cellType {
        case .tradieProfile:
            guard let model = self.model else { return }
            reviewLabel.text = "\(model.reviewsCount) reviews"
            ratingCountLabel.text = "\(model.ratings)"
            jobsCompletedCountLabel.text = "\(model.jobCompletedCount)"
        case .logginProfile:
            guard let model = loggedinModel else { return }
            reviewLabel.text = "\(model.reviews) reviews"
            ratingCountLabel.text = "\(model.ratings)"
            jobsCompletedCountLabel.text = "\(model.jobCompletedCount)"
        case .loggedInBuilder:
            guard let model = loggedInBuilder else { return }
            reviewLabel.text = "\(model.reviewsCount) reviews"
            ratingCountLabel.text = "\(model.ratings)"
            jobsCompletedCountLabel.text = "\(model.jobCompletedCount)"
        }
    }
}
