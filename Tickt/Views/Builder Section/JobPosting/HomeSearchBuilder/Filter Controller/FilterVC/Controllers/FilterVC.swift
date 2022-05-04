//
//  FilterVC.swift
//  Tickt
//
//  Created by S H U B H A M on 12/04/21.
//

import GooglePlaces

class FilterVC: BaseVC {
    
    enum CellTypes {
        case sortBy
        case budget
        case jobType
        case category
        case rangeSlider
        case bottomButton
        case specialisation
    }
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var price = ""
    var sortBy: SortingType?
    var tradeModel: TradeModel?
    var viewModel = CreateJobVM()
    var filterData = FilterData()
    var selectButtonSelected = false //To animate the budget View
    var selectedIndexOfTrade: Int? = nil
    var selectFilter: ((_ filters: FilterData) -> ())?
    var sortByArray: [SortingType] = SortingType.allCases
    var filterBuilderModel: SearchingContentsModel? = nil
    var cellArray: [CellTypes] = [.category, .jobType, .specialisation, .sortBy, .bottomButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            self.pop()
        case clearAllButton:
            if kUserDefaults.isTradie() {
                for index in 0..<filterData.jobType.result.resultData.count { //For Tradie
                    filterData.jobType.result.resultData[index].isSelected = false
                }
                filterData.resetData()
            }else {
                filterBuilderModel?.filterCount = 0
            }
            for index in 0..<(self.tradeModel?.result?.trade?.count ?? 0) {
                tradeModel?.result?.trade?[index].isSelected = false
                for innerIndex in 0..<(tradeModel?.result?.trade?[index].specialisations?.count ?? 0) {
                    tradeModel?.result?.trade?[index].specialisations?[innerIndex].isSelected = false
                }
            }
            
            self.selectedIndexOfTrade = nil
            self.sortBy = .highestRated
            self.tableViewOutlet.reloadData()
        default:
            break
        }
    }
}

extension FilterVC {
    
    private func initialSetup() {
        if let model = kAppDelegate.searchingBuilderModel {
            self.filterBuilderModel = model
        }
        setupTableView()
        viewModel.delegate = self
        sortBy = filterBuilderModel?.sortBy
        viewModel.getTradeList()
        viewModel.getJobTypeList()
    }
    
    private func setupTableView() {
        if kUserDefaults.isTradie() {
            cellArray.insert(.rangeSlider, at: 3)
            sortBy = .highestRated
        } else {
            sortBy = kAppDelegate.searchingBuilderModel?.sortBy
        }
         
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.registerCell(with: BudgetCell.self)
        tableViewOutlet.registerCell(with: PriceRangeCell.self)
        tableViewOutlet.registerCell(with: BottomButtonTableCell.self)
        tableViewOutlet.registerCell(with: CommonRadioButtonTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewWithTitleTableCell.self)
        tableViewOutlet.registerCell(with: DynamicHeightCollectionViewTableCell.self)
    }
    
    func setupPrefilledData() {
        
        guard let model = filterBuilderModel else { return }
        if model.filterCount < 1 { return }
        
        var tradeId: String = ""
        var specialisationIds = [String]()
        
        if model.category.id != "" {
            tradeId = model.category.id ?? ""
            specialisationIds = [model.category.specializationsId ?? ""]
        } else if let tradeModel = model.trade {
            tradeId = tradeModel.id
            let idsArray = tradeModel.specialisations?.compactMap({ eachModel -> String? in
                if eachModel.isSelected ?? false {
                    return eachModel.id
                }
                return nil
            })
            if let array = idsArray {
                specialisationIds = array
            }
        }
        
        let index = self.tradeModel?.result?.trade?.firstIndex(where: { eachModel -> Bool in
            return eachModel.id == tradeId
        })
        
        if let indexValue = index {
            
            self.selectedIndexOfTrade = indexValue
            self.tradeModel?.result?.trade?[indexValue].isSelected = true
            
            for i in 0..<specialisationIds.count {
                for j in 0..<(self.tradeModel?.result?.trade?[indexValue].specialisations?.count ?? 0) {
                    if self.tradeModel?.result?.trade?[indexValue].specialisations?[j].id == specialisationIds[i] {
                        self.tradeModel?.result?.trade?[indexValue].specialisations?[j].isSelected = true
                    }
                }
            }
            
            if kAppDelegate.searchingBuilderModel?.totalSpecialisationCount == specialisationIds.count {
                self.tradeModel?.result?.trade?[indexValue].specialisations?[0].isSelected = true
            }
        }
    }
    
    func submitButtonAction() {
        if kUserDefaults.isTradie() {
            filterData.sortBy = sortBy
            if filterData.sortBy == .closestToMe {
                if filterData.cordinates.count > 0 {
                    if validateTradie() {
                        selectFilter?(filterData)
                        pop()
                    }
                } else {
                    getCurrentLocation()
                }
            } else {
                if validateTradie() {
                    selectFilter?(filterData)
                    pop()
                }
            }
        } else {
            if validate() {
                kAppDelegate.searchingBuilderModel = self.filterBuilderModel
                self.pop()
            }
        }
    }
}

//MARK:- Validate
//===============
extension FilterVC {
    
