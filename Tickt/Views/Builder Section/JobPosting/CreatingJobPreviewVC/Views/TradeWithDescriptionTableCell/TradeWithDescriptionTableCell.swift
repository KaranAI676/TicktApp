//
//  TradeWithDescriptionTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 29/03/21.
//

import UIKit
import SDWebImage

class TradeWithDescriptionTableCell: UITableViewCell {

//    enum CellType {
//        case openJob
//    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var MainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
    ///
    @IBOutlet weak var editButtonBackView: UIView!
    @IBOutlet weak var editButton: UIButton!

    //MARK:- Variables
    var model: (data: JobDetailsData?, screenType: ScreenType)? = nil {
        didSet {
            if let screenType = model?.screenType {
                self.populateUI(screenType)
            }
        }
    }
    var republishModel: CreateJobModel? = nil {
        didSet {
            self.populateUI(.pastJobsExpired)
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

//MARK:- PopulateUI
//=================
extension TradeWithDescriptionTableCell {
    
    func populateUI(title: String, description: String, image: UIImage) {
        self.titleLabel.text = title
        self.decriptionLabel.text = description
        self.iconImageView.image = image
    }
    
    func populateUI(title: String, description: String, image: String) {
        self.titleLabel.text = title
        self.decriptionLabel.text = description
        self.iconImageView.sd_setImage(with: URL(string:(image)), placeholderImage: nil)
    }
}


extension TradeWithDescriptionTableCell {
    
    private func populateUI(_ screenType: ScreenType) {
        updateUI(screenType)
        ///
        switch screenType {
        case .openJobs, .activeJob, .pastJobsCompleted, .pastJobsExpired:
            guard  let model = self.model?.data else { return }
            self.titleLabel.text = model.tradeName
            self.decriptionLabel.text = model.jobName
            self.iconImageView.sd_setImage(with: URL(string: model.tradeSelectedUrl ?? ""), placeholderImage: nil)
        default:
            break
        }
    }
    
    private func updateUI(_ screenType: ScreenType) {
        switch screenType {
        case .openJobs, .activeJob, .pastJobsCompleted, .pastJobsExpired:
            editButtonBackView.isHidden = true
//        case .pastJobsExpired:
//            editButtonBackView.isHidden = false
        default:
            break
        }
    }
}
