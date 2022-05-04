//
//  TLocation+GMSDelegate.swift
//  Tickt
//
//  Created by Admin on 31/03/21.
//

import Foundation
import GooglePlaces

extension TLocationVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        searchField.text = place.formattedAddress ?? ""
        if isComingFromSearch {
            locationName = place.name ?? ""
            locations = [place.coordinate.latitude, place.coordinate.longitude]
        } else {
            kAppDelegate.searchModel.locationName = place.name ?? ""
            kAppDelegate.searchModel.location = [place.coordinate.latitude, place.coordinate.longitude]
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
        
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension TLocationVC: CustomLocationManagerDelegate {
    
    func showLocationAlert() {        
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                             alertTitle: "Location Permission",
                                             alertMessage: LS.changePrivacySettingAndAllowAccessToLocation.localized(),
                                             acceptButtonTitle: "Settings",
                                             declineButtonTitle: "Cancel") {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } dismissCompletion: {
            
        }
    }
    
    func accessDenied() {
        showLocationAlert()
    }
    
    func accessRestricted() {
        showLocationAlert()
    }
    
    func fetchLocation(location: CLLocation) {
        LocationManager.sharedInstance.getAddress(from: location) { [weak self] (address, cordinates) in
            self?.searchField.text = address
            if self?.isComingFromSearch ?? false {
                self?.locations = [cordinates.latitude, cordinates.longitude]
                self?.locationName = address
            } else {
                kAppDelegate.searchModel.locationName = address
                kAppDelegate.searchModel.location = [cordinates.latitude, cordinates.longitude]
            }
        }
    }
}

