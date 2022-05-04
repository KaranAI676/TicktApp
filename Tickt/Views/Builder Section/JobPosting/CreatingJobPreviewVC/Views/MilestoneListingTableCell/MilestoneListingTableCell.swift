//
//  MilestoneListingTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 31/03/21.
//

import UIKit

class MilestoneListingTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var milestoneNameLabel: UILabel!
    @IBOutlet weak var milestoneDatesLabel: UILabel!
            
    //MARK:- Variable
    var openJobModel: (data: JobMilestonesData?, screenType: ScreenType)? = nil {
        didSet {
            self.populateUI(.openJobs)
        }
    }
    var republishModel: MilestoneModel? {
        didSet {
            self.populateUI(.pastJobsExpired)
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

extension MilestoneListingTableCell {
    
    private func populateUI(_ screenType: ScreenType) {
        switch screenType {
        case .openJobs, .pastJobsCompleted, .activeJob:
            guard  let model = openJobModel?.data else { return }
            milestoneNameLabel.text = model.milestoneName
            milestoneDatesLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate?.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        case .pastJobsExpired:
            guard  let model = republishModel else { return }
            milestoneNameLabel.text = model.milestoneName
            milestoneDatesLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.date, toDate: model.toDate.date)
        default:
            break
        }
    }
}
