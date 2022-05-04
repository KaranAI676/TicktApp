//
//  SearchRevenue+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation

extension SearchRevenueVC: MyRevenueDelegate {
    func success(model: RevenueListResult) {
        self.model = model
        showActivityLoader(false)
        refresher.endRefreshing()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        showActivityLoader(false)
        refresher.endRefreshing()
    }
}
