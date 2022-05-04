//
//  SearchedResultBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 14/04/21.
//

import UIKit
import GooglePlaces

class SearchedResultBuilderVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var navBarView: UIView!
    ///
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var seachLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    /// Calendr
    @IBOutlet weak var calendrImageVIew: UIImageView!
    @IBOutlet weak var calendrLabel: UILabel!
    @IBOutlet weak var calendrButton: UIButton!
    /// Location
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var countLabelBackView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var filterBadgeView: UIView!
    @IBOutlet weak var filterBadgeLabel: UILabel!
    
    //MARK:- Variables
    var placeHolderText = "No tradespeople found"
    var isComingFromSearchNow: Bool = false
    var viewModel = SearchedResultBuilderVM()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTopView()
        self.hitAPi()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            if let vc = self.navigationController?.viewControllers.first(where: {$0 is TabBarController}) {
                kAppDelegate.searchingBuilderModel = nil
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                self.pop()
            }
        case categoryButton:
            self.goToSearchingVC()
        case filterButton:
            self.goToFilterVC()
        case calendrButton:
            self.goToCalendarVC()
        case locationButton:
            self.goToLocationVC()
        default:
            break
        }
    }
}

extension SearchedResultBuilderVC {
    
    private func initialSetup() {
        setupNavBar()
        setupTableView()
        setBgColor()
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        filterBadgeView.isUserInteractionEnabled = false
    }
    
    private func setupTopView() {
        guard let model = kAppDelegate.searchingBuilderModel else {
            self.seachLabel.text = "N.A"
            self.calendrLabel.text = "Add Date"
            self.locationLabel.text = "Add Location"
            return
        }
        ///
        if model.category.id != "" {
            self.seachLabel.text = model.category.name
        } else if let model = model.trade {
            if (model.specialisations?.count ?? 0) == kAppDelegate.searchingBuilderModel?.totalSpecialisationCount {
                self.seachLabel.text = "All"
            }else {
                if (model.specialisations?.count ?? 0) == 0 {
                    self.seachLabel.text = model.tradeName
                } else {
                    self.seachLabel.text = (model.specialisations?.count ?? 0) > 1 ? ("\(model.specialisations?.first?.name ?? "") +\((model.specialisations?.count ?? 0)-1) more") : (model.specialisations?.first?.name ?? "")
                }
            }
        } else {
            self.seachLabel.text = "All around me"
        }
        ///
        if let locationModel = model.location, let locationName = locationModel.locationName.components(separatedBy: ",").first, locationModel.locationCanDisplay {
            self.locationLabel.text = locationName
        } else {
            self.locationLabel.text = "Add Location"
        }
        ///
        if let fromDate = model.fromDate?.date {
            self.calendrLabel.text = CommonFunctions.getFormattedDates(fromDate: fromDate, toDate: model.toDate?.date)
        } else {
            self.calendrLabel.text = "Add Date"
        }
        
        //Filter badge
        filterBadgeView.isHidden = model.filterCount < 1
        filterBadgeLabel.text = model.filterCount.stringValue
    }
    
    private func setupTableView() {
        self.tableViewOutlet.backgroundColor = .clear
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        self.tableViewOutlet.contentInset.bottom = 20
        self.tableViewOutlet.refreshControl = refresher
        self.tableViewOutlet.registerCell(with: TradePeopleTableCell.self)
    }
    
    private func setBgColor() {
        self.navBehindView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
    }
    
    private func hitAPi(isPullToRefresh: Bool = false) {
        guard let model = kAppDelegate.searchingBuilderModel else { return }
        var tradeId: [String]? = nil
        var specilId: [String]? = nil
        ///
        if model.category.id != "" {
            tradeId = (model.category.id == "") ? nil : ([model.category.id ?? ""])
            specilId = (model.category.specializationsId == "") ? nil : ([model.category.specializationsId ?? ""])
            
        } else if let tradeModel = model.trade {
            tradeId = [tradeModel.id]
            ///
            let specialisationIdArray = tradeModel.specialisations?.compactMap({ eachModel -> String in
                return eachModel.id
            })
            if let array = specialisationIdArray, array.count > 1 {
                specilId = array
            }
        }
        ///
        if let sortBy = model.sortBy, sortBy == .closestToMe, model.location == nil {
            self.getCurrentLocation()
            return
        } else if isComingFromSearchNow, model.location == nil {
            self.getCurrentLocation()
            return
        }
        ///
        viewModel.tradeId = tradeId
        viewModel.specilId = specilId
        viewModel.pageNo = 1
        viewModel.nextHit = false
        viewModel.getSearchedData(showLoader: !isPullToRefresh, isPullToRefresh: isPullToRefresh)
        viewModel.isHittingApi = true
    }
    
