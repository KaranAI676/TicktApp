//
//  MapController+ScrollView.swift
//  Tickt
//
//  Created by Admin on 07/05/21.
//

extension MapController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView === mapView.itemsCollectionView else { return }
        let pageWidth = Float(mapView.flowLayout.itemSize.width + mapView.flowLayout.minimumLineSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(mapView.itemsCollectionView.contentSize.width)
        if let currentPage = mapView.itemsCollectionView.currentCenteredPage {
            var newPage = Float(currentPage)
            if velocity.x == 0 {
                newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
            } else {
                newPage = Float(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
                if newPage < 0 {
                    newPage = 0
                }
                if (newPage > contentWidth / pageWidth) {
                    newPage = ceil(contentWidth / pageWidth) - 1.0
                }
            }
            let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
            targetContentOffset.pointee = point
            mapView.visibleItemIndex = Int(newPage)
            if let model = viewModel.dataModel?.result![safe: Int(newPage)] {
                mapView.setSelectedMarker(of: model.jobId!)
            }
        }
    }
}

extension MapController: SwipeableViewDelegate {
    
    func pageViewStartScroll(_ state: SwipeableView.SwipeState) {
        mapView.canMapDismissBottomSheet = false
    }
    
    func willChangeState (_ fromState: SwipeableView.SwipeState,_ toState: SwipeableView.SwipeState) {
        if toState == .close {
            
        }
    }
    
    func didChangeState (_ state: SwipeableView.SwipeState) {

        var isNeedToAnimate = false
        if state == .open {
            if mapView.navBarHeightCons.constant != 48 {
                isNeedToAnimate = true
                self.mapView.navBarHeightCons.constant = 48
            }
        } else {
            if mapView.isMapAddedInitialMarkers {
                self.mapView.updateGmapCamera()
            }

            if mapView.navBarHeightCons.constant != 96 {
                isNeedToAnimate = true
                self.mapView.navBarHeightCons.constant = 96
            }
        }
        if isNeedToAnimate {
            UIView.animate(withDuration: 0.33) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func pageViewDidScroll (_ state: SwipeableView.SwipeState, _ visiblePercentageOfSheet: CGFloat) {        
        if visiblePercentageOfSheet > 0.8 {
            if mapView.navBarHeightCons.constant != 48 {
                mapView.navBarHeightCons.constant = 48
                UIView.animate(withDuration: 0.33) {
                    self.view.layoutIfNeeded()
                }
            }
        } else if visiblePercentageOfSheet < 0.8 {
            if mapView.navBarHeightCons.constant != 96 {
                mapView.navBarHeightCons.constant = 96
                UIView.animate(withDuration: 0.33) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

