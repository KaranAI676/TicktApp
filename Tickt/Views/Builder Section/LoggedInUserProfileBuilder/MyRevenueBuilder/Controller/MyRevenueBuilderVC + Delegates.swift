//
//  MyRevenueBuilderVC + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import Foundation

extension MyRevenueBuilderVC: MyRevenueBuilderVMDelegate {
    
    func success(model: MyRevenueBuilderResultModel) {
        self.model = model
        tableViewOutlet.reloadData()
        refresher.endRefreshing()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        refresher.endRefreshing()
    }
}
