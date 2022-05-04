//
//  DetailsWithTitleTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 29/03/21.
//

import UIKit

class DetailsWithTitleTableCell: UITableViewCell {

    enum CellType {
        case openJob
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editBackView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    var model: (data: String?, screenType: ScreenType)? = nil {
        didSet {
            if let screenType = model?.screenType {
                populateUI(screenType)
            }
        }
    }
    var republishModel: CreateJobModel? {
        didSet {
            populateUI(.pastJobsExpired)
        }
    }
    
    var isJobDetail: Bool? {
        didSet {
            editButton.isHidden = isJobDetail ?? false
        }
    }
    var editButtonClosure: (()->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.editButtonClosure?()
    }
}

extension DetailsWithTitleTableCell {
    
    func populateUI(title: String, desc: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = desc
    }
    
    func populateUI(_ screenType: ScreenType) {
        updateUI(screenType)
        switch screenType {
        case .openJobs, .pastJobsCompleted, .activeJob, .pastJobsExpired:
            self.titleLabel.text = "Job Description"
            if let description = self.model?.data {
                self.descriptionLabel.text = description
            }
//        case .pastJobsExpired:
//            self.titleLabel.text = "Details"
//            if let description = self.republishModel?.jobDescription {
//                self.descriptionLabel.text = description
//            }
        default:
            break
        }
    }
    
    func updateUI(_ screenType: ScreenType) {
        switch screenType {
        case .openJobs, .pastJobsCompleted, .pastJobsExpired:
            editBackView.isHidden = true
//        case .pastJobsExpired:
//            editBackView.isHidden = false
        default:
            break
        }
    }
}
