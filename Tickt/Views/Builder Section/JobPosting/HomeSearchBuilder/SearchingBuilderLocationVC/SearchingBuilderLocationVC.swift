//
//  SearchingBuilderLocationVC.swift
//  Tickt
//
//  Created by S H U B H A M on 28/04/21.
//

import UIKit
import GooglePlaces

class SearchingBuilderLocationVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var searchTextContainerView: UIView!
    @IBOutlet weak var subCategoryLabel: UILabel!
    
    //MARK:- Variables
    var screenType: ScreenType = .homeBuilderSearch
    var locationModel = JobLocation()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let locationModel = kAppDelegate.searchingBuilderModel?.location, locationModel.locationCanDisplay {
            self.searchField.text = locationModel.locationName
        }
        self.setupCategoryView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            self.backButtonAction()
        case skipButton:
            self.feedLocation(model: nil)
            self.goToCalendarVC()
        case locationButton:
            self.getCurrentLocation()
        case continueButton:
            self.continueButtonAction()
        default:
            break
        }
        disableButton(sender)
    }
}

extension SearchingBuilderLocationVC {
    
    private func initialSetup() {
        self.setupCategoryView()
        self.skipButton.isHidden = !(screenType == .homeBuilderSearch)
        self.searchField.delegate = self
    }
    
    private func setupCategoryView() {
        guard let searchContentModel = kAppDelegate.searchingBuilderModel else { return }
        var imageUrl = String()
        
        if searchContentModel.category.id != "" {
            imageUrl = searchContentModel.category.image ?? ""
            self.categoryLabel.text = searchContentModel.category.name
            self.subCategoryLabel.text = searchContentModel.category.tradeName
        }else if let model = searchContentModel.trade {
            imageUrl = model.selectedUrl ?? ""
            self.subCategoryLabel.text = model.tradeName
            if (model.specialisations?.count ?? 0) == kAppDelegate.searchingBuilderModel?.totalSpecialisationCount {
                self.categoryLabel.text = "All"
            }else {
                if (model.specialisations?.count ?? 0) == 0 {
                    self.categoryLabel.text = model.tradeName
                    self.subCategoryLabel.text = ""
                } else {
                    self.categoryLabel.text = (model.specialisations?.count ?? 0) > 1 ? ("\(model.specialisations?.first?.name ?? "") +\((model.specialisations?.count ?? 0)-1) more") : (model.specialisations?.first?.name ?? "")
                }
            }
        }else {
            self.searchTextContainerView.isHidden = true
            self.categoryLabel.text = ""
            self.subCategoryLabel.text = ""
        }
        categoryImageView.sd_setImage(with: URL(string:(imageUrl)), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
            self.categoryImageView.image = image
        }
        ///
        if let locationModel = kAppDelegate.searchingBuilderModel?.location {
            self.locationModel = locationModel
        }
    }
    
    private func getCurrentLocation() {
        CommonFunctions.showActivityLoader()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.requestLocatinPermission { (status) in
             if status {
                 LocationManager.sharedInstance.startLocationUpdates()
             }
         }
    }
    
    private func feedLocation(model: JobLocation?) {
        if let model = model {
            kAppDelegate.searchingBuilderModel?.location = model
        }else {
            kAppDelegate.searchingBuilderModel?.location = nil
            self.locationModel = JobLocation()
        }
    }
    
    private func goToCalendarVC() {
        let vc = CalendarVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .homeBuilderSearch
        vc.startDateToDisplay = Date()
        vc.endDateToDisplay = nil
        self.push(vc: vc)
    }
    
    private func backButtonAction() {
        switch screenType {
        case .homeBuilderSearch:
            self.feedLocation(model: nil)
            pop()
        case .homeBuilderSearchEdit:
            pop()
        default:
            break
        }
    }
    
    private func continueButtonAction() {
        switch screenType {
        case .homeBuilderSearch:
            self.feedLocation(model: locationModel)
            if let locationModel = kAppDelegate.searchingBuilderModel?.location, locationModel.locationName == "" || !locationModel.locationCanDisplay {
                CommonFunctions.showToastWithMessage("Please enter the location")
                return
            }
            self.goToCalendarVC()
        case .homeBuilderSearchEdit:
            self.feedLocation(model: locationModel)
            if let locationModel = kAppDelegate.searchingBuilderModel?.location, locationModel.locationName == "" || !locationModel.locationCanDisplay {
                CommonFunctions.showToastWithMessage("Please enter the location")
                return
            }
            pop()
        default:
            break
        }
    }
}

//MARK:- Google Maps Delegate
//===========================
extension SearchingBuilderLocationVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        searchField.text = place.formattedAddress ?? ""
        locationModel.locationName = place.name ?? ""
        locationModel.locationLat = place.coordinate.latitude
        locationModel.locationLong = place.coordinate.longitude
        locationModel.locationCanDisplay = true
        locationModel.isCurrentLocation = false
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
        
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Current Location: Delegates
//==================================
extension SearchingBuilderLocationVC: CustomLocationManagerDelegate {
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
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.searchField.text = address
            self.locationModel.locationName = address
            self.locationModel.locationLat = cordinates.latitude
            self.locationModel.locationLong = cordinates.longitude
            self.locationModel.locationCanDisplay = true
            self.locationModel.isCurrentLocation = true
        }
    }
}

//MARK:- UITextField: Delegate
//============================
extension SearchingBuilderLocationVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        return false
    }
}