    func validate() -> Bool {
        
        filterBuilderModel?.filterCount = 0
        /// Get current selected Trade
        let index = self.tradeModel?.result?.trade?.firstIndex(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        
        /// Get current selected trade index
        if let index = index {
            
            if self.tradeModel?.result?.trade?[index].specialisations?.first?.name == CommonStrings.all {
                self.tradeModel?.result?.trade?[index].specialisations?.remove(at: 0)
            }
            
            self.filterBuilderModel?.totalSpecialisationCount = self.tradeModel?.result?.trade?[index].specialisations?.count ?? 0
            ///
            let specialisationArray = self.tradeModel?.result?.trade?[index].specialisations?.filter({ eachModel in
                return eachModel.isSelected == true
            })
            
            if let array = specialisationArray, array.count == 1 {
                let model = self.tradeModel?.result?.trade?[index]
                filterBuilderModel?.category.id = model?.id
                filterBuilderModel?.category.name = array[0].name
                filterBuilderModel?.category.image = model?.selectedUrl ?? ""
                filterBuilderModel?.category.tradeName = model?.tradeName
                filterBuilderModel?.category.specializationsId = array[0].id
                filterBuilderModel?.trade = nil
                filterBuilderModel?.filterCount += 2
            } else if let array = specialisationArray, array.count > 1 {
                let model = self.tradeModel?.result?.trade?[index]
                filterBuilderModel?.trade = model
                filterBuilderModel?.trade?.specialisations = array
                filterBuilderModel?.category = SearchedResultData()
                filterBuilderModel?.filterCount += 2
            }else {
                let model = self.tradeModel?.result?.trade?[index]
                filterBuilderModel?.trade = model
                filterBuilderModel?.category = SearchedResultData()
                self.filterBuilderModel?.trade?.specialisations = [SpecializationModel]()
                filterBuilderModel?.filterCount += 1
            }
        } else {
            filterBuilderModel?.category = SearchedResultData()
            filterBuilderModel?.trade = nil
            filterBuilderModel?.filterCount = 0
        }
        
        /// Sorting
        filterBuilderModel?.sortBy = sortBy
        filterBuilderModel?.filterCount += 1
        return true
    }
    
    func validateTradie() -> Bool {    
        
        if let index = tradeModel?.result?.trade?.firstIndex(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        }) {
            if let trade = tradeModel?.result?.trade?[index], var specialisationArray = tradeModel?.result?.trade?[index].specialisations?.filter({ eachModel in
                return eachModel.isSelected == true
            }), specialisationArray.count > 0 { //Specialization Selected
                filterData.trade = trade
                filterData.isOnlyTradeSelected = false
                if let firstSpecialization = specialisationArray.first, firstSpecialization.name == CommonStrings.all {
                    specialisationArray.remove(at: 0)
                    filterData.trade?.specialisations = specialisationArray
                    filterData.isAllSubCatSelected = true
                    
                } else {
                    filterData.trade?.specialisations = specialisationArray                    
                    if specialisationArray.count == (trade.specialisations?.count ?? 0) {
                        filterData.isAllSubCatSelected = true
                    } else {
                        filterData.isAllSubCatSelected = false
                    }
                }
            } else { //Only Trade Selected
                filterData.isOnlyTradeSelected = true
                filterData.trade = tradeModel?.result?.trade?[index]
            }
        } else {
            filterData.trade = nil            
        }
        
        if filterData.isSliderMoved, filterData.payType.isEmpty {
            filterData.payType = PayType.perHour.rawValue
        }

        let selectedJobs = filterData.jobType.result.resultData.filter { $0.isSelected }
        if selectedJobs.count > 0 {
            filterData.jobType.result.resultData = selectedJobs
        } else {
            filterData.jobType.result.resultData = []
        }
        filterData.isFiltered = true
        return true
    }
    
    func setDataForTradie() {
        
        sortBy = filterData.sortBy
        
        let tradeId = filterData.trade?.id ?? ""
        var specialisationIds = [String]()
        
        let index = self.tradeModel?.result?.trade?.firstIndex(where: { $0.id == tradeId })
        if let selectedIndex = index {
            if filterData.isOnlyTradeSelected { //Only Category Selected
                selectedIndexOfTrade = selectedIndex
                tradeModel?.result?.trade?[selectedIndex].isSelected = true
            } else if (filterData.isAllSubCatSelected || filterData.trade != nil) {
                selectedIndexOfTrade = selectedIndex
                tradeModel?.result?.trade?[selectedIndex].isSelected = true
                specialisationIds = filterData.trade?.specialisations?.map {$0.id} ?? []
                if filterData.isAllSubCatSelected { // All Specialization Selected
                    for j in 0..<(tradeModel?.result?.trade?[selectedIndex].specialisations?.count ?? 0) {
                        self.tradeModel?.result?.trade?[selectedIndex].specialisations?[j].isSelected = true
                    }
                } else {
                    for i in 0..<specialisationIds.count { //Few Specialization selected
                        for j in 0..<(tradeModel?.result?.trade?[selectedIndex].specialisations?.count ?? 0) {
                            if self.tradeModel?.result?.trade?[selectedIndex].specialisations?[j].id == specialisationIds[i] {
                                self.tradeModel?.result?.trade?[selectedIndex].specialisations?[j].isSelected = true
                            }
                        }
                    }
                }
            }
        }
    }
}
