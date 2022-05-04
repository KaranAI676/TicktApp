//
//  MilestoneDeclineCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/06/21.
//

import UIKit

class MilestoneDeclineCell: UITableViewCell {
    
    var imageArray: [String]? {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var resonLabel: CustomRomanLabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        photoCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}


extension MilestoneDeclineCell: CollectionDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: PhotoCollectionCell.self, indexPath: indexPath)
        cell.urlString = imageArray![indexPath.item]
        return cell        
    }
}
