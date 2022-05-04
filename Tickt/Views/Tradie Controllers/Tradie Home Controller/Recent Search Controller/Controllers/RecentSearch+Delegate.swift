//
//  RecentSearch+Delegate.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit
import Foundation

extension RecentSearchVC: RecentSearchDelegate {
    
    func didDeletedRecentSearch(indexPath: IndexPath) {
        recentSearchModel?.result?.resultData?.remove(at: indexPath.row)
        mainQueue { [weak self] in
            self?.searchTableView.deleteRows(at: [indexPath], with: .left)
        }
        showWatermark()
    }
    
    func success(model: SearchedResultModel) {
        searchModel = model
        mainQueue { [weak self] in
            self?.searchTableView.reloadData()
        }
        showWatermark()
    }
    
    func didGetRecentSearch(model: RecentSearchModel) {
        recentSearchModel = model
        mainQueue { [weak self] in
            self?.searchTableView.reloadData()
        }
        showWatermark()
    }
    
    func showWatermark() {
        if isSearchEnabled {
            if (searchModel?.result?.count ?? 0) > 0 {
                hideWaterMarkLabel()
            } else {
                showWaterMarkLabel(message: "No record found")
            }
        } else {
            if (recentSearchModel?.result?.resultData?.count ?? 0) > 0 {
                hideWaterMarkLabel()
            } else {
                showWaterMarkLabel(message: "No record found")
            }
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
