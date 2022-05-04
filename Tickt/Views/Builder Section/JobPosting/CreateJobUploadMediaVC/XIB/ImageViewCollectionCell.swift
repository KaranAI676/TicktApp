//
//  ImageViewCollectionCell.swift
//  Tickt
//
//  Created by S H U B H A M on 26/03/21.
//

class ImageViewCollectionCell: UICollectionViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var crossButtonClosure: ((IndexPath)->(Void))? = nil
    var playButtonClosure: ((IndexPath)->(Void))? = nil
    var collectionView: UICollectionView? = nil
//    var imageArrayModel: [UIImage]? = nil {
//        didSet {
//            self.populateUI()
//        }
//    }
    
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let collectionView = self.collectionView else { return }
        switch sender {
        case playButton:
            if let index = collectionViewIndexPath(collectionView) {
                self.playButtonClosure?(index)
            }
        default:
            if let index = collectionViewIndexPath(collectionView) {
                self.crossButtonClosure?(index)
            }
        }        
    }
}

extension ImageViewCollectionCell {
    
    private func configUI() {
        self.imageViewOutlet.cropCorner(radius: 3)
        self.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
    }
    
    private func populateUI() {
        
    }
}
