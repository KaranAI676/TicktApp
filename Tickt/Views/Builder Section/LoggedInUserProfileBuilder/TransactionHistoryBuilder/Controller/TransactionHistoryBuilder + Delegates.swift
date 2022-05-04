//
//  TransactionHistoryBuilder + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation

extension TransactionHistoryBuilder: TransactionHistoryVMDelegate {
    
    func success(model: TransactionHistoryResultModel) {
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
