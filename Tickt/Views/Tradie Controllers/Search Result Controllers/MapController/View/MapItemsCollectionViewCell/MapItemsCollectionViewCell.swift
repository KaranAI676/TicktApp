//
//  MapItemsCollectionViewCell.swift
//  Tickt
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit
import SDWebImage

enum MediaType: Int {
    case image = 1
    case video = 2
}

class MapItemsCollectionViewCell: UICollectionViewCell {
    
    enum ItemsAction {
        case playVideo
    }
    
    var cellAction: (() -> Void)? = nil
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var timeLabel: CustomRegularLabel!
    @IBOutlet weak var daysLabel: CustomRegularLabel!
    @IBOutlet weak var priceLabel: CustomRegularLabel!
    @IBOutlet weak var addressLabel: CustomRegularLabel!
    @IBOutlet weak var jobNameLabel: CustomRegularLabel!
    @IBOutlet weak var categoryNameLabel: CustomBoldLabel!
            
    override func awakeFromNib() {
        super.awakeFromNib()
    }
            
    var job: RecommmendedJob? {
        didSet {
            timeLabel.text = job?.time
            daysLabel.text = job?.durations
            priceLabel.text = job?.amount
            addressLabel.text = job?.locationName
            jobNameLabel.text = job?.builderName
            categoryNameLabel.text = job?.jobName
            jobImageView.sd_setImage(with: URL(string: job?.builderImage ?? ""), placeholderImage: nil)
        }
    }
        
    @IBAction func detailButtonAction(_ sender: UIButton) {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            cellAction?()
        }
    }
}
