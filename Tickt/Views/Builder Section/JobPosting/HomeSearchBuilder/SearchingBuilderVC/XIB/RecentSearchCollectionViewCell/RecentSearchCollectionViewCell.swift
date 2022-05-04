//
//  RecentSearchCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 27/04/21.
//

import UIKit

class RecentSearchCollectionViewCell: UICollectionViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var jobImagView: UIImageView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    
    //MARK:- Variables
    var searchData: SearchedResultData? {
        didSet {
            jobTypeLabel.text = searchData?.tradeName ?? "N.A"
            jobNameLabel.text = searchData?.name ?? "N.A"
//            jobImagView.sd_setImage(with: URL(string: searchData?.image ?? ""), placeholderImage: nil)
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
