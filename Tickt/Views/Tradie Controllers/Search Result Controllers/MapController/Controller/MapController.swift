//
//  MapController.swift
//  Tickt
//
//  Created by Tickt on 13/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapController: BaseVC {
    
    var isViewNearBy = false
    let viewModel = MapViewModel()
    private var childVC: ItemListController?
    var searchModel = kAppDelegate.searchModel
    weak var bookmarkDelegate: ItemDataBookmarkDelegate?
        
    @IBOutlet weak var mapView: MapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if isViewNearBy {
            fetchLocation()
        } else {
            initialSetup()
        }
    }
        
    func initialSetup() {
        
        if var viewController = navigationController?.viewControllers, viewController.count > 2 {
            let count = viewController.count
            var selectCount = 0
            for index in 1...(count - 2) {
                viewController.remove(at: index - selectCount)
                selectCount += 1
            }
            navigationController?.viewControllers = viewController
        }
                
        viewModel.delegate = self
        if viewModel.filterData.isFiltered {
            mapView.addBadgeView(countText: "0")
        } else {
            mapView.removeBadgeView()
        }
        mapView.initialSetUp(delegate: self)
        mapView.setSearchData(model: searchModel)
        addItemsController()
        action()
    }    
    
    func fetchLocation() {
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.requestLocatinPermission { (status) in
            if status {
                LocationManager.sharedInstance.startLocationUpdates()
            }
        }
    }
    
    deinit {
        childVC?.removeFromParent
        printDebug("\(LS.osClaimsItsMemoryByReleasing) \(description)")
    }
    
    private func action() {
        mapView.mapViewActions = { [weak self] (actionType) in
            switch actionType {
            case .back:
                if let vc = self?.navigationController?.viewControllers.first(where: { $0 is TabBarController}) {
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            case .filter:
                let filterVC = FilterVC.instantiate(fromAppStoryboard: .filter)
                filterVC.filterData = self?.viewModel.filterData ?? FilterData()
                filterVC.selectFilter = { [weak self] filters in
                    self?.getFilteredResult(filters)
                }//CountHarpreet
                self?.push(vc: filterVC)                
            case .calendar:
                self?.gotoCalendarScreen()
            case .location:
                self?.gotoSearchLocationController()
            case .dismissSheet:
                if self?.mapView.itemListView.getCurrentState != .close {
                    self?.mapView.itemListView.changeSheetState(nextState: .close, isAnimated: true)
                }
            }
        }
    }
    
    func getFilteredResult(_ filter: FilterData) {
        var count = 0
        if let sort = filter.sortBy , sort != .highestRated {
            if sort == .closestToMe {
                searchModel.location = filter.cordinates
                searchModel.locationName = filter.locationName
            } else if filter.locationName.isEmpty { // Not Selected the location also
                searchModel.location.removeAll()
            }
            searchModel.sortBy = sort
            count += 1
        } else {
            searchModel.sortBy = nil
        }
        
        if !filter.payType.isEmpty , !filter.price.isEmpty {
            searchModel.payType = filter.payType
            searchModel.maxBudget = Double.getDouble(filter.price)
            count += 1
        } else {
            searchModel.payType = ""
            searchModel.maxBudget = 0.0
        }
        
        if filter.isSliderMoved {
            searchModel.isSliderSelected = filter.isSliderMoved
            searchModel.payType = filter.payType
            searchModel.minBudget = Double(filter.minimumPrice)
            searchModel.maxBudget = Double(filter.maximumPrice)
        } else {
            searchModel.isSliderSelected = false
            searchModel.payType = filter.payType
            searchModel.minBudget = 1.0
            searchModel.maxBudget = 1000
        }
        
        if !filter.jobType.result.resultData.isEmpty {
            searchModel.jobTypes = filter.jobType.result.resultData.map{$0.id}
            count += 1
        } else {
            searchModel.jobTypes = []
        }
        
        if filter.isOnlyTradeSelected { //Only Category Selected
            searchModel.tradeId = [ filter.trade?.id ?? ""]
            searchModel.specializationId.removeAll()
            searchModel.specializationName = filter.trade?.tradeName ?? LS.allAroundMe
            count += 1
        } else if filter.isAllSubCatSelected || filter.trade != nil { // All Specialization Selected or //Few Specialization selected
            searchModel.specializationId = filter.trade!.specialisations!.map {$0.id}
            if (filter.trade?.specialisations?.count ?? 0) > 1 {
                let count = (filter.trade?.specialisations?.count ?? 0) - 1
                searchModel.specializationName = (filter.trade?.specialisations?.first?.name ?? "") + "+ \(count) others"
            } else {
                searchModel.specializationName = filter.trade?.specialisations?.first?.name ?? LS.allAroundMe
            }
            count += 1
        } else {
            searchModel.tradeId = []
            searchModel.specializationId = []
            searchModel.specializationName = ""
        }
        viewModel.filterData = filter
        if count > 0 {
            mapView.addBadgeView(countText: "\(count)")
        } else {
            mapView.removeBadgeView()
        }
        hitAPI(model: searchModel)
    }
            
    private func gotoSearchLocationController() {
        let locationVC = TLocationVC.instantiate(fromAppStoryboard: .search)
        if searchModel.location.count > 0, searchModel.location[0] != 0.0 {
            locationVC.locationName = searchModel.locationName
            locationVC.locations = searchModel.location
        }
        locationVC.isComingFromSearch = true
        locationVC.didSelectLocation = { [weak self] (cordinates, address) in
            self?.searchModel.location = cordinates
            self?.searchModel.locationName = address            
            self?.hitAPI(model: self?.searchModel ?? SearchModel())
        }
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    private func gotoCalendarScreen() {
        let calendarVC = CalendarVC.instantiate(fromAppStoryboard: .jobPosting)
        calendarVC.isComingFromSearch = true
        calendarVC.screenType = .jobSearch
        calendarVC.didSelectDates = { [weak self] (fromDate, toDate) in
            self?.searchModel.fromDate = fromDate
            self?.searchModel.toDate = toDate
            self?.hitAPI(model: self?.searchModel ?? SearchModel())
        }
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(calendarVC, animated: true)
        }
    }
    
    private func hitAPI(model: SearchModel) {
        mapView.setSearchData(model: searchModel)
        if childVC.isNotNil {
            childVC?.viewModel.filterData = viewModel.filterData
            childVC?.searchModel = model
            childVC?.viewModel.pageNo = 1 //New search filter is applied so reset the page to 1
            childVC?.viewModel.getSearchedResult(model: model, showLoader: true, isPullToRefresh: false)
        }
    }
    
    private func updateChildVCData(needToReloadData: Bool) {
        if childVC.isNotNil {
            if ((viewModel.dataModel?.result?.isEmpty) != nil)  {
                mapView.itemListView.changeSheetState(nextState: .close, isAnimated: true)
            }
            childVC!.searchModel = searchModel
            childVC!.viewModel.dataModel = viewModel.dataModel
            let count = viewModel.dataModel?.result?.count ?? 0
            let countText = count > 0 ? count.description : LS.no
            let postString = count > 1 ? LS.results : LS.result
            let finalString = countText + " " + postString
            childVC!.viewModel.totalCountString = finalString
            childVC!.itemListView?.updateCountText(text: finalString)
            if needToReloadData {
                childVC!.itemListView?.listTableView?.reloadData()
            }
            if viewModel.needToUpdateData {
                mapView.canMapDismissBottomSheet = false
                mapView.updateMap(coordinates: viewModel.coordinates)
                viewModel.needToUpdateData = false
            }
        }
    }
    
    private func addItemsController() {
        if childVC.isNotNil {
            childVC?.searchModel = searchModel
            updateChildVCData(needToReloadData: true)
        } else {
            childVC = ItemListController.instantiate(fromAppStoryboard: .search)
            childVC?.searchModel = searchModel
            guard childVC.isNotNil else { return }
            updateChildVCData(needToReloadData: false)
            let popUpHeight = UIDevice.height - mapView.navBarBehindView.frame.maxY + 72
            let midHeight = popUpHeight/2.0
            add(childViewController: childVC!, containerView: mapView.itemListView)
            mapView.itemListView.setup(bottomConstraint: mapView.itemListBottomCons, heightConstraint: mapView.itemListViewHeightCons, conflictScrollView: childVC!.itemListView?.listTableView, swipeViewConfiguration: .init(initialState: .customOffset, popUpHeight: popUpHeight, midHeight: midHeight, offset: 76))
            childVC!.itemListView.listTableView.reloadData()
            mapView.itemListView.delegate = self
            childVC?.updateItemList = { [weak self] (itemDataModelList) in
                self?.mapView.isMapAddedInitialMarkers = false
                var object = SearchResultModel()
                object.message = "Success"
                object.statusCode = 200
                object.status = true
                object.result = []
                self?.viewModel.dataModel = object
                self?.viewModel.dataModel?.result?.append(contentsOf: itemDataModelList.result ?? [])
                if !(self?.viewModel.dataModel?.result?.isEmpty ?? false) {
                    self?.mapView.generateMarkers(itemsArr: self?.viewModel.dataModel?.result ?? [])
                } else {
                    self?.mapView.generateMarkers(itemsArr: self?.viewModel.dataModel?.result ?? [])
                    self?.mapView.itemListView.changeSheetState(nextState: .close, isAnimated: false)
                }
                self?.mapView.itemsCollectionView.reloadData()
            } 
        }
    }    
}

