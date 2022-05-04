//
//  ViewNearByCell.swift
//  Tickt
//
//  Created by Admin on 27/03/21.
//

import UIKit

class ViewNearByCell: UITableViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var headingLabel: CustomMediumLabel!
    @IBOutlet weak var viewNearbyButton: UIButton!
    @IBOutlet weak var subHeadingLabel: CustomRomanLabel!
    
    //MARK:- Variables
    var buttonClosureTradie: (()->(Void))? = nil
    var buttonClosureBuilder: (()->(Void))? = nil
    
    //MARK:- LifeCycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- IB Action
    @IBAction func buttonTapped(_ sender: UIButton) {
        let _ = kUserDefaults.getUserType() == 1 ? buttonClosureTradie?() : buttonClosureBuilder?()
        disableButton(sender)
    }
}

extension ViewNearByCell {
    
    func populateUI(userType: Int) {
        if userType == 1 {
          //  self.backImageView.image = #imageLiteral(resourceName: "Mask Group")
            self.headingLabel.text = "See jobs \naround me"
            self.subHeadingLabel.text = "Find jobs in your local area"
            self.viewNearbyButton.setTitle("View Nearby", for: .normal)
        }else {
         //   self.backImageView.image = #imageLiteral(resourceName: "maskGroupBuilder")
            self.viewNearbyButton.backgroundColor = AppColors.themeYellow
            self.headingLabel.text = "Your local \nnetwork"
            self.subHeadingLabel.text = "Connect with \ntradespeople in your area"
            self.viewNearbyButton.setTitle("Search Now", for: .normal)
        }
    }
}
