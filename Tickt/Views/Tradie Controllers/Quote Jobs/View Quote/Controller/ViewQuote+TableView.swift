//
//  ViewQuote+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/09/21.
//

import UIKit

extension ViewQuoteVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .addItem:
            return 0
        case .itemList:
            return itemList.count
        case .totalPrice:
            return itemList.count == 0 ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .addItem:
            return UITableViewCell()
        case .itemList:
            let cell = tableView.dequeueCell(with: ItemListCell.self)
            cell.itemDetail = itemList[indexPath.row]
            return cell
        case .totalPrice:
            let cell = tableView.dequeueCell(with: TotalPriceCell.self)
            let amount = itemList.map({$0.totalAmount}).reduce(0, +)
            let formattedAmount = String.getString(amount).commaSeprated()
            cell.totalPriceLabel.text = "Total Quote: \(formattedAmount)"
            return cell
        }
    }
}
