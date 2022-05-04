//
//  PhotoVC+CollectionView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

import TagCellLayout

extension PhotoVC: TagCellLayoutDelegate {
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        let size = CGSize(width: (layout.collectionView?.width ?? 300) / 3 , height: ((layout.collectionView?.width ?? 300) / 3) - 20)
        return size
    }
}

extension PhotoVC: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count < 6 {
            return imageArray.count + 1
        } else {
            return imageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(with: PhotoCell.self, indexPath: indexPath)
        if indexPath.row == imageArray.count {
            cell.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
            cell.crossButton.isHidden = true
            cell.playButton.isHidden = true
        } else {
            cell.crossButton.isHidden = false
            cell.playButton.isHidden = !(imageArray[indexPath.row].type == .video)
            cell.imageViewOutlet.image = imageArray[indexPath.row].image
        }
        cell.crossButtonAction = { [weak self] in
            self?.imageArray.remove(at: indexPath.row)
            if self?.imageArray.isEmpty ?? false {
                self?.submitPhotosButton.alpha = 0.1
                self?.submitPhotosButton.isUserInteractionEnabled = false
            }
            collectionView.reloadData()
        }
        cell.playButtonAction = { [weak self] in
            guard let self = self else { return }
            if self.imageArray[indexPath.row].videoUrl.isNotNil, let videoUrl = self.imageArray[indexPath.row].videoUrl {
                self.playTheVideo(videoUrl: videoUrl)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count <= 6 ,indexPath.row == imageArray.count {
            goToCommonPopupVC()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 20)  / 3, height: (collectionView.width - 20) / 3)
    }
}
