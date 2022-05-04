//
//  MapView.swift
//  Tickt
//
//  Created by Tickt on 13/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapView: UIView {
    
    enum MapViewActions {
        case back
        case filter
        case calendar
        case location
        case dismissSheet
    }
        
    var visibleItemIndex = 0
    private var lastItemIndex = 0
    private var badgeView: UIView?
    var canMapDismissBottomSheet: Bool = false
    var isMapAddedInitialMarkers: Bool = false
    private var selectedMarker: GMSMarker? = nil
    let flowLayout = UICollectionViewFlowLayout()
    var mapViewActions: ((MapViewActions) -> Void)?
    private var markersDict: [String : GMSMarker] = [:]
    private (set) var newLocation: CLLocationCoordinate2D? = nil
        
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gmapView: GMSMapView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var navBarBehindView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var itemTitle: CustomRomanLabel!
    @IBOutlet weak var buttonsAndTitleView: UIView!
    @IBOutlet weak var itemListView: SwipeableView!
    @IBOutlet weak var navBarHeightCons: NSLayoutConstraint!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var itemListBottomCons: NSLayoutConstraint!
    @IBOutlet weak var itemListViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var itemsCollectionViewHeightCons: NSLayoutConstraint!
        
    weak var mapDelegate: MapController?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func initialSetUp(delegate: MapController) {
        mapDelegate = delegate
        buttonsAndTitleView.cropCorner(radius: 12.0, borderWidth: 1.0, borderColor: UIColor.lightText)
        navBar.addShadow(shadowColor: .lightGray, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.2, shadowRadius: 3)
        var cordinates = CLLocationCoordinate2D()
        if delegate.searchModel.location.count > 0 {
            cordinates = CLLocationCoordinate2D(latitude: delegate.searchModel.location[0], longitude: delegate.searchModel.location[1])
        } else {
            cordinates = CLLocationCoordinate2D(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude())
        }
        googleMapSetUp(coordinates: cordinates)
        collectionViewSetUp(delegate: delegate)
    }
    
    func setSearchData(model: SearchModel) {
        itemTitle.text = model.specializationName.isEmpty ? (model.tradeName.isEmpty ? LS.allAroundMe : model.tradeName) : model.specializationName
        if !model.fromDate.isEmpty ,!model.toDate.isEmpty {
            let fromDate = model.fromDate.toDateText(inputDateFormat: Date.DateFormat.yyyy_MM_dd.rawValue, outputDateFormat: Date.DateFormat.ddMMM.rawValue)
            let toDate = model.toDate.toDateText(inputDateFormat: Date.DateFormat.yyyy_MM_dd.rawValue, outputDateFormat: Date.DateFormat.ddMMM.rawValue)
            if model.fromDate.convertToDate(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue).year == model.toDate.convertToDate(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue).year {
                dateLabel.text = fromDate + " - " + toDate
            } else {
                dateLabel.text = model.fromDate.toDateText(inputDateFormat: Date.DateFormat.yyyy_MM_dd.rawValue, outputDateFormat: Date.DateFormat.MMMdyyyy.rawValue) + " - " + model.toDate.toDateText(inputDateFormat: Date.DateFormat.yyyy_MM_dd.rawValue, outputDateFormat: Date.DateFormat.MMMdyyyy.rawValue)
            }
        } else if !model.fromDate.isEmpty {
            dateLabel.text = model.fromDate.toDateText(inputDateFormat: Date.DateFormat.yyyy_MM_dd.rawValue, outputDateFormat: Date.DateFormat.ddMMM.rawValue)
        } else if !model.toDate.isEmpty {
            dateLabel.text = model.toDate.toDateText(inputDateFormat: Date.DateFormat.yyyy_MM_dd.rawValue, outputDateFormat: Date.DateFormat.ddMMM.rawValue)
        } else {
            dateLabel.text = "Add dates"
        }
        if model.locationName.isEmpty {
            locationLabel.text = "Add location"
        } else {
            locationLabel.text = model.locationName
        }
    }
    
    private func collectionViewSetUp(delegate: MapController) {
        itemsCollectionView.delegate = delegate
        itemsCollectionView.dataSource = delegate
        itemsCollectionView.registerCell(with: MapItemsCollectionViewCell.self)
        flowLayout.sectionInset = .init(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.sectionFootersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize.zero
        flowLayout.footerReferenceSize = CGSize.zero
        flowLayout.minimumLineSpacing = 8.0
        let heightByDevice = kScreenHeight * 104 / 812
        var height = heightByDevice > 156 ? 156 : heightByDevice
        height = height < 95 ? 95 : height
        let widthByDevice = kScreenWidth * 314 / 375
        let width = widthByDevice > 375 ? 375 : widthByDevice
        itemsCollectionViewHeightCons.constant = 156
        flowLayout.itemSize = CGSize(width: width, height: 156)
        itemsCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        itemsCollectionView.collectionViewLayout = flowLayout
        itemsCollectionView.setNeedsLayout()
    }
    
    private func googleMapSetUp(coordinates: CLLocationCoordinate2D?) {
        gmapView.mapStyle(withFilename: "SilverMapStyle", andType: "json")
        gmapView.delegate = self
        gmapView.settings.myLocationButton = false
//        gmapView.settings.consumesGesturesInView = true
        gmapView.isMyLocationEnabled = false
        gmapView.setMinZoom(1.0, maxZoom: 15.0)
        updateMap(coordinates: coordinates)
    }
    
    func updateMap(coordinates: CLLocationCoordinate2D? = nil) {
        gmapView.clear()
        if let _coordinates = coordinates {
            newLocation = _coordinates
            gmapView.camera = GMSCameraPosition.camera(withLatitude: _coordinates.latitude, longitude: _coordinates.longitude, zoom: 5)
        }
    }
        
    func generateMarkers(itemsArr: [RecommmendedJob], isAppendClusterItem: Bool = false) {
        if !isAppendClusterItem {
            lastItemIndex = 0
            markersDict.removeAll()
            gmapView.clear()
        }
        
        var lastIndex: Int = lastItemIndex
        for (index, item) in itemsArr.enumerated() {
            if let pickUpLocation = item.location?.coordinates {
                let location = CLLocationCoordinate2D(latitude: pickUpLocation[1], longitude: pickUpLocation[0])
                let markerView = PriceMapMarkerView(itemIndex: index + lastItemIndex, coordinate: location)
                let marker = GMSMarker(position: location)
                if index == 0 {
                    markerView.updateUI(isSelected: true)
                    marker.zIndex = 1
                }
                marker.map = gmapView
                marker.iconView = markerView
                marker.tracksViewChanges = false
                marker.tracksInfoWindowChanges = false
                markersDict[item.jobId!] = marker
                if index == 0 {
                    selectedMarker = marker
                }
                lastIndex = index
            }
        }
        lastItemIndex += lastIndex

        if !isAppendClusterItem, itemsArr.count > 0 {
            updateGmapCamera()
        } else {
            if markersDict.isEmpty {
                gmapView.clear()
                gmapView.padding = .zero
                if let delegate = mapDelegate, !delegate.searchModel.location.isEmpty {
                    if delegate.searchModel.location[0] == 0.0, delegate.searchModel.location[1] == 0.0 {
                        gmapView.animate(to: GMSCameraPosition(latitude: kUserDefaults.getUserLatitude(), longitude: kUserDefaults.getUserLongitude(), zoom: 13))
                    } else {
                        gmapView.animate(to: GMSCameraPosition(latitude: delegate.searchModel.location[0], longitude: delegate.searchModel.location[1], zoom: 13))
                    }
                } else  if let location = newLocation {
                    gmapView.animate(to: GMSCameraPosition(latitude: location.latitude, longitude: location.longitude, zoom: 13))
                }
            }
        }
    }
        
    func updateGmapCamera() {
        setMapPadding()
        var mapBounds = GMSCoordinateBounds()
        markersDict.forEach { (key, value) in
            mapBounds = mapBounds.includingCoordinate(value.position)
        }
        let update = GMSCameraUpdate.fit(mapBounds, withPadding: 0)
        isMapAddedInitialMarkers = true
        gmapView.animate(with: update)
    }
    
    private func setMapPadding() {
        var topPadding: CGFloat = 5
        let bottomPadding: CGFloat
        if itemListView.getCurrentState == .customOffset {
            topPadding = navBar.frame.minY + 10
            bottomPadding = (kScreenHeight - navBarBehindView.frame.maxY + 72)/2.0 + 20
        } else {
            topPadding = navBar.frame.maxY + 30
            bottomPadding = kScreenHeight - itemsCollectionView.frame.minY + 20
        }
        gmapView.padding = UIEdgeInsets(top: topPadding, left: 50, bottom: bottomPadding, right: 50)
    }
    
    func addBadgeView(countText: String) {
        removeBadgeView()
        badgeView = UIView()
        badgeView!.isUserInteractionEnabled = false
        badgeView!.backgroundColor = UIColor(hex: "#FEE600")
        navBar.addSubview(badgeView!)
        badgeView!.translatesAutoresizingMaskIntoConstraints = false
        badgeView!.layer.cornerRadius = 11
        NSLayoutConstraint.activate([
            badgeView!.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -28),
            badgeView!.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 5),
            badgeView!.heightAnchor.constraint(equalToConstant: 22),
            badgeView!.widthAnchor.constraint(equalToConstant: 22)
        ])
        let countLabel = UILabel()
        countLabel.backgroundColor = .clear
        countLabel.font = UIFont.kAppDefaultFontBold(ofSize: 14)
        countLabel.textColor = AppColors.themeBlue
        countLabel.text = countText
        countLabel.textAlignment = .center
        badgeView!.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.rightAnchor.constraint(equalTo: badgeView!.rightAnchor),
            countLabel.leftAnchor.constraint(equalTo: badgeView!.leftAnchor),
            countLabel.topAnchor.constraint(equalTo: badgeView!.topAnchor, constant: 0),
            countLabel.bottomAnchor.constraint(equalTo: badgeView!.bottomAnchor, constant: 0)
        ])
    }
    
    func removeBadgeView() {
        badgeView?.removeFromSuperview()
        badgeView = nil
    }
        
    @IBAction private func btnActions(_ sender: UIButton) {
        switch sender {
        case backButton:
            mapViewActions?(.back)
        case filterButton:
            mapViewActions?(.filter)
        case calendarButton:
            mapViewActions?(.calendar)
        case locationButton:
            mapViewActions?(.location)
        default:
            break
        }
    }
}

