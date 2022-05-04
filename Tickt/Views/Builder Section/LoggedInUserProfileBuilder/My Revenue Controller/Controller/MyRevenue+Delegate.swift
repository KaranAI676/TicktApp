//
//  MyRevenue+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation

extension MyRevenueVC: MyRevenueDelegate {
    func success(model: RevenueListResult) {
        self.model = model
        totalCompletedJobs.text = model.totalJobs.stringValue
        totalEarningLabel.text = model.totalEarnings.stringValue.getFormattedPrice()
        refresher.endRefreshing()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        refresher.endRefreshing()
    }
}
