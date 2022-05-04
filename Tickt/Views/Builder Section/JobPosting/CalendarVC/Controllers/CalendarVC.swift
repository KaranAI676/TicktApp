//
//  CalendarVC.swift
//  Tickt
//
//  Created by S H U B H A M on 23/03/21.
//

import UIKit
import JTAppleCalendar

protocol AnyOptional {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { self != nil }
}

protocol CalendarDelegate: AnyObject {
    func getSelectedDates(dates: [Date])
}

class CalendarVC: BaseVC {
        
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var timingView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: CustomMediumLabel!
    @IBOutlet weak var subCategoryLabel: CustomRegularLabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var screenTitleSecondLabel: CustomBoldLabel!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageViewHeightConst: NSLayoutConstraint!
    
    //MARK:- Variables
    weak var delegate: CalendarDelegate? = nil
    typealias Node = (indexPath: IndexPath, date: Date)
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }
    var isComingFromSearch = false
    var category: SearchedResultData?
    var screenType: ScreenType = .creatingJob
    var didSelectDates: ((String, String) -> Void)? = nil
    private var nodeData: (headNode: Node?, tailNode: Node?) = (nil, nil)
    ///
    var startDate: Date = Date()
    var endDate: Date = Date().plus(years: 2)
    var startDateToDisplay: Date?
    var endDateToDisplay: Date?
    
    //MARK:- LifeCycle Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if screenType == .homeBuilderSearch || screenType == .homeBuilderSearchEdit || screenType == .fromMilsetone {
            self.startDateToDisplay = kAppDelegate.searchingBuilderModel?.fromDate?.date
            self.endDateToDisplay = kAppDelegate.searchingBuilderModel?.toDate?.date
            calendarView.selectDates(endDateToDisplay == nil ? [startDateToDisplay ?? startDate] : [startDateToDisplay ?? startDate, endDateToDisplay!])
            
            calendarView.scrollToDate(startDateToDisplay ?? startDate, animateScroll: false)
            ///
            self.setupTradeView()
        }
    }
        
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case skipButton:
            skipButtonAction()
        case backButton:
            backButtonAction()
        case continueButton:
            continueButtonAction()
        default:
            break
        }
        disableButton(sender)
    }
    
    func openMapVC() {
        let mapVC = MapController.instantiate(fromAppStoryboard: .search)    
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}

extension CalendarVC {
    
    private func initalSetup() {
        setupCalendar()
        
        if screenType == .fromMilsetone {
            
            
        }
        
        if screenType == .jobSearch {
            if isComingFromSearch {
                skipButton.isHidden = true
                categoryView.isHidden = true
            } else {
                skipButton.isHidden = false
                categoryLabel.text = category?.name
                subCategoryLabel.text = category?.tradeName
                categoryImageView.sd_setImage(with: URL(string: category?.image ?? ""), placeholderImage: nil, options: .highPriority) { [weak self] (image, error, _ , _) in
                    let resizedImage = image?.resized(toWidth: kScreenWidth * 0.5, isOpaque: false)
                    self?.categoryImageView.backgroundColor = UIColor(hex: "#0B41A8")//UIColor(hex: "#D5E5EF")
                    self?.categoryImageView.image = resizedImage
                }
                kAppDelegate.searchModel.tradeName = category?.tradeName ?? ""
                kAppDelegate.searchModel.specializationName = category?.name ?? ""
            }
            timingView.isHidden = true
            timeStackView.isHidden = false
            stackViewBottomConstraint.isActive = true
            calendarView.selectDates([startDate])//To select the current date
            calendarView.scrollToDate(startDate, animateScroll: false)
        } else if screenType == .homeBuilderSearch || screenType == .homeBuilderSearchEdit {
            skipButton.isHidden = !(screenType == .homeBuilderSearch)
            timingView.isHidden = true
            timeStackView.isHidden = false
            iconImageViewHeightConst.constant = 32
            categoryImageView.round(radius: 16)
            stackViewBottomConstraint.isActive = true
            screenTitleSecondLabel.text = "When is your job?"
        } else if screenType == .republishJob || screenType == .editQuoteJob || screenType == .creatingJob {
            startDateToDisplay = kAppDelegate.postJobModel?.fromDate.date
            endDateToDisplay = kAppDelegate.postJobModel?.toDate.date
            calendarView.selectDates(endDateToDisplay == nil ? [startDateToDisplay ?? startDate] : [startDateToDisplay ?? startDate, endDateToDisplay!])
            calendarView.scrollToDate(startDateToDisplay ?? startDate, animateScroll: false)
            stackViewBottomConstraint.isActive = false
            descriptionLabel.text = "Select a start and end date, or a due date."
        } else {
            calendarView.selectDates(endDateToDisplay == nil ? [startDateToDisplay ?? startDate] : [startDateToDisplay ?? startDate, endDateToDisplay!])
            calendarView.scrollToDate(startDateToDisplay ?? startDate, animateScroll: false)
            view.layoutIfNeeded()
            stackViewBottomConstraint.isActive = false
            descriptionLabel.text = "Select a start and end date, or a due date."
        }
    }
    
