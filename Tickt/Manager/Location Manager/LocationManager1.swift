//
//  LocationManager.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/11/20.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import CoreLocation

protocol CustomLocationManagerDelegate  {
    func accessDenied()
    func accessRestricted()
    func fetchLocation(location:CLLocation)
}

class LocationManager: NSObject {
    
    static var sharedInstance = LocationManager()
    var locationManager = CLLocationManager()
    var startingPoint: String?
    var currentLocation: CLLocation?
    var delegate: CustomLocationManagerDelegate?
    var isFirstAttemp = true
    
    func requestLocatinPermission(completion: @escaping (_ status: Bool) -> ()) {
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.activityType = .other
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        guard CLLocationManager.locationServicesEnabled() else {
            completion(false)
            return
        }
        let status = CLLocationManager.authorizationStatus()
        checkLocationStatus(status: status) { (status) in
            completion(status)
        }
    }
    
    func checkLocationStatus(status:CLAuthorizationStatus, completion: @escaping (_ status: Bool) -> ()) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse :
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            completion(true)
        case .denied:
            isFirstAttemp = false
            delegate?.accessDenied()
            completion(false)
        case .notDetermined:
            isFirstAttemp = true
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            delegate?.accessRestricted()
            completion(false)
        @unknown default:
            Console.log("Do Nothing")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationStatus(status: status) { (_) in }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {            
            delegate?.fetchLocation(location: userLocation)
            stopLocationUpdates()
        }
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        startLocationUpdates()
    }
    
    func getAddress(from location: CLLocation, completion: @escaping (_ address: String, _ cordinates: CLLocationCoordinate2D) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                return
            }
            guard let placemarks = placemarks, let placemark = placemarks.first
                else {
                    return
            }
            let completeAddress = "\(placemark.name ?? ""), \(placemark.country ?? "")"
            print(completeAddress, location.coordinate)
            completion(completeAddress, location.coordinate)
        }
    }
}


