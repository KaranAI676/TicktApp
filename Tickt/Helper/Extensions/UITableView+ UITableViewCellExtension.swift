//
//  UITableViewExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

typealias TableDelegate = UITableViewDelegate & UITableViewDataSource

extension UITableView {
		
	func scrollToBottom() {
		DispatchQueue.main.async {
			let indexPath = IndexPath(
				row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
				section: self.numberOfSections - 1)
			self.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}
	
	func scrollToTop() {
		DispatchQueue.main.async {
			let indexPath = IndexPath(row: 0, section: 0)
			self.scrollToRow(at: indexPath, at: .top, animated: false)
		}
	}
    
    func reloadData(duration: TimeInterval = 0, completion:@escaping ()->()) {
        UIView.animate(withDuration: duration, animations: { self.reloadData() })
            { _ in completion() }
    }
    
    func reloadWithAnimation() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { () -> Void in
                            self.reloadData()
                            
                          },completion: nil)
    }
	
    ///Returns cell for the given item
    func cell(forItem item: Any) -> UITableViewCell? {
        if let indexPath = self.indexPath(forItem: item){
            return self.cellForRow(at: indexPath)
        }
        return nil
    }
    
    ///Returns the indexpath for the given item
    func indexPath(forItem item: Any) -> IndexPath? {
        let itemPosition: CGPoint = (item as AnyObject).convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: itemPosition)
    }
    
    func getIndexPath(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = convert(center, from: view.superview)
        let indexPath = indexPathForRow(at: viewCenter)
        return indexPath
    }

    ///Registers the given cell
    func registerClass(cellType:UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    ///dequeues a reusable cell for the given indexpath
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier , for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier). Ensure you have registered the cell." )
        }
        return cell
    }
    
    func indexPathForCells(inSection: Int, exceptRows: [Int] = []) -> [IndexPath] {
        let rows = self.numberOfRows(inSection: inSection)
        var indices: [IndexPath] = []
        for row in 0..<rows {
            if exceptRows.contains(row) { continue }
            indices.append([inSection, row])
        }
        return indices
    }
    
    ///Register Table View Cell Nib
    func registerCell(with identifier: UITableViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil),
                      forCellReuseIdentifier: "\(identifier.self)")
    }
    
    ///Register Header Footer View Nib
    func registerHeaderFooter(with identifier: UITableViewHeaderFooterView.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil), forHeaderFooterViewReuseIdentifier: "\(identifier.self)")
    }
    
    ///Dequeue Table View Cell
    func dequeueCell <T: UITableViewCell> (with identifier: T.Type, indexPath: IndexPath? = nil) -> T {
        if let index = indexPath {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)", for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)") as! T
        }
    }
    
    ///Dequeue Header Footer View
    func dequeueHeaderFooter <T: UITableViewHeaderFooterView> (with identifier: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(identifier.self)") as! T
    }
    
    func showEmptyScreen(_ message: String) {
        backgroundView = UIView(frame:CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 10, y: bounds.height/2 - 50 , width: bounds.size.width - 20, height: 100))
        noDataLabel.text = message
        noDataLabel.textColor = UIColor.black
        noDataLabel.font = UIFont.kAppDefaultFontBold(ofSize: 18)
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        backgroundView?.addSubview(noDataLabel)
        layoutIfNeeded()
    }
    
    func showBottomLoader(delegate: RetryButtonDelegate? = nil, isNetworkConnected: Bool = true) {
        if CommonFunctions.isConnectedToNetwork() && isNetworkConnected {
            guard !(self.tableFooterView?.isKind(of: UIActivityIndicatorView.self) ?? false) else { return }
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.isHidden = false
            spinner.color = AppColors.themeBlue
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
            self.tableFooterView = spinner
        }else {
            guard !(self.tableFooterView?.isKind(of: RetryButton.self) ?? false) else { return }
            let retryButton = RetryButton.init(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
            retryButton.delegate = delegate
            self.tableFooterView = retryButton
        }
        self.tableFooterView?.isHidden = false
    }
    
    func hideBottomLoader() {
        tableFooterView?.isHidden = true
        tableFooterView = nil
    }
}

extension UITableViewCell {
    public static var defaultReuseIdentifier: String {
        return "\(self)"
    }
    
    func disableButton(_ sender: UIButton) {
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.isEnabled = true
        }
    }        
}


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = AppFonts.NeueHaasDisplayMediu.withSize(14)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func setAnimatedBackView(_ imageName: UIImage, message: String){
        
        let tableViewBounds = self.bounds
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewBounds.size.width, height:  tableViewBounds.size.height))
        
        let imageView = UIImageView(image: imageName)
        let messageLabel = UILabel()
        
        backView.addSubview(imageView)
        backView.addSubview(messageLabel)
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = AppColors.borderColor
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2

        imageView.frame = CGRect(x: (backView.bounds.width/2 - 42), y: (backView.bounds.height/2 - 80), width: 65, height: 65)
        messageLabel.center = imageView.center
        messageLabel.frame = CGRect(x: 0, y: (backView.bounds.height/2 - 30), width: tableViewBounds.size.width - 20, height: 100)
        messageLabel.text = message

        self.backgroundView = backView
        imageView.shake()
        
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    func relaodDataWithAnimation(duration: TimeInterval = 0.33, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIView.transition(with: self, duration: duration, options: options, animations: { () -> Void in
            self.reloadData()
        }, completion: nil)
    }
}
