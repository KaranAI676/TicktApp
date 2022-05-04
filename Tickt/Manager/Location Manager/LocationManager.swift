//
//  LocationManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationManagerDelegate : class {
    func didChangeInAuthorization(_ status: CLAuthorizationStatus)
}

let SharedLocationManager = LocationController.sharedLocationManager

class LocationController : NSObject, CLLocationManagerDelegate {
    
    static let sharedLocationManager = LocationController()
    
    fileprivate var locationUpdateCompletion : ((CLLocation)->Void)?
    
    fileprivate var locationUpdateFailure : ((Error)->Void)?
    
    let locationManager = CLLocationManager()
    
    var currentLocation : CLLocation!
    
    /// Device location
    var locationsEnabled : Bool {
        
        if( CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied) {
            
            return true
            
        } else {
            
            return false
        }
    }
    
    weak var delegate : LocationManagerDelegate?
    
    fileprivate override init() {
        
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = CLActivityType.otherNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 500.0
    }
    
    func fetchCurrentLocation(_ completion : @escaping (CLLocation)->Void) {
        LocationController.sharedLocationManager.locationManager.stopUpdatingLocation()
        locationUpdateCompletion = completion
        getCurrentLocation()
    }
    
    func nilLocationUpdateComplition() {
        self.locationUpdateCompletion = nil
    }
    
    func fetchLocationError(_ failure : @escaping (Error)->Void) {
        self.locationUpdateFailure = failure        
    }
    
    func fetchCurrentAddress( _ completion: @escaping (String) -> Void) {
        LocationController.sharedLocationManager.locationManager.stopUpdatingLocation()
        LocationController.sharedLocationManager.fetchCurrentLocation { (location) in
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                
                guard let placemark = placemarks?[0] else {
                    printDebug("Reverse geocoder failed with error")
                    return
                }
                let address = "\(placemark.name ?? ""), \(placemark.country ?? "")"
                completion(address)
            })
        }
    }
    
    fileprivate func getCurrentLocation() {
        
        if self.locationsEnabled {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
                self.locationUpdateFailure?(NSError(code: 401, localizedDescription: "Location not enabled"))
            } else {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printDebug(error.localizedDescription)
        self.locationUpdateFailure?(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.currentLocation = lastLocation
            if let _ = self.locationUpdateCompletion {
                self.locationManager.stopUpdatingLocation()
                self.locationUpdateCompletion?(locations.last!)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationManager.stopUpdatingLocation()
        switch status {
            
        case .denied:   delegate?.didChangeInAuthorization(.denied)
        printDebug("No Location access")
            
        case .restricted:   delegate?.didChangeInAuthorization(.restricted)
        printDebug("No Location access")
            
        case .notDetermined:    delegate?.didChangeInAuthorization(.notDetermined)
        printDebug("Location not determined")
            
        case .authorizedAlways: delegate?.didChangeInAuthorization(.authorizedAlways)
        printDebug("Location Access")
            
        case .authorizedWhenInUse: delegate?.didChangeInAuthorization(.authorizedWhenInUse)
        printDebug("Location Access")
            
        @unknown default:
            delegate?.didChangeInAuthorization(status)
        }
    }
    
    static func getlocationFromManager(_ location: CLLocation, completion: @escaping ((_ placemark: CLPlacemark?, _ error: Error?) -> Void)) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error)-> Void in
            
            if (error != nil) {
                printDebug("Reverse geocoder failed with error" + (error?.localizedDescription)!)                
                let error = NSError.init(code: -10101, localizedDescription: "Reverse geocoder failed with error" + (error?.localizedDescription ?? ""))
                completion(nil, error)
                return
            }
            
            if let safePlacemark = placemarks?.first {
                completion(safePlacemark, nil)
            } else {
                printDebug("Problem with the data received from geocoder")
                let error = NSError.init(code: -10101, localizedDescription: "Problem with the data received from geocoder")
                completion(nil, error)
            }
        })
    }
    
    func getlocationDataFromManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                printDebug("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if let placemark = placemarks?.first {
                let _ = self.locationInfoData(placemark)
            } else {
                printDebug("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationInfoData(_ placemark: CLPlacemark) -> LocationInfoData {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        let locality = placemark.locality ?? ""
        let postalCode = placemark.postalCode ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""
        let country = placemark.country ?? ""
        return LocationInfoData.init(locality: locality, postalCode: postalCode, administrativeArea: administrativeArea, country: country, location: placemark.location)
    }

}

struct LocationInfoData {
    let locality: String
    let postalCode: String
    let administrativeArea: String
    let country: String
    let location: CLLocation?
}

extension NSError {
    
    /// Method to check is network connection error comes
    ///
    /// - Returns: False when network connection error occured
    ///
    func isNetworkConnectionError() -> Bool {
        let networkErrors = [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet]
        if self.domain == NSURLErrorDomain && networkErrors.contains(self.code) {
            return true
        }
        return false
    }
    
    convenience init(localizedDescription: String) {
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription.capitalizedFirst])
    }
    
    convenience init(code: Int, localizedDescription: String) {
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription.capitalizedFirst])
    }
}
