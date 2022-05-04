//
//  RevenueDetailTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import UIKit

class RevenueDetailTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    //MARK:- Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoEvidenceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK:- Variables
    var model: MyRevenueBuilderMilestone? = nil {
        didSet {
            populateUI()
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
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {}
}

extension RevenueDetailTableCell {
    
    private func configUI() {
        buttonOutlet.isUserInteractionEnabled = false
    }
    
    func setTheDottedLine(_ color: UIColor) {
        DispatchQueue.main.async {
            let cgPointOne: CGPoint = CGPoint(x: self.buttonOutlet.frame.origin.x + self.buttonOutlet.bounds.width/2, y: self.buttonOutlet.frame.maxY + 5)
            let cgPointTwo: CGPoint = CGPoint(x: self.buttonOutlet.frame.origin.x + self.buttonOutlet.bounds.width/2, y: self.containerView.frame.maxY)
            self.containerView.createDashedLine( color: color.cgColor, cgPoints: [cgPointOne,cgPointTwo])
        }
    }
    
    func makeCellDisable(_ disable: Bool = true) {
        setTheDottedLine(disable ? #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.8980392157, alpha: 1) : #colorLiteral(red: 0.1124618724, green: 0.1628664136, blue: 0.3626073599, alpha: 1))
        if disable {
            nameLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            photoEvidenceLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            priceLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
        }else {
            nameLabel.textColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
            photoEvidenceLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            dateLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            priceLabel.textColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
        }
    }
    
    private func populateUI() {
        guard let model = model else { return }
        nameLabel.text = model.milestoneName
        dateLabel.text = CommonFunctions.getFormattedDates(fromDate: model.fromDate.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        priceLabel.text = model.milestoneEarning
        buttonOutlet.isSelected = (model.status != "Comming" && model.status != "Declined")
        makeCellDisable(model.status == "Comming" || model.status == "Declined")
    }
}
