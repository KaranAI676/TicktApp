//
//  SearchingTransactionHistoryVC + UIChangeMethods.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import Foundation

extension SearchingTransactionHistoryVC {
    
    func setupUIChnages(width: CGFloat) {
        setConstraints(width: width)
        if width > 0 { makeModelEmpty() }
        updateLayout()
        if width > 0 { refreshTableView() }
        showActivityLoader(width == 0)
    }
    
    func setConstraints(width: CGFloat) {
        widthConstraint.constant = width
        if width > 0 {
            searchImage.isHidden = false
            cancelSearchButton.isHidden = true
            
        }else {
            searchImage.isHidden = true
            cancelSearchButton.isHidden = false
        }
    }
    
    func makeModelEmpty() {
        searchText = ""
        searchField.text = ""
        model = nil
        arrayOfModel = []
    }
    
    func updateLayout() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }
    }
    
    func refreshTableView() {
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.tableViewOutlet.reloadData()
        }
    }
    
    func showActivityLoader(_ showLoader: Bool) {
        activityIndicatorOutlet.isHidden = !showLoader
        showLoader ? activityIndicatorOutlet.startAnimating() : activityIndicatorOutlet.stopAnimating()
    }
}