    private func setupCalendar() {
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.registerReusableView(with: CalendarMonthCollectionReusableView.self, isHeader: true)
        calendarView.registerCell(with: CalendarDayCell.self)
        calendarView.allowsMultipleSelection = true
        calendarView.scrollingMode = .none
        calendarView.rangeSelectionMode = .continuous
        calendarView.cellSize = (kScreenWidth - 48.0)/7.0
        calendarView.minimumInteritemSpacing = 0.0
        calendarView.minimumLineSpacing = 0.0
        calendarView.sectionInset = .zero
        calendarView.allowsRangedSelection = true
    }
    
    private func backButtonAction() {
        switch screenType {
        case .creatingJob:
            if screenType == .creatingJob {
//                kAppDelegate.postJobModel?.fromDate = MilestoneDates()
//                kAppDelegate.postJobModel?.toDate = MilestoneDates()
           }
        case .jobSearch:
            if !isComingFromSearch {
                kAppDelegate.searchModel.fromDate = ""
                kAppDelegate.searchModel.fromDate = ""
            }
        case .homeBuilderSearch:
            self.elimateTheDates()
        case .republishJob,.editQuoteJob:
            kAppDelegate.postJobModel?.fromDate = MilestoneDates()
            kAppDelegate.postJobModel?.toDate = MilestoneDates()
        default:
            break
        }
        pop()
    }
    
    private func continueButtonAction() {
        switch screenType {
        case .creatingJob, .republishJob,.editQuoteJob:
            if validate() {
                goToMilestoneListingVC()
            }
        case .addMilestone:
            if !(nodeData.headNode.isNil) {
                var datesArray = [Date]()
                if let fromDate = nodeData.headNode?.date {
                    datesArray.append(fromDate)
                }
                if let toDate = nodeData.tailNode?.date {
                    datesArray.append(toDate)
                }
                
                if let fromDate = datesArray.first, let colorArray = kAppDelegate.datesDict[fromDate], colorArray.count >= 4 {
                    CommonFunctions.showToastWithMessage("Selected start date is fully engaged")
                    return
                }
                
                if let toDate = datesArray.last, datesArray.count > 1, let colorArray = kAppDelegate.datesDict[toDate], colorArray.count >= 4 {
                    CommonFunctions.showToastWithMessage("Selected end date is fully engaged")
                    return
                }
                
                delegate?.getSelectedDates(dates: datesArray)
                pop()
            } else {
                delegate?.getSelectedDates(dates: [])
                pop()
            }
        case .jobSearch:
            if validate() {
                if isComingFromSearch {
                    if let fromDate = nodeData.headNode?.date {
                        if let toDate = nodeData.tailNode?.date {
                            didSelectDates?(fromDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue), toDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue))
                        } else {
                            didSelectDates?(fromDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue), "")
                        }
                    }
                    pop()
                } else {
                    if kAppDelegate.searchModel.fromDate.isEmpty {
                        CommonFunctions.showToastWithMessage(Validation.errorEmptyStartDate)
                    } else {
                        openMapVC()
                    }
                }
            }
        case .homeBuilderSearch, .homeBuilderSearchEdit:
            if self.validate() {
                feedDates()
                screenType == .homeBuilderSearch ? goToSearchedesultVC() : pop()
            }
        default:
            break
        }
    }
    
    private func skipButtonAction() {
        switch screenType {
        case .jobSearch:
            kAppDelegate.searchModel.fromDate = ""
            kAppDelegate.searchModel.toDate = ""
            openMapVC()
        case .homeBuilderSearch:
            self.elimateTheDates()
            self.goToSearchedesultVC()
        default:
            break
        }
    }
    
    private func elimateTheDates() {
        kAppDelegate.searchingBuilderModel?.fromDate = nil
        kAppDelegate.searchingBuilderModel?.toDate = nil
        self.nodeData.headNode = nil
        self.nodeData.tailNode = nil
        self.calendarView.deselectAllDates(triggerSelectionDelegate: false)
        self.calendarView.reloadData()
    }
    
    private func feedDates() {
        var datesArray = [Date]()
        if !(nodeData.headNode.isNil) {
            if let fromDate = nodeData.headNode?.date {
                datesArray.append(fromDate)
            }
            if let toDate = nodeData.tailNode?.date {
                datesArray.append(toDate)
            }
        } else {
            return
        }
        ///
        if let fromDate = datesArray.first {
            kAppDelegate.searchingBuilderModel?.fromDate = MilestoneDates()
            kAppDelegate.searchingBuilderModel?.fromDate?.backendFormat = fromDate.convertToString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
            kAppDelegate.searchingBuilderModel?.fromDate?.date = fromDate
        }else {
            kAppDelegate.searchingBuilderModel?.fromDate = MilestoneDates()
        }
        if let toDate = datesArray.last, datesArray.count > 1 {
            kAppDelegate.searchingBuilderModel?.toDate = MilestoneDates()
            kAppDelegate.searchingBuilderModel?.toDate?.backendFormat = toDate.convertToString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
            kAppDelegate.searchingBuilderModel?.toDate?.date = toDate
        } else {
            kAppDelegate.searchingBuilderModel?.toDate = MilestoneDates()
        }
    }
    
    private func goToMilestoneListingVC() {
        let vc = MilestoneListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = screenType
        push(vc: vc)
    }
    
    private func goToSearchedesultVC() {
        let vc = SearchedResultBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        self.push(vc: vc)
    }
    
    private func setupTradeView() {
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
        } else {
            self.stackViewBottomConstraint.isActive = false
            self.timingView.isHidden = true
            self.timeStackView.isHidden = false
            self.categoryView.isHidden = true
            self.categoryLabel.text = ""
            self.subCategoryLabel.text = ""
        }
        categoryImageView.sd_setImage(with: URL(string:(imageUrl)), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
            self.categoryImageView.image = image
        }
    }
}