    private func setupNavBar() {
        self.navBarView.dropShadow(color: #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.8078431373, alpha: 1), opacity: 0.2, offSet: CGSize(width: 2, height: 10), radius: 3, scale: true)
        self.navBarView.cropCorner(radius: 3)
    }
    
    private func goToFilterVC() {
        let vc = FilterVC.instantiate(fromAppStoryboard: .filter)
        self.push(vc: vc)
    }
    
    private func goToCalendarVC() {
        let vc = CalendarVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .homeBuilderSearchEdit
        vc.startDateToDisplay = kAppDelegate.searchingBuilderModel?.fromDate?.date
        vc.endDateToDisplay = kAppDelegate.searchingBuilderModel?.toDate?.date
        self.push(vc: vc)
    }
    
    private func goToLocationVC() {
        let vc = SearchingBuilderLocationVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        vc.screenType = .homeBuilderSearchEdit
        self.push(vc: vc)
    }
    
    private func goToSearchingVC() {
        let vc = SearchingBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        vc.screenType = .homeBuilderSearchEdit
        self.push(vc: vc)
    }
    
    private func goToTradieVC(index: Int) {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.tradieId = viewModel.model?.result?.data[index].tradieId ?? ""
        vc.showSaveUnsaveButton = true
        self.push(vc: vc)
    }
    
    @objc func pullToRefresh() {
        self.hitAPi(isPullToRefresh: true)
    }
}

extension SearchedResultBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model?.result?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: TradePeopleTableCell.self)
        cell.tableView = tableView
        cell.titleLabel.isHidden = true
        cell.extraTradeCellSize = CGSize(width: (71), height: 32)
        cell.extraSpecCellSize = CGSize(width: (16), height: 32)
        ///
        guard let model = self.viewModel.model else { return UITableViewCell() }
        if let specialisationArray: [BuilderHomeSpecialisation] = CommonFunctions.getCountedSpecialisations(dataArray: model.result?.data[indexPath.row].specializationData ?? []) as? [BuilderHomeSpecialisation] {
            cell.populateUI(title: "", dataArrayTrade: model.result?.data[indexPath.row].tradeData ?? [], dataArraySpecialisation: specialisationArray)
        }
        ///
        cell.userNameLabel.text = model.result?.data[indexPath.row].tradieName
        cell.ratingLabel.text = "\(model.result?.data[indexPath.row].ratings ?? 0), \(model.result?.data[indexPath.row].reviews ?? 0) reviews"
        ///
        cell.profileImageVIew.sd_setImage(with: URL(string:(model.result?.data[indexPath.row].tradieImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        ///
        cell.buttonClosure = { [weak self] (index) in
            guard let self  = self else { return }
            self.goToTradieVC(index: index.row)
        }
        cell.layoutIfNeeded()
        viewModel.hitPagination(index: indexPath.row)
        return cell
    }
}

//MARK:- SearchedResultBuilderVM: Delegate
//========================================
extension SearchedResultBuilderVC: SearchedResultBuilderVMDelegate {
    
    func sucess() {
        refresher.endRefreshing()
        countLabel.isHidden = false
        countLabel.text = (viewModel.model?.result?.totalCount ?? 0) == 0 ? self.placeHolderText : (viewModel.model?.result?.totalCount ?? 0 > 1 ? "\(viewModel.model?.result?.totalCount ?? 0) Results" : "1 Result")
        tableViewOutlet.reloadData(completion: {
            self.tableViewOutlet.reloadData()
        })
    }
    
    func failure(error: String) {
        self.refresher.endRefreshing()
        CommonFunctions.showToastWithMessage(error)
    }
}

//MARK:- Current Location: Delegate
//=================================
extension SearchedResultBuilderVC: CustomLocationManagerDelegate {
    
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
        self.getDefaultLocation()
        self.hitAPi()
    }
    
    func accessRestricted() {
        CommonFunctions.hideActivityLoader()
        self.getDefaultLocation()
        self.hitAPi()
    }
    
    func fetchLocation(location: CLLocation) {
        LocationManager.sharedInstance.getAddress(from: location) { [weak self] (address, cordinates) in
            CommonFunctions.hideActivityLoader()
            guard let self = self else { return }
            var locationModel = JobLocation()
            locationModel.locationName = address
            locationModel.locationLat = cordinates.latitude
            locationModel.locationLong = cordinates.longitude
            locationModel.locationCanDisplay = false
            kAppDelegate.searchingBuilderModel?.location = locationModel
            kAppDelegate.searchingBuilderModel?.location?.isCurrentLocation = true
            self.hitAPi()
        }
    }
    
    private func getDefaultLocation() {
        var locationModel = JobLocation()
        locationModel.locationCanDisplay = false
        locationModel.locationName = CommonStrings.locationName
        locationModel.locationLat = kUserDefaults.getUserLatitude()
        locationModel.locationLong = kUserDefaults.getUserLongitude()
        kAppDelegate.searchingBuilderModel?.location = locationModel
        kAppDelegate.searchingBuilderModel?.location?.isCurrentLocation = true
    }
}
