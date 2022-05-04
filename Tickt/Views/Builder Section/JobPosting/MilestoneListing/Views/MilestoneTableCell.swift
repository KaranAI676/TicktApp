//
//  MilestoneTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 19/03/21.
//

import UIKit

class MilestoneTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var milestoneName: UILabel!
    @IBOutlet weak var evidenceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upperStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelInvitationButton: UIButton!
    
    //MARK:- Variables
    var jobListModel: JobListingBuilderResult? = nil {
        didSet {
            populateUI()
        }
    }
    var tableView: UITableView? = nil
    var selectionButtonClosure: ((IndexPath)->(Void))? = nil
    var selectionButtonClosureWithBool: ((IndexPath, Bool)->(Void))? = nil
    var editButtonClosure: ((IndexPath)->(Void))? = nil
    var cancelButtonClosure: ((IndexPath)->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case selectionButton:
            if let tableView = self.tableView {
                if let index = tableViewIndexPath(tableView) {
                    jobListModel == nil ? selectionButtonClosure?(index) : selectionButtonClosureWithBool?(index, !(jobListModel?.isSelected ?? false))
                }
            }
        case editButton:
            if let tableView = self.tableView {
                if let index = tableViewIndexPath(tableView) {
                    self.editButtonClosure?(index)
                }
            }
        case cancelInvitationButton:
            if let tableView = self.tableView {
                if let index = tableViewIndexPath(tableView) {
                    cancelButtonClosure?(index)
                }
            }
        default:
            break
        }        
    }
    
    func setTheDottedLine() {
        DispatchQueue.main.async {
            let cgPointOne: CGPoint = CGPoint(x: self.selectionButton.frame.origin.x + self.selectionButton.bounds.width/2, y: self.selectionButton.frame.maxY + 5)
            let cgPointTwo: CGPoint = CGPoint(x: self.selectionButton.frame.origin.x + self.selectionButton.bounds.width/2, y: self.containerView.frame.maxY - 20)
            self.containerView.createDashedLine( color: #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1), cgPoints: [cgPointOne,cgPointTwo])
        }
    }
    
    func makeCellDisable(_ disable: Bool = true) {
        if disable {
            milestoneName.textColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            evidenceLabel.textColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            timeLabel.textColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        }else {
            milestoneName.textColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
            evidenceLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            timeLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
        }
    }
}

extension MilestoneTableCell {
    
    private func populateUI() {
        editButton.isHidden = true
        ///
        guard let model = jobListModel else { return }
        milestoneName.text = model.tradeName
        evidenceLabel.text = model.jobName
        selectionButton.isSelected = model.isSelected ?? false
        descriptionLabel.isHidden = model.jobDescription.isEmpty
        descriptionLabel.text = model.jobDescription
        ///
        timeLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate.convertToDateAllowsNil())
    }
}
