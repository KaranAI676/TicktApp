//
//  ItemListView.swift
//  Tickt
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit

class ItemListView: UIView {
    
    enum ItemListViewAction {
        case pullToRefresh
    }
        
    var itemViewActions: ((ItemListViewAction) -> ())? = nil
        
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!        
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func initialSetUp(delegate: ItemListController) {
        tableViewSetup(delegate: delegate)
        handleView.cornerRadius = 2        
    }
    
    func updateCountText(text: String) {
        itemCountLabel.text = text
    }
    
    private func tableViewSetup(delegate: ItemListController) {
        listTableView.showsVerticalScrollIndicator = false
        listTableView.showsHorizontalScrollIndicator = false
        listTableView.delegate = delegate
        listTableView.dataSource = delegate
        listTableView.contentInset.bottom = UIDevice.bottomSafeArea + 24
        listTableView.registerCell(with: SearchListCell.self)
        listTableView.registerCell(with: EmptyDataTableViewCell.self)
        listTableView.backgroundColor = .clear
    }
    
    @objc func pullToRefresh() {
        itemViewActions?(.pullToRefresh)
    }
}
