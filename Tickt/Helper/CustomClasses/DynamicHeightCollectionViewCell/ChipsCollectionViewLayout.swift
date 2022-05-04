//
//  ChipsCollectionViewLayout.swift
//  Tickt
//
//  Created by S H U B H A M on 26/03/21.
//

import UIKit
import Foundation

//MARK:- Delegate for chips collection flowlayout
//===============================================
protocol ChipsCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView:UICollectionView, itemSizeAt indexPath:NSIndexPath) -> CGSize
}

//MARK:- ChipsCollectionViewLayout
//================================
class ChipsCollectionViewLayout: UICollectionViewFlowLayout {
    
    // MARK:- Variables
    //=================
    private let interItemSpacing: CGFloat = 5.0
    private let lineSpacing: CGFloat = 5.0
    private var itemAttributesCache: Array<UICollectionViewLayoutAttributes> = []
    private var contentSize: CGSize = CGSize.zero
    weak var delegate: ChipsCollectionViewLayoutDelegate?
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    // MARK:- Lifecycle
    //=================
    override init() {
        super.init()
        scrollDirection = UICollectionView.ScrollDirection.vertical;
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = interItemSpacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = UICollectionView.ScrollDirection.vertical;
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = interItemSpacing
    }
    
    override func prepare() {
        super.prepare()
        
        if (collectionView?.numberOfSections == 0 ||
            collectionView?.numberOfItems(inSection: 0) == 0) {
            return
        }
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var iSize: CGSize = CGSize.zero
        
        var indexPath: NSIndexPath?
        let numberOfItems: NSInteger = (self.collectionView?.numberOfItems(inSection: 0))!
        itemAttributesCache = []
        
        for index in 0..<numberOfItems {
            indexPath = NSIndexPath(item: index, section: 0)
            iSize = (delegate?.collectionView(collectionView!, itemSizeAt: indexPath!))!
            
            var itemRect:CGRect = CGRect(x: x, y: y, width: iSize.width, height: iSize.height)
            if (x > 0 && (x + iSize.width + minimumInteritemSpacing > (collectionView?.frame.size.width)!)) {
                //...Checking if item width is greater than collection view width then set item in new row.
                itemRect.origin.x = 0
                itemRect.origin.y = y + iSize.height + minimumLineSpacing
            }
            
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath! as IndexPath)
            itemAttributes.frame = itemRect
            itemAttributesCache.append(itemAttributes)
            
            x = itemRect.origin.x + iSize.width + minimumInteritemSpacing
            y = itemRect.origin.y
        }
        
        y += iSize.height + self.minimumLineSpacing
        x = 0
        
        contentSize = CGSize(width: (collectionView?.frame.size.width)!, height: y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let numberOfItems:NSInteger = (self.collectionView?.numberOfItems(inSection: 0))!
        let itemAttributes = itemAttributesCache.filter {
            $0.frame.intersects(rect) &&
                $0.indexPath.row < numberOfItems
        }
        return itemAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributesCache.first {
            $0.indexPath == indexPath
        }
    }
}

class ChipsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var tempCellAttributesArray = [UICollectionViewLayoutAttributes]()
    let leftEdgeInset: CGFloat = 0
    let maximumSpacing: CGFloat = 16
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let cellAttributesArray = super.layoutAttributesForElements(in: rect)
        //Oth position cellAttr is InConvience Emoji Cell, from 1st onwards info cells are there, thats why we start count from 2nd position.
        if(cellAttributesArray != nil && cellAttributesArray!.count > 1) {
            for i in 1..<(cellAttributesArray!.count) {
                let prevLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray![i - 1]
                let currentLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray![i]
                
                let prevCellMaxX: CGFloat = prevLayoutAttributes.frame.maxX
                let collectionViewSectionWidth = self.collectionViewContentSize.width - leftEdgeInset
                let currentCellExpectedMaxX = prevCellMaxX + maximumSpacing + (currentLayoutAttributes.frame.size.width )
                if currentCellExpectedMaxX < collectionViewSectionWidth {
                    var frame: CGRect? = currentLayoutAttributes.frame
                    frame?.origin.x = prevCellMaxX + maximumSpacing
                    frame?.origin.y = prevLayoutAttributes.frame.origin.y
                    currentLayoutAttributes.frame = frame ?? CGRect.zero
                } else {
                    // self.shiftCellsToCenter()
                    currentLayoutAttributes.frame.origin.x = leftEdgeInset
                    //To Avoid InConvience Emoji Cell
                    if (prevLayoutAttributes.frame.origin.x != 0) {
                        currentLayoutAttributes.frame.origin.y = prevLayoutAttributes.frame.origin.y + prevLayoutAttributes.frame.size.height + maximumSpacing
                    }
                }
                // print(currentLayoutAttributes.frame)
            }
            //print("Main For Loop End")
        }
        // self.shiftCellsToCenter()
        return cellAttributesArray
    }
    
    func shiftCellsToCenter() {
        if (tempCellAttributesArray.count == 0) { return }
        let lastCellLayoutAttributes = self.tempCellAttributesArray[self.tempCellAttributesArray.count-1]
        let lastCellMaxX: CGFloat = lastCellLayoutAttributes.frame.maxX
        let collectionViewSectionWidth = self.collectionViewContentSize.width - leftEdgeInset
        let xAxisDifference = collectionViewSectionWidth - lastCellMaxX
        if xAxisDifference > 0 {
            for each in self.tempCellAttributesArray{
                each.frame.origin.x += xAxisDifference/2
            }
        }
    }
}

