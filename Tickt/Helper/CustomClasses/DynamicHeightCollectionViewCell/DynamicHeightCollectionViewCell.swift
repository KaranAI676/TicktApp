//
//  DynamicHeightCollectionViewCell.swift
//  Tickt
//
//  Created by S H U B H A M on 26/03/21.
//

import UIKit
import Foundation

class DynamicHeightCollectionView: UICollectionView {
    
    var forceLayoutOfSuperView: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.forceLayoutOfSuperView {
            self.superview?.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
}
