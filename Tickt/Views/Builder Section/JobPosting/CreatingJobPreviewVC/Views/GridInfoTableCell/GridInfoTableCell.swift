//
//  GridInfoTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 30/03/21.
//

import UIKit

class GridInfoTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    ///
    @IBOutlet weak var mainStackView: UIStackView!
    ///
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var firstBackView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondBackView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    ///
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdBackView: UIView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var forthBackView: UIView!
    @IBOutlet weak var forthImageView: UIImageView!
    @IBOutlet weak var forthLabel: UILabel!
    
    //MARK:- Variables
    var pastJobStatus: String = ""
    var openJobModel: (data: JobDetailsData?, screenType: ScreenType)? = nil {
        didSet {
            if let model = openJobModel {
                self.populateUI(model.screenType)
            }
        }
    }
    var republishModel: CreateJobModel? = nil {
        didSet {
            self.populateUI(.pastJobsExpired)
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK:-
extension GridInfoTableCell {
    
    func configUI() {
        firstLabel.numberOfLines = 0
        secondLabel.numberOfLines = 0
        thirdLabel.numberOfLines = 1
        forthLabel.numberOfLines = 0
    }
    
    func populateUI(text: [String]) {
        self.hideUnhideTheGridCell(count: text.count)
        switch text.count {
        case 4:
            firstLabel.text = text[0]
            secondLabel.text = text[1]
            thirdLabel.text = text[2]
            forthLabel.text = text[3]
        case 3:
            firstLabel.text = text[0]
            secondLabel.text = text[1]
            thirdLabel.text = text[2]
        case 2:
            firstLabel.text = text[0]
            secondLabel.text = text[1]
        case 1:
            firstLabel.text = text[0]
        default:
            break
        }
    }
    
    private func hideUnhideTheGridCell(count: Int) {
        switch count {
        case 4:
            firstBackView.isHidden = false
            secondBackView.isHidden = false
            thirdBackView.isHidden = false
            forthBackView.isHidden = false
        case 3:
            firstBackView.isHidden = false
            secondBackView.isHidden = false
            thirdBackView.isHidden = false
            forthBackView.isHidden = true
        case 2:
            firstBackView.isHidden = false
            secondBackView.isHidden = false
            thirdBackView.isHidden = true
            forthBackView.isHidden = true
        case 1:
            firstBackView.isHidden = false
            secondBackView.isHidden = true
            thirdBackView.isHidden = false
            forthBackView.isHidden = true
        default:
            firstBackView.isHidden = true
            secondBackView.isHidden = true
            thirdBackView.isHidden = false
            forthBackView.isHidden = true
        }
    }
}

extension GridInfoTableCell {
    
    private func populateUI(_ screenType: ScreenType) {
        switch screenType {
        case .openJobs, .activeJob:
            firstImageView.image = #imageLiteral(resourceName: "clock")
            secondImageView.image = #imageLiteral(resourceName: "dollar")
            thirdImageView.image =  #imageLiteral(resourceName: "place")
            forthImageView.image = #imageLiteral(resourceName: "calendar")
            ///
            guard let model = openJobModel?.data else { return }
            let first = model.duration ?? ""
            let second: String = model.amount ?? ""
            let third: String = model.locationName ?? ""
            let forth: String = CommonFunctions.getFormattedDates(fromDate: model.fromDate?.convertToDateAllowsNil() ?? Date(), toDate: model.toDate?.convertToDateAllowsNil())
            populateUI(text: [first, second, third, forth])
        case .pastJobsCompleted, .pastJobsExpired:
            firstImageView.image = #imageLiteral(resourceName: "calendar")
            secondImageView.image = #imageLiteral(resourceName: "dollar")
            thirdImageView.image =  #imageLiteral(resourceName: "place")
            forthImageView.isHidden = true
            ///
            guard let model = openJobModel?.data else { return }

            let first = CommonFunctions.getFormattedDates(fromDate: model.fromDate?.convertToDateAllowsNil() ?? Date(), toDate: model.toDate?.convertToDateAllowsNil())
            let second: String = model.amount ?? ""
            let third: String = model.locationName ?? ""
            let forth: String = pastJobStatus
            forthLabel.font = UIFont.kAppDefaultFontBold(ofSize: 10)
            forthLabel.textColor = #colorLiteral(red: 0.0431372549, green: 0.2549019608, blue: 0.6588235294, alpha: 1)
            populateUI(text: [first, second, third, forth])
        default:
            break
        }
    }
}
