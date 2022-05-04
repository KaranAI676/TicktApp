//
//  JobDetailsTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 26/05/21.
//

import UIKit

class JobDetailsTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var tradeNameLabel: UILabel!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    
    //MARK:- Variables
    var buttonClosure: (()->Void)? = nil
    var jobDetailModel: PastJobData? = nil {
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
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonClosure?()
    }
}

extension JobDetailsTableCell {
    
    private func populateUI() {
        guard let model = self.jobDetailModel else { return }
        tradeNameLabel.text = model.tradeName
        jobNameLabel.text = model.jobName
        dateLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate?.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        tradeImageView.sd_setImage(with: URL(string:(model.tradeSelectedUrl ?? "")), placeholderImage: nil)
    }
}
