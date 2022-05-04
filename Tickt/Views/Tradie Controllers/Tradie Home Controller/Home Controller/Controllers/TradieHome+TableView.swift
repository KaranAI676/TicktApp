//
//  TradieHomeVC + TableView.swift
//  Tickt
//
//  Created by Admin on 25/03/21.
//

import UIKit
import Foundation

extension TradieHomeVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch cellArray[section] {
        case .topSection:
            return CGFloat.leastNormalMagnitude
        case .jobs, .recommentedJobs:
            return 45
        case .categories, .savedTradies:
            return CGFloat.leastNonzeroMagnitude
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch cellArray[section] {
        case .topSection:
            return nil
        case .jobs:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.defaultReuseIdentifier) as? SearchHeaderView else {
                return UIView()
            }
            headerView.backView.backgroundColor = UIColor(hex: "#F7F8FA")
            headerView.headerLabel.text = "Jobs"
            return headerView
        case .recommentedJobs:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.defaultReuseIdentifier) as? SearchHeaderView else {
                return UIView()
            }
            headerView.backView.backgroundColor = UIColor(hex: "#F7F8FA")
            headerView.headerLabel.text = "Recommended jobs"
            return headerView
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch cellArray[section] {
        case .topSection, .jobs, .categories:
            return 1
        case .savedTradies:
            return self.homeBuilderModel?.result.savedTradespeople.count ?? 0 > 0 ? 1 : 0
        case .recommentedJobs:
            return viewModel.recommendedModel?.result?.recomendedJobs?.count ?? 0
        case .recommendedTradespeople:
            return homeBuilderModel?.result.recomendedTradespeople.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellArray[indexPath.section] {
        case .topSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewNearByCell.defaultReuseIdentifier, for: indexPath) as? ViewNearByCell else {
                return UITableViewCell()
            }
            cell.populateUI(userType: kUserDefaults.getUserType())
            cell.buttonClosureBuilder = { [weak self] in
                guard let self = self else { return }
                kAppDelegate.searchingBuilderModel = SearchingContentsModel()
                self.goToSearchedResultVC(true)
            }
            cell.buttonClosureTradie = { [weak self] in
                self?.goToMapVC(nearBySearch: true)
            }
            return cell
        case .jobs:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: JobTypeCell.defaultReuseIdentifier, for: indexPath) as? JobTypeCell else {
                return UITableViewCell()
            }
            cell.delegate = self            
            cell.jobs = jobModel?.result?.resultData
            cell.jobCollectionView.reloadData()
            return cell
        case .recommentedJobs:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.defaultReuseIdentifier, for: indexPath) as? SearchListCell else {
                return UITableViewCell()
            }
            viewModel.hitPagination(index: indexPath.row, screenType: .recommentedJobs)
            cell.job = viewModel.recommendedModel?.result?.recomendedJobs![indexPath.row]
            return cell
        case .categories:
            let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
            cell.populateUI(title: "Categories", dataArray: self.tradeModel?.result?.trade)
            cell.editBackView.isHidden = false
            cell.collectionVIewHeightConst.constant = 120
            cell.editButton.setTitle("All", for: .normal)
            cell.setClearBg()
            cell.topConstraint.constant = 10
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToSearchingVC()
            }
            cell.modelUpdateClosure = { [weak self] (bool, index) in
                guard let self = self else { return }
                self.setSelectedTrades(index: index)
                kAppDelegate.searchingBuilderModel = SearchingContentsModel()
                kAppDelegate.searchingBuilderModel?.category = SearchedResultData()
                kAppDelegate.searchingBuilderModel?.trade = self.tradeModel?.result?.trade![index]
                kAppDelegate.searchingBuilderModel?.totalSpecialisationCount = self.tradeModel?.result?.trade![index].specialisations?.count ?? 0
                self.goToSearchedResultVC()
            }
            return cell
        case .savedTradies:
            let cell = tableView.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
            guard let model = self.homeBuilderModel else { return UITableViewCell() }
            cell.populateUI(title: "Saved tradies", saveTradies: model.result.savedTradespeople)
            cell.collectionVIewHeightConst.constant = 230
            cell.stackViewOutlet.spacing = 16
            cell.setClearBg()
            cell.editBackView.isHidden = false
            cell.editButton.setTitle("All", for: .normal)
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToViewAllSavedTradies()
            }
            cell.saveTradieClosure = { [weak self] index in
                guard let self = self else { return }
                if let tradieId = self.homeBuilderModel?.result.savedTradespeople[index.row].tradieId {
                    self.goToTradieVC(tradieId: tradieId)
                }
            }
            return cell
        case .recommendedTradespeople:
            let cell = tableView.dequeueCell(with: TradePeopleTableCell.self)
            cell.tableView = tableView
            cell.titleLabel.isHidden = !(indexPath.row == 0)
            cell.extraTradeCellSize = CGSize(width: (71), height: 32)
            cell.extraSpecCellSize = CGSize(width: (16), height: 32)
            ///
            guard let model = self.homeBuilderModel else { return UITableViewCell() }
            
            if let specialisationArray: [BuilderHomeSpecialisation] = CommonFunctions.getCountedSpecialisations(dataArray: model.result.recomendedTradespeople[indexPath.row].specializationData) as? [BuilderHomeSpecialisation] {
                cell.populateUI(title: "Recomended tradespeople", dataArrayTrade: model.result.recomendedTradespeople[indexPath.row].tradeData, dataArraySpecialisation: specialisationArray)
            }
            cell.userNameLabel.text = model.result.recomendedTradespeople[indexPath.row].tradieName
            cell.lblRole.text = model.result.recomendedTradespeople[indexPath.row].tradeData.first?.tradeName
            cell.lblCompanyName.text = model.result.recomendedTradespeople[indexPath.row].businessName
            cell.ratingLabel.text = "\(model.result.recomendedTradespeople[indexPath.row].ratings), \(model.result.recomendedTradespeople[indexPath.row].reviews) reviews"
            
            cell.profileImageVIew.sd_setImage(with: URL(string: model.result.recomendedTradespeople[indexPath.row].tradieImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            cell.buttonClosure = { [weak self] (index) in
                guard let self  = self else { return }
                if let tradieId = self.homeBuilderModel?.result.recomendedTradespeople[index.row].tradieId {
                    self.goToTradieVC(tradieId: tradieId)
                }
            }
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellArray[indexPath.section] {
        case .recommentedJobs:
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            jobDetailVC.screenType = .jobDetail
            jobDetailVC.jobId = viewModel.recommendedModel?.result?.recomendedJobs![indexPath.row].jobId ?? ""
            jobDetailVC.tradeId = viewModel.recommendedModel?.result?.recomendedJobs![indexPath.row].tradeId ?? ""
            jobDetailVC.specialisationId = viewModel.recommendedModel?.result?.recomendedJobs![indexPath.row].specializationId ?? ""
            push(vc: jobDetailVC)            
        default:
            print("\(cellArray[indexPath.section].hashValue)")
        }
    }
    
    func goToMapVC(nearBySearch: Bool) {
        let mapVC = MapController.instantiate(fromAppStoryboard: .search)
        mapVC.isViewNearBy = nearBySearch
        push(vc: mapVC)
    }
}

extension TradieHomeVC {
    
    private func setSelectedTrades(index: Int) {
        for eachTradeIndex in 0..<(tradeModel?.result?.trade?.count ?? 0) {
            for eachSpecIndex in 0..<(self.tradeModel?.result?.trade?[eachTradeIndex].specialisations?.count ?? 0) {
                self.tradeModel?.result?.trade?[eachTradeIndex].specialisations?[eachSpecIndex].isSelected = eachTradeIndex == index
            }
        }
    }
    
    private func goToSearchedResultVC(_ searchNow: Bool = false) {
        let vc = SearchedResultBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        vc.isComingFromSearchNow = searchNow
        self.push(vc: vc)
    }
    
    private func goToSearchingVC() {
        let vc = SearchingBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        self.push(vc: vc)
    }
    
    private func goToTradieVC(tradieId: String) {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.tradieId = tradieId
        vc.showSaveUnsaveButton = true
        self.push(vc: vc)
    }
}
