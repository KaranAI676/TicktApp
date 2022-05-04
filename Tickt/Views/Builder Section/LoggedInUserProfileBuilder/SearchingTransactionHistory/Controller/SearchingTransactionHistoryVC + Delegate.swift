//
//  SearchingTransactionHistoryVC + Delegate.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation

extension SearchingTransactionHistoryVC: TransactionHistoryVMDelegate {
    
    func success(model: TransactionHistoryResultModel) {
        if !searchText.isEmpty {
            self.model = model
        }
        showActivityLoader(false)
        refresher.endRefreshing()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        showActivityLoader(false)
        refresher.endRefreshing()
    }
}