extension CalendarVC: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        calendarCellSetUp(calendar, cell: cell, date: date, cellState: cellState, indexPath: indexPath)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath)
        calendarCellSetUp(calendar, cell: cell, date: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.dateBelongsTo != .thisMonth || date.toLocalTime() < startDate.toLocalTime() || date.toLocalTime() > endDate.toLocalTime() { return }
        
        if nodeData.headNode.isNotNil, date == nodeData.headNode?.date, screenType == .addMilestone {
            nodeData.headNode = nil
            calendar.reloadData()
            return
        }
        
        if nodeData.headNode.isNil {
            nodeData.headNode = (indexPath, date)
            nodeData.tailNode = nil
        } else if let headNode = nodeData.headNode, nodeData.tailNode.isNil {
            if indexPath < headNode.indexPath || indexPath == headNode.indexPath {
                if screenType == .creatingJob, indexPath == headNode.indexPath {
                    CommonFunctions.showToastWithMessage("Your start date & End date is same")
                    nodeData.headNode = (indexPath, date)
                    nodeData.tailNode = (indexPath, date)
                } else {
                    nodeData.headNode = (indexPath, date)
                    nodeData.tailNode = nil
                }
            } else {
                nodeData.headNode = headNode
                nodeData.tailNode = (indexPath, date)
            }
        } else if nodeData.headNode.isNotNil, nodeData.tailNode.isNotNil, nodeData.headNode?.indexPath == nodeData.tailNode?.indexPath {
            nodeData.tailNode = (indexPath, date)
        } else {
            nodeData.headNode = (indexPath, date)
            nodeData.tailNode = nil
        }
        if nodeData.headNode.isNotNil || nodeData.tailNode.isNotNil {
            if continueButton.isHidden {
                continueButton.fadeIn()
            }
        } else {
            if !continueButton.isHidden {
                continueButton.fadeOut()
            }
        }
        calendar.reloadData()
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        self.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header: JTACMonthReusableView  = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarMonthCollectionReusableView", for: indexPath)
        (header as? CalendarMonthCollectionReusableView)?.monthTitleLabel.text = range.start.monthAndYearOfDate()
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 107)
    }
}

