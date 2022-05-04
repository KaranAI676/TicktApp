//
//  PhotoCollectionCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/06/21.
//

import SDWebImage

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var urlString: String? {
        didSet {
            photoImageView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