extension MapView: GMSMapViewDelegate {
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        if isMapAddedInitialMarkers {
            canMapDismissBottomSheet = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if canMapDismissBottomSheet, itemListView.getCurrentState == .customOffset {
            mapViewActions?(.dismissSheet)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if canMapDismissBottomSheet, itemListView.getCurrentState == .customOffset {
            mapViewActions?(.dismissSheet)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if canMapDismissBottomSheet, itemListView.getCurrentState == .customOffset {
            mapViewActions?(.dismissSheet)
        }
        newLocation = mapView.camera.target
    }
        
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if canMapDismissBottomSheet, itemListView.getCurrentState == .customOffset {
            mapViewActions?(.dismissSheet)
        }
        if let iconView = marker.iconView as? PriceMapMarkerView {
            setSelected(marker)
            let indexPath = IndexPath(item: iconView.index, section: 0)
            if lastItemIndex >= iconView.index {                
                let animated = true//(visibleItemIndex - iconView.index).magnitude == 1
                itemsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
                mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 13)
            }            
        } else {
            printDebug("PriceMapMarkerView not found")
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        newLocation = mapView.camera.target
    }
    
    func setSelectedMarker(of id: String) {
        guard let marker = markersDict[id] else { return }
        setSelected(marker)
    }
    
    func setSelected(_ marker: GMSMarker) {
        if let lastTappedMarker = selectedMarker, let iconView = lastTappedMarker.iconView as? PriceMapMarkerView {
            lastTappedMarker.tracksViewChanges = true
            iconView.updateUI(isSelected: false)
            lastTappedMarker.tracksViewChanges = false
            lastTappedMarker.zIndex = 0
        }
        
        if let iconView = marker.iconView as? PriceMapMarkerView {
            marker.tracksViewChanges = true
            iconView.updateUI(isSelected: true)
            marker.tracksViewChanges = false
            selectedMarker = marker
            marker.zIndex = 1
        }
    }
}

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                printDebug("Unable to find \(name).json")
            }
        } catch {
            printDebug("One or more of the map styles failed to load. \(error)")
        }
    }
}


