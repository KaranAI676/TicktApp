//
//  ItemListController.swift
//  Tickt
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit

class ItemListController: BaseVC {
        
    var searchModel = SearchModel()
    let viewModel = ItemListViewModel()
    var updateItemList: ((_ itemDataModelList: SearchResultModel) -> Void)? = nil
    var isStatusBarHidden: Bool = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())

    
    @IBOutlet weak var itemListView: ItemListView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
        
    private func initialSetUp() {
        viewModel.delegate = self
//        itemListView.listTableView.addSubview(refreshControl)
        viewModel.tableViewOutlet = itemListView.listTableView
        itemListView.initialSetUp(delegate: self)
        action()
        hitPaginationClosure()
        viewModel.getSearchedResult(model: searchModel, showLoader: true, isPullToRefresh: false)
    }
    
    @objc func refreshData() {
        viewModel.getSearchedResult(model: searchModel, showLoader: false, isPullToRefresh: true)
    }
    
    private func action() {
        itemListView.itemViewActions = { [weak self] (actionType) in
            guard let self = self else { return }
            switch actionType {
            case .pullToRefresh:
                if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
                    self.viewModel.getSearchedResult(model: self.searchModel, showLoader: false, isPullToRefresh: false)
                } 
            }
        }
    }
    
    func hitPaginationClosure() {
        viewModel.hitPaginationClosure = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getSearchedResult(model: self.searchModel, showLoader: false, isPullToRefresh: false)
        }
    }
    
    private func getItemsTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SearchListCell.self, indexPath: indexPath)
        viewModel.hitPagination(index: indexPath.item)
        cell.job = viewModel.dataModel?.result![indexPath.item]
        cell.selectButton.isHidden = false
        cell.detailAction = { [weak self] in
            self?.goToJobDetail(indexPath: indexPath)
        }
        return cell
    }
    
    private func getEmptyDataTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: EmptyDataTableViewCell.self, indexPath: indexPath)
        cell.configCell(title: LS.noResultFound)
        return cell
    }
    
    private func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        if viewModel.isShowNoEmptyData {
            return itemListView.listTableView.bounds.height - 100
        }
        return (kScreenWidth - 48) * (270/327) + 24
    }
}

extension ItemListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension//heightForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension ItemListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isShowNoEmptyData {
            return 1
        }
        return viewModel.dataModel?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isShowNoEmptyData {
            return getEmptyDataTableViewCell(tableView, cellForRowAt: indexPath)
        }        
        return getItemsTableViewCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToJobDetail(indexPath: indexPath)
    }
    
    func goToJobDetail(indexPath: IndexPath) {
        guard let job = viewModel.dataModel?.result?[indexPath.row] else { return }
        let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
        jobDetailVC.screenType = .jobDetail
        jobDetailVC.jobId = job.jobId ?? ""
        jobDetailVC.tradeId = job.tradeId ?? ""
        jobDetailVC.specialisationId = job.specializationId ?? ""
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(jobDetailVC, animated: true)
        }
    }
}

extension ItemListController: ItemListViewModelDelegate {
    
    func didReceiveSuccess(message: String, model: SearchResultModel) {
        itemListView.listTableView.reloadData()
        itemListView.listTableView.hideBottomLoader()
        let count = model.result?.count ?? 0
        let countText = count > 0 ? count.description : LS.no
        let postString = count > 1 ? LS.results : LS.result
        let finalString = countText + " " + postString + " "
        itemListView.updateCountText(text: finalString)
        updateItemList?(model)
    }
            
    func didReceiveError(message: String) {
        itemListView.listTableView.reloadData()
        itemListView.listTableView.hideBottomLoader()
    }
}
