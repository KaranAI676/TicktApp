//
//  ViewQuote+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/09/21.
//

import Foundation

extension ViewQuoteVC: ViewQuoteDelegate {
    
    func didGetQuotes(model: [ItemDetails]) {
        itemList = model
        let amount = itemList.map({$0.totalAmount}).reduce(0, +)
        let formattedAmount = String.getString(amount).commaSeprated()
        totalPriceLabel.text = "Total Quote: \(formattedAmount)"
        mainQueue { [weak self] in
            self?.quoteTableView.reloadData()
        }
    }    
}
