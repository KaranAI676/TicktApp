//
//  PhotoCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!

    var playButtonAction: (()->())?
    var crossButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case playButton:
            playButtonAction?()
        default:
            crossButtonAction?()
        }
    }
}

extension PhotoCell {
    private func configUI() {
        imageViewOutlet.cropCorner(radius: 3)
        imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
    }
}