extension CalendarVC: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let parameter = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: self.calendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .monday)
        return parameter
    }
}

extension CalendarVC {
    
    private func calendarCellSetUp(_ calendar: JTACMonthView, cell: JTACDayCell, date: Date, cellState: CellState, indexPath: IndexPath) {
        //Prabh
        var cellMode: CalendarDayCellMode = .none
        if cellState.dateBelongsTo != .thisMonth {
            cellMode = .outDates
        } else if nodeData.headNode?.indexPath == indexPath {
            if let headNode = nodeData.headNode?.indexPath, let tailNode = nodeData.tailNode?.indexPath {
                if headNode.section == tailNode.section && tailNode.item == headNode.item + 1 {
                    cellMode = .singleHead
                }
                else if headNode.section < tailNode.section && tailNode.item == 0 {
                    cellMode = .singleHead
                } else {
                    cellMode = .head
                }
            } else {
                cellMode = .singleHead
            }
        } else if nodeData.tailNode?.indexPath == indexPath {
            if let headNode = nodeData.headNode?.indexPath, let tailNode = nodeData.tailNode?.indexPath {
                if headNode.section == tailNode.section && tailNode.item == headNode.item + 1 {
                    cellMode = .singleTail
                }
                else if headNode.section < tailNode.section && tailNode.item == 0 {
                    cellMode = .singleTail
                } else {
                    cellMode = .tail
                }
            }
        } else if let headNode = nodeData.headNode, let tailNode = nodeData.tailNode {
            if headNode.indexPath <= indexPath && tailNode.indexPath >= indexPath {
                if date.isDayEqualTo(dayName: "Mon") {
                    cellMode = .left
                } else if date.isDayEqualTo(dayName: "Sun") {
                    cellMode = .right
                } else {
                    cellMode = .mid
                }
            } else {
                cellMode = .none
            }
        } else {
            cellMode = .none
        }
        if date.toLocalTime() < startDate.toLocalTime() {
            cellMode = .pastDates
        }
        if date.toLocalTime() > endDate.toLocalTime() {
            cellMode = .futureDates
        }
        
        (cell as? CalendarDayCell)?.configCell(date: "\(date.day)", cellMode: cellMode)
        if let colorArray = kAppDelegate.datesDict[date.removeTimeStamp()], cellMode != .outDates, cellMode != .pastDates {
            (cell as? CalendarDayCell)?.setDotColors(colorArray)
        }else {
            (cell as? CalendarDayCell)?.initialHideDots()
        }
        cell.layoutIfNeeded()
    }
}

extension CalendarVC {
    
    private func validate() -> Bool {
        
        if screenType == .creatingJob || screenType == .republishJob || screenType == .editQuoteJob {
            if !nodeData.headNode.isNil {
                if let fromDate = nodeData.headNode?.date {
                    kAppDelegate.postJobModel?.fromDate.backendFormat = fromDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
                    kAppDelegate.postJobModel?.fromDate.date = fromDate
                } else {
                    kAppDelegate.postJobModel?.fromDate = MilestoneDates()
                }
                if let toDate = nodeData.tailNode?.date {
                    kAppDelegate.postJobModel?.toDate.backendFormat = toDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
                    kAppDelegate.postJobModel?.toDate.date = toDate
                } else {
                    kAppDelegate.postJobModel?.toDate = MilestoneDates()
                }
                return true
            } else {
                CommonFunctions.showToastWithMessage(Validation.errorEmptyStartDate)
                return false
            }
        } else if screenType == .homeBuilderSearch || screenType == .homeBuilderSearchEdit {
            if !nodeData.headNode.isNil {
                return true
            } else {
                CommonFunctions.showToastWithMessage(Validation.errorEmptyDates)
                return false
            }
        } else if screenType == .jobSearch {
            if nodeData.headNode.isNil {
                CommonFunctions.showToastWithMessage(Validation.errorEmptyStartDate)
                return false
            } else {
                if let fromDate = nodeData.headNode?.date {
                    if !isComingFromSearch {
                        kAppDelegate.searchModel.fromDate = fromDate.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
                    }
                } else {
                    if !isComingFromSearch {
                        kAppDelegate.searchModel.fromDate = ""
                    }
                    CommonFunctions.showToastWithMessage(Validation.errorEmptyStartDate)
                    return false
                }                
                return true
            }
        } else {
            return false
        }
    }
}
