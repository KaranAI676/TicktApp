//
//  tradeCollectionViewswift
//  Tickt
//
//  Created by S H U B H A M on 05/03/21.
//

import UIKit
import SDWebImage

class tradeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tradeNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
            
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