extension MapController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToJobDetail(indexPath: indexPath)
    }
    
    func goToJobDetail(indexPath: IndexPath) {
        if let model = viewModel.dataModel?.result?[indexPath.item] {
            let jobDetailVC = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
            jobDetailVC.screenType = .jobDetail
            jobDetailVC.jobId = model.jobId ?? ""
            jobDetailVC.tradeId = model.tradeId ?? ""
            jobDetailVC.specialisationId = model.specializationId ?? ""
            push(vc: jobDetailVC)
        }
    }
}

extension MapController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataModel?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: MapItemsCollectionViewCell.self, indexPath: indexPath)
        cell.job = viewModel.dataModel?.result![safe: indexPath.item]
        cell.cellAction = { [weak self] in
            self?.goToJobDetail(indexPath: indexPath)
        }
        return cell
    }        
}

extension MapController: MapViewModelDelegate {
    func didReceiveSuccess(message: String) {
        mapView.isMapAddedInitialMarkers = false
        mapView.itemsCollectionView.reloadData()
        addItemsController()
        if !(viewModel.dataModel?.result!.isEmpty ?? false) {
            mapView.generateMarkers(itemsArr: viewModel.dataModel?.result ?? [])
        } else {
            mapView.itemListView.changeSheetState(nextState: .close, isAnimated: false)
        }
    }
    
    func didReceiveError(message: String) {
//        viewModel.dataModel.nextPageHitSetUp()
    }
}


