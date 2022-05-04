//
//  CategorySearchedTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/04/21.
//

import UIKit

class CategorySearchedTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var jobImagView: UIImageView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    
    //MARK:- Variables
    var searchData: SearchedResultData? {
        didSet {
            jobTypeLabel.text = searchData?.tradeName ?? "N.A"
            jobNameLabel.text = searchData?.name ?? "N.A"
            jobImagView.sd_setImage(with: URL(string: searchData?.image ?? ""), placeholderImage: nil)
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
