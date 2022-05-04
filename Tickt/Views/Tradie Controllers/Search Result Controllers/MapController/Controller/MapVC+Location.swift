//
//  MapVC+Location.swift
//  Tickt
//
//  Created by Admin on 30/04/21.
//

import CoreLocation

extension MapController: CustomLocationManagerDelegate {
    func accessDenied() {
        setLocation(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude())
    }
    
    func accessRestricted() {
        setLocation(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude())
    }
    
    func fetchLocation(location: CLLocation) {        
        setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        if searchModel.location.count == 2 {
            searchModel.location[0] = latitude
            searchModel.location[1] = longitude
        } else {
            searchModel.location.append(latitude)
            searchModel.location.append(longitude)
        }
        initialSetup()
    }
}
