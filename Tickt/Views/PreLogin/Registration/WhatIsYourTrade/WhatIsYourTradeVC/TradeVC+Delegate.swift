//
//  TradeVC+Delegate.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

import UIKit

extension WhatIsYourTradeVC: TradeDelegate {
    func success(data: TradeModel) {
        tradeModel = data
        if isEdit {
            for (index, trade) in (tradeModel?.result?.trade ?? []).enumerated() {
                if trade.id == kAppDelegate.signupModel.tradeList.first?.id {
                    tradeModel?.result?.trade?[index].isSelected = true
                }
            }
        }
        mainQueue { [weak self] in
            self?.collectionViewOutlet.reloadData()
        }        
    }
    
    func failure(error: String) {
        
    }
}
