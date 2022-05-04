//
//  FilterVC+Location.swift
//  Tickt
//
//  Created by Admin on 05/05/21.
//

import UIKit
import CoreLocation

extension FilterVC: CreateJobVMDelegate {
    
    func success(data: TradeModel) {
        tradeModel = data
        if var tradeList = data.result?.trade {
            for (index, object) in tradeList.enumerated() {
                tradeList[index].specialisations?.insert(SpecializationModel(id: "1", status: 10, name: CommonStrings.all, tradeID: object.id, sortBy: 0, isSelected: false, isUploaded: false, docType: nil), at: 0)
            }
            tradeModel?.result?.trade = tradeList
        }
                
        if kUserDefaults.isTradie() {
            setDataForTradie()
        } else {
            setupPrefilledData()
        }
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func success(data: JobTypeModel) {
        if filterData.jobType.result.resultData.isEmpty {
            filterData.jobType = data
        } else { //Select all jobtypes
            var jobs = data.result.resultData
            for selectedJob in filterData.jobType.result.resultData {
                if let index = jobs.firstIndex(where: {$0.id == selectedJob.id}) {
                    jobs[index].isSelected = true
                }
            }
            filterData.jobType.result.resultData = jobs
        }
        mainQueue { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}

extension FilterVC: CustomLocationManagerDelegate {
    
    func getCurrentLocation() {
        CommonFunctions.showActivityLoader()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.requestLocatinPermission { (status) in
            if status {
                LocationManager.sharedInstance.startLocationUpdates()
            }
        }
    }
    
    func accessDenied() {
        CommonFunctions.hideActivityLoader()
        filterData.cordinates = []
        AppRouter.openSettings(self)
    }
    
    func accessRestricted() {
        CommonFunctions.hideActivityLoader()
        filterData.cordinates = []
        AppRouter.openSettings(self)
    }
    
    func fetchLocation(location: CLLocation) {
        LocationManager.sharedInstance.getAddress(from: location) { [weak self] (address, cordinates) in
            CommonFunctions.hideActivityLoader()
            guard let self = self else { return }
            if kUserDefaults.isTradie() {
                self.filterData.locationName = address
                self.filterData.cordinates = [location.coordinate.latitude, location.coordinate.longitude]
                if self.validateTradie() {
                    self.selectFilter?(self.filterData)
                    self.pop()
                }
            } else {
                var locationModel = JobLocation()
                locationModel.locationName = address
                locationModel.locationLat = cordinates.latitude
                locationModel.locationLong = cordinates.longitude
                self.filterBuilderModel?.location = locationModel
            }
        }
    }
}
