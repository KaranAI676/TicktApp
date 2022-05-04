//
//  IntroVC+CollectionView.swift
//  Tickt
//
//  Created by Admin on 08/03/21.
//

import UIKit

extension IntroVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntrolCell.defaultReuseIdentifier, for: indexPath) as? IntrolCell else {
            return UICollectionViewCell()
        }
        cell.topConstraint.constant = UIDevice.height/2 - 50
        cell.introImageView.image = UIImage(named: imageArray[indexPath.row].image)
        cell.descriptionLabel.text = imageArray[indexPath.row].descp
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: kScreenHeight)
    }
}

extension IntroVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    } 
}
