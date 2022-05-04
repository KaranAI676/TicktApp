//
//  UICollectionViewExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import UIKit

typealias CollectionDelegate = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension UICollectionView {
        
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.width/2 + self.contentOffset.x, y: self.contentOffset.y + self.height/2);
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
    
    ///Returns cell for the given item
    func cell(forItem item: AnyObject) -> UICollectionViewCell? {
        if let indexPath = self.indexPath(forItem: item){
            return self.cellForItem(at: indexPath)
        }
        return nil
    }
    
    ///Returns the indexpath for the given item
    func indexPath(forItem item: AnyObject) -> IndexPath? {
        let buttonPosition: CGPoint = item.convert(CGPoint.zero, to: self)
        return self.indexPathForItem(at: buttonPosition)
    }
    
    ///Registers the given cell
    func registerClass(cellType:UICollectionViewCell.Type){
        register(cellType, forCellWithReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    ///dequeues a reusable cell for the given indexpath
    func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier).  Ensure you have registered the cell" )
        }
        
        return cell
    }
    
    ///Register Collection View Cell Nib
    func registerReusableView(with identifier: UICollectionReusableView.Type, isHeader: Bool ) {
        let forSupplementaryViewOfKind: String = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: "\(identifier.self)")
    }
    
    ///Register Collection View Cell Nib
    func registerCell(with identifier: UICollectionViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forCellWithReuseIdentifier: "\(identifier.self)")
    }
    
    ///Dequeue Collection View Cell
    func dequeueCell <T: UICollectionViewCell> (with identifier: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T
    }
    
    public var currentCenteredPage: Int? {
        let currentCenteredPoint = CGPoint(x: self.contentOffset.x + self.bounds.width/2, y: self.contentOffset.y + self.bounds.height/2)
        
        return self.indexPathForItem(at: currentCenteredPoint)?.row
    }
}

extension UICollectionViewCell {
    public static var defaultReuseIdentifier: String {
        return "\(self)"
    }
}
