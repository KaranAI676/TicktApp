//
//  File.swift
//  Tickt
//
//  Created by Admin on 27/03/21.
//

import UIKit
import Foundation
import CoreLocation

extension TradieHomeVC: HomeDelegate, CustomLocationManagerDelegate {
   
    func didGetJobs(model: RecommmendedJobModel) {
        badgeCountLabel.text = model.result?.unreadCount?.stringValue
        badgeView.isHidden = (model.result?.unreadCount ?? 0) < 1
        if kUserDefaults.canPlayTutorial() {
            goToAppGuide()
        }
        refreshControl.endRefreshing()
        mainQueue { [weak self] in
            self?.homeTableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
        }
    }
    
    func accessDenied() {
        currentLocation = CLLocationCoordinate2D(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude())
        hitAPI(location: CLLocationCoordinate2D(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude()))
    }
    
    func accessRestricted() {
        currentLocation = CLLocationCoordinate2D(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude())
        hitAPI(location: CLLocationCoordinate2D(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude()))
    }
    
    func fetchLocation(location: CLLocation) {
        currentLocation = location.coordinate
        hitAPI(location: location.coordinate)
    }
    
    func hitAPI(location: CLLocationCoordinate2D, isPullToRefresh: Bool = false) {
        switch kUserDefaults.getUserType() {
        case 1:
            viewModel.getRecommendedJobs(location: location, showLoader: !isPullToRefresh, isPullToRefresh: isPullToRefresh)
        case 2:
            viewModel.getHomeData(location: location)
        default:
            break
        }
    }

    func successBuilder(model: BuilderHomeModel) {
        refreshControl.endRefreshing()
        homeBuilderModel = model
        badgeCountLabel.text = model.result.unreadCount.stringValue
        badgeView.isHidden = model.result.unreadCount < 1
        if kUserDefaults.canPlayTutorial() {
            goToAppGuide()
        }
        mainQueue { [weak self] in
            self?.homeTableView.reloadData {
                self?.homeTableView.reloadData {
                    self?.homeTableView.reloadData()
                }
            }
        }
    }
    
    func didGetJobTypes(jobModel: JobModel) {
        refreshControl.endRefreshing()
        if self.jobModel.isNil {
            self.jobModel = jobModel
            mainQueue { [weak self] in
                self?.homeTableView.reloadData()
            }
        } else {
            delay(time: 1.0) { [weak self] in
                self?.homeTableView.reloadData()
            }
        }
    }
    
    func failure(error: String) {
        refreshControl.endRefreshing()
    }
    
    func successTradies(model: TradeModel) {
        refreshControl.endRefreshing()
        self.tradeModel = model
        mainQueue { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
}

extension TradieHomeVC: SelectJobDelegate {
    func didJobSelected(index: Int) {
        kAppDelegate.searchModel.jobTypes.append(jobModel?.result?.resultData![index].id ?? "")
        goToMapVC(nearBySearch: false)
    }
}
