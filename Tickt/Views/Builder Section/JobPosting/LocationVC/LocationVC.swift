//
//  LocationVC.swift
//  Tickt
//
//  Created by S H U B H A M on 18/03/21.
//

import UIKit
import GooglePlaces

class LocationVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    /// TextFields
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    /// Buttons
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var completeAddress: String = "" {
        didSet {
            self.locationTextField.text = completeAddress
        }
    }
    var screenType: ScreenType = .creatingJob
    let locationManager = CLLocationManager()
    var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            if screenType == .creatingJob {
              //  kAppDelegate.postJobModel?.jobLocation = JobLocation()
                self.pop()
            }
            else {
                self.pop()
            }
        case currentLocationButton:
            CommonFunctions.showActivityLoader()
            LocationManager.sharedInstance.delegate = self
            LocationManager.sharedInstance.requestLocatinPermission { (status) in
                 if status {
                     LocationManager.sharedInstance.startLocationUpdates()
                 }
             }
        case continueButton:
            if validate() {
                self.goToJobDescpVC()
            }
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension LocationVC {
    
    private func initialSetup() {
        locationTextField.delegate = self
        locationTextField.placeholderColor(color: #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1))
        if screenType == .republishJob || screenType == .editQuoteJob || screenType == .creatingJob {
            completeAddress = kAppDelegate.postJobModel?.jobLocation.locationName ?? ""
            self.coordinates.longitude = kAppDelegate.postJobModel?.jobLocation.locationLong ?? 0
            self.coordinates.latitude = kAppDelegate.postJobModel?.jobLocation.locationLat ?? 0
            locationTextField.text = self.completeAddress
        }
    }
    
    private func goToJobDescpVC() {
        let vc = JobDescriptionVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = screenType
        self.push(vc: vc)
    }
}

//MARK:-
extension LocationVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        ///
        filter.country = "AU"
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        return false
    }
}

//MARK:- Google Autocomplete Delegate Extension
//=============================================
extension LocationVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
//        if ((kUserDefaults.getMellbourneCoordinates().distance(from: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)))/1000) <= 1000 {
//
//        }
        self.completeAddress = place.formattedAddress ?? ""
        self.coordinates = place.coordinate
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension LocationVC: CustomLocationManagerDelegate {
    
    func accessDenied() {
        CommonFunctions.hideActivityLoader()
        AppRouter.openSettings(self)
    }
    
    func accessRestricted() {
        CommonFunctions.hideActivityLoader()
        AppRouter.openSettings(self)
    }
    
    func fetchLocation(location: CLLocation) {
        LocationManager.sharedInstance.getAddress(from: location) { [weak self] (address, cordinates) in
            CommonFunctions.hideActivityLoader()
            guard let self = self else { return }
            location.fetchCityAndCountry(completion: { city, country, error in
                if error == nil {
                    if country?.lowercased() == CommonStrings.australia.lowercased() {
                        self.completeAddress = address
                        self.coordinates = cordinates
                    } else {
                        CommonFunctions.showToastWithMessage("Uh oh! we don't provide service currently in your location")
                    }
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong")
                }
            })
        }
    }
}

extension LocationVC {
    
    private func validate() -> Bool {
        if self.completeAddress.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter the location")
            return false
        }else {
            kAppDelegate.postJobModel?.jobLocation.locationName = self.completeAddress
            kAppDelegate.postJobModel?.jobLocation.locationLong = self.coordinates.longitude
            kAppDelegate.postJobModel?.jobLocation.locationLat = self.coordinates.latitude
        }
        return true
    }
}

extension UITextField {
    
    func placeholderColor(color: UIColor, font: UIFont? = nil) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font ?? self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
