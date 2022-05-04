//
//  CheckApproveTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 17/05/21.
//

import UIKit

class CheckApproveTableCell: UITableViewCell {
    
    enum ButtonType {
        case status
        case checkApprove
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var milestoneNameLabel: UILabel!
    @IBOutlet weak var isPhotoRequiredLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkApproveButton: UIButton!
    @IBOutlet weak var labelsSubContainerView: UIView!
    
    //MARK:- Variables
    var model: CheckApprovedMilestones? = nil {
        didSet {
            self.populateUI()
        }
    }
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath, ButtonType)->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = self.tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            switch sender {
            case statusButton:
                self.buttonClosure?(index, .status)
            case checkApproveButton:
                self.buttonClosure?(index, .checkApprove)
            default:
                break
            }
        }
    }
}

extension CheckApproveTableCell {
    
    private func populateUI() {
        guard let model = self.model else { return }
        milestoneNameLabel.text = model.milestoneName
        isPhotoRequiredLabel.isHidden = !model.isPhotoevidence
        let date = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        dateLabel.text = date
        checkApproveButton.isHidden = !(model.isSelected ?? false)
        let status = MilestoneStatus.init(rawValue: model.status) ?? .notComplete
        setupFont(status)
        switch status {
        case .notComplete, .changeRequest:
            milestoneNameLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            isPhotoRequiredLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            checkApproveButton.isHidden = true
            statusButton.isUserInteractionEnabled = false
            statusButton.setImageForAllMode(image: #imageLiteral(resourceName: "checkBoxUnselected"))
            setTheDottedLine(color: #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1))
        case .completed:
            milestoneNameLabel.textColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
            isPhotoRequiredLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            statusButton.isUserInteractionEnabled = model.statusButtonCanInteract ?? false
            statusButton.setImageForAllMode(image: (model.isSelected ?? false) ? #imageLiteral(resourceName: "bulletSelection") : #imageLiteral(resourceName: "checkBoxUnselected"))
            setTheDottedLine(color: .clear)
        case .approved:
            milestoneNameLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            isPhotoRequiredLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            statusButton.isUserInteractionEnabled = true
            checkApproveButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            checkApproveButton.setTitleForAllMode(title: "See details")
            statusButton.setImageForAllMode(image: #imageLiteral(resourceName: "icCheck"))
            setTheDottedLine()
        case .declined:
            milestoneNameLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            isPhotoRequiredLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            statusButton.isUserInteractionEnabled = true
            checkApproveButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            checkApproveButton.setTitleForAllMode(title: "See details")
            statusButton.setImageForAllMode(image: #imageLiteral(resourceName: "checkBoxUnselected"))
            setTheDottedLine(color: #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1))
        case .changeRequestAccepted:
            milestoneNameLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            isPhotoRequiredLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            checkApproveButton.isHidden = true
            statusButton.isUserInteractionEnabled = false
            statusButton.setImageForAllMode(image: #imageLiteral(resourceName: "checkBoxUnselected"))
            setTheDottedLine(color: #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1))
        }
    }
    
    private func setupFont(_ status: MilestoneStatus) {
        switch status {
        case .changeRequestAccepted:
            milestoneNameLabel.font = UIFont.kAppDefaultFontBold(ofSize: 17)
            isPhotoRequiredLabel.font = UIFont.kAppDefaultFontMedium(ofSize: 16)
            dateLabel.font = UIFont.kAppDefaultFontMedium(ofSize: 16)
        default:
            milestoneNameLabel.font = UIFont.kAppDefaultFontMedium(ofSize: 16)
            isPhotoRequiredLabel.font = UIFont.systemFont(ofSize: 15)
            dateLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    private func setTheDottedLine(color: UIColor = #colorLiteral(red: 0.0431372549, green: 0.2549019608, blue: 0.6588235294, alpha: 1)) {
        DispatchQueue.main.async {
            let cgPointOne: CGPoint = CGPoint(x: self.statusButton.frame.midX, y: self.statusButton.frame.maxY + 5)
            let cgPointTwo: CGPoint = CGPoint(x: self.statusButton.frame.midX, y: self.labelsSubContainerView.frame.maxY)
            self.labelsSubContainerView.createDashedLine(color: color.cgColor, cgPoints: [cgPointOne,cgPointTwo])
        }
    }
}
