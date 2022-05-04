//
//  PortfolioCollectionViewTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 13/06/21.
//

import UIKit

class PortfolioCollectionViewTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var pageControllerOutlet: UIPageControl!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Vairbles
    var portfolioImagesUrlModel: [(imageUrl: String?, image: UIImage?)]? {
        didSet {
            pageControllerOutlet.numberOfPages = portfolioImagesUrlModel?.count ?? 0
            collectionViewOutlet.reloadData()
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PortfolioCollectionViewTableCell {
    
    private func configUI() {
        pageControllerOutlet.currentPage = 0
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionViewOutlet.registerCell(with: PortfolioImageCollectionViewCell.self)
        ///
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.isPagingEnabled = true
    }
}

extension PortfolioCollectionViewTableCell: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioImagesUrlModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: PortfolioImageCollectionViewCell.self, indexPath: indexPath)
        cell.imageViewOutlet.cropCorner(radius: 3)
        ///
        if let imageUrl = portfolioImagesUrlModel?[indexPath.row].imageUrl {
            cell.imageViewOutlet.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .highPriority)
        }else if let image = portfolioImagesUrlModel?[indexPath.row].image {
            cell.imageViewOutlet.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth-48, height: 255)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControllerOutlet.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
