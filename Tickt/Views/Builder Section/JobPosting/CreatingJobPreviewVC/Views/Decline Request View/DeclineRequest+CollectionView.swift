//
//  DeclineRequest+CollectionView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 02/07/21.
//


extension DeclineRequestView: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count < 6 {
            return imageArray.count + 1
        } else {
            return imageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(with: PhotoCell.self, indexPath: indexPath)
        cell.playButton.isHidden = true
        if indexPath.row == imageArray.count {
            cell.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
            cell.crossButton.isHidden = true
        } else {
            cell.crossButton.isHidden = false
            cell.imageViewOutlet.image = imageArray[indexPath.row].image
        }
        cell.crossButtonAction = { [weak self] in
            self?.imageArray.remove(at: indexPath.row)
            if self?.imageArray.isEmpty ?? false {
                self?.doneButton.alpha = 0.1
                self?.doneButton.isUserInteractionEnabled = false
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
        } else {
            let imagePreview = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
            imagePreview.image = imageArray[indexPath.row].image
            push(vc: imagePreview)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 20)  / 3, height: (collectionView.width - 20) / 3)
    }
}
