//
//  RecentSearchCell.swift
//  Tickt
//
//  Created by Admin on 27/03/21.
//

import SDWebImage

class RecentSearchCell: UITableViewCell {

    @IBOutlet weak var jobImagView: UIImageView!
    @IBOutlet weak var jobNameLabel: CustomMediumField!
    @IBOutlet weak var jobTypeLabel: CustomRegularField!    
        
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightIconConstant: NSLayoutConstraint!
    @IBOutlet weak var widthIconConstant: NSLayoutConstraint!
    var searchData: SearchedResultData? {
        didSet {
            jobTypeLabel.text = searchData?.tradeName ?? "N.A"
            jobNameLabel.text = searchData?.name ?? "N.A"
            jobImagView.sd_setImage(with: URL(string: searchData?.image ?? ""), placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
}
