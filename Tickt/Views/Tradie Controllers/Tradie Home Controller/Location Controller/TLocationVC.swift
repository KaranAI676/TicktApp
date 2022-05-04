//
//  TLocationVC.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit
import GooglePlaces
import CoreLocation

class TLocationVC: BaseVC {
    
    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!        
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: CustomMediumLabel!
    @IBOutlet weak var subCategoryLabel: CustomRegularLabel!
    
    var locationName = ""
    var locations: [Double] = []
    var isComingFromSearch = false
    var category: SearchedResultData?
    var didSelectLocation: (([Double], String) -> Void)? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        if isComingFromSearch {
            skipButton.isHidden = true
            categoryView.isHidden = true
            searchField.text = locationName
        } else {
            skipButton.isHidden = false
            categoryView.isHidden = false
        }
        searchField.placeholderColor(color: #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1))
        categoryLabel.text = category?.name
        subCategoryLabel.text = category?.tradeName
        categoryImageView.sd_setImage(with: URL(string: category?.image ?? ""), placeholderImage: nil, options: .highPriority) { [weak self] (image, error, _ , _) in
            let resizedImage = image?.resized(toWidth: kScreenWidth * 0.5, isOpaque: false)
            self?.categoryImageView.backgroundColor = UIColor(hex: "#0B41A8")
            self?.categoryImageView.image = resizedImage
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case skipButton:
            searchField.text = ""
            kAppDelegate.searchModel.location.removeAll()
            goToCalendarVC()
        case locationButton:
            LocationManager.sharedInstance.delegate = self
            LocationManager.sharedInstance.requestLocatinPermission { (status) in
                if status {
                    LocationManager.sharedInstance.startLocationUpdates()
                }
            }
        case continueButton:
            if searchField.text!.isEmpty {
                CommonFunctions.showToastWithMessage(Validation.errorSelectLocation)
            } else {
                if isComingFromSearch {
                    didSelectLocation?(locations, locationName)
                    pop()
                } else {
                    goToCalendarVC()
                }
            }
        default:
            break
        }
        disableButton(sender)
    }
    
    private func goToCalendarVC() {
        let calendarVC = CalendarVC.instantiate(fromAppStoryboard: .jobPosting)
        calendarVC.category = category
        calendarVC.screenType = .jobSearch
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(calendarVC, animated: true)
        }
    }
    
}

extension TLocationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue) |
                                                    GMSPlaceField.addressComponents.rawValue |
                                                    GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "AU"
        autocompleteController.autocompleteFilter = filter
        
        mainQueue { [weak self] in
            self?.present(autocompleteController, animated: true, completion: nil)
        }        
        return false
    }
}
