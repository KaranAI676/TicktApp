//
//  SearchingBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 22/04/21.
//

import UIKit

class SearchingBuilderVC: BaseVC {
    
    enum SectionType {
        case recentSearch
        case trade
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchField: CustomMediumField!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    ///
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    //MARK:- Vairables
    var isSearchEnabled = false { didSet { searchTableView.isHidden = !isSearchEnabled } }
    var searchModel: SearchedResultModel?
    var recentSearchModel: RecentSearchModel?
    var tradeModel: TradeModel?
    var viewModel = SearchingBuilderVM()
    var cellSection = [SectionType]()
    var screenType: ScreenType = .homeBuilderSearch
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            if screenType == .homeBuilderSearch {
                kAppDelegate.searchingBuilderModel = nil
            }
            pop()
        case cancelSearchButton:
            searchField.text = ""
            isSearchEnabled = false
            searchField.resignFirstResponder()
            searchImage.isHidden = false
            cancelSearchButton.isHidden = true
            widthConstraint.constant = 30
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.view.layoutIfNeeded()
            }
            mainQueue { [weak self] in
                guard let self = self else { return }
                self.searchTableView.reloadData()
            }
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension SearchingBuilderVC {
    
    private func initialSetup() {
        self.searchField.setAttributedPlaceholder(placeholderText: "What tradesperson are you searching for?", font: UIFont.kAppDefaultFontMedium(ofSize: CGFloat(searchField.tag)), color: #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1))
        self.cancelSearchButton.isHidden = true
        self.searchField.autocorrectionType = .no
        viewModel.delegate = self
        if screenType != .homeBuilderSearchEdit {
            cellSection = [.trade]
            viewModel.getRecentJobs()
            viewModel.getTradeList()
        }else {
            self.searchField.becomeFirstResponder()
        }
        setupCollectionView()
        setupTableView()
        ///
        if kAppDelegate.searchingBuilderModel == nil {
            kAppDelegate.searchingBuilderModel = SearchingContentsModel()
        }
    }
    
    private func setupTableView() {
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.isHidden = true
        self.searchTableView.registerCell(with: NoDataFoundTableCell.self)
        self.searchTableView.registerCell(with: CategorySearchedTableCell.self)
        self.searchTableView.registerHeaderFooter(with: SearchHeaderView.self)
    }
    
    private func setupCollectionView() {
        collectionViewOutlet.registerCell(with: tradeCollectionViewCell.self)
        collectionViewOutlet.registerCell(with: RecentSearchCollectionViewCell.self)
        collectionViewOutlet.registerReusableView(with: TitleHeaderCollectionView.self, isHeader: true)
        collectionViewOutlet.contentInset.bottom = 40
        collectionViewOutlet.showsVerticalScrollIndicator = false
        collectionViewOutlet.showsHorizontalScrollIndicator = false
        setupLayout()
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
    }

    private func setupLayout(_ forTrade: Bool = true) {
        if forTrade {
            let size = (kScreenWidth - 60) / 3
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: size, height: size)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            collectionViewOutlet.setCollectionViewLayout(layout, animated: false)
        }else {
            let size = kScreenWidth
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: size, height: size)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            collectionViewOutlet.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    private func goToLocationVC() {
        if screenType == .homeBuilderSearchEdit {
            self.pop()
        }else {
            let vc = SearchingBuilderLocationVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
            self.push(vc: vc)
        }
    }
    
    private func goToSearchingVC() {
        let vc = SearchingBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        self.push(vc: vc)
    }
    
    private func goToSearchedResultVC() {
        let vc = SearchedResultBuilderVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        self.push(vc: vc)
    }
    
    private func setSelectedTrades(index: Int) {
        for eachTradeIndex in 0..<(tradeModel?.result?.trade?.count ?? 0) {
            for eachSpecIndex in 0..<(self.tradeModel?.result?.trade?[eachTradeIndex].specialisations?.count ?? 0) {
                self.tradeModel?.result?.trade?[eachTradeIndex].specialisations?[eachSpecIndex].isSelected = eachTradeIndex == index
            }
        }
    }
}

//MARK:- RecentSearch: Delegate
//=============================
extension SearchingBuilderVC: SearchingBuilderVMDelegate {
    
    func success(model: RecentSearchModel) {
        recentSearchModel = model
        if screenType != .homeBuilderSearchEdit {
            cellSection = (recentSearchModel?.result?.resultData?.count ?? 0 == 0) ? [.trade] : [.recentSearch, .trade]
        }
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.collectionViewOutlet.reloadData()
        }
    }
    
    func successByTyping(data: SearchingModel) {
        let vc = SearchingBuilderLocationVC.instantiate(fromAppStoryboard: .homeSearchBuilder)
        self.push(vc: vc)
    }
    
    func successByCategory(data: SearchingModel) {
        
    }
    
    func success(data: TradeModel) {
        self.tradeModel = data
        self.collectionViewOutlet.reloadData()
    }
            
    func success(model: SearchedResultModel) {
        searchModel = model
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.searchTableView.reloadData()
        }
    }
    
    func searchedResultNotFound() {
        searchModel = nil
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.searchTableView.reloadData()
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}

//MARK:- UITextField: Delegate
//============================
extension SearchingBuilderVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if !updatedText.isEmpty {
                widthConstraint.constant = 0
                searchImage.isHidden = true
                cancelSearchButton.isHidden = false
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.view.layoutIfNeeded()
                }
                viewModel.getSearchedTrades(searchText: updatedText)
                isSearchEnabled = true
                return true
            } else {
                searchImage.isHidden = false
                cancelSearchButton.isHidden = true
                widthConstraint.constant = 30
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.view.layoutIfNeeded()
                }
                isSearchEnabled = false
                mainQueue { [weak self] in
                    guard let self = self else { return }
                    self.searchTableView.reloadData()
                }
                return true
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//MARK:- TableView: Delegate
//==========================
extension SearchingBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchModel?.result?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (searchModel?.result?.count ?? 0) == 0 {
            let cell = tableView.dequeueCell(with: NoDataFoundTableCell.self)
            return cell
        }else {
            let cell = tableView.dequeueCell(with: CategorySearchedTableCell.self)
            cell.searchData = searchModel?.result![indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchModel?.result?.count ?? 0) == 0 {
            return
        }
        if let model = searchModel?.result![indexPath.row] {
            kAppDelegate.searchingBuilderModel?.category = model
            kAppDelegate.searchingBuilderModel?.trade = nil
            self.goToLocationVC()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (searchModel?.result?.count ?? 0) == 0 {
            return tableView.bounds.height
        }else {
            return UITableView.automaticDimension
        }
    }
}

//MARK:- CollectionDelegate
//=========================
extension SearchingBuilderVC: CollectionDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellSection[section] {
        case .recentSearch:
            return self.recentSearchModel?.result?.resultData?.count ?? 0
        case .trade:
            return tradeModel?.result?.trade?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellSection[indexPath.section] {
        case .recentSearch:
            let cell = collectionView.dequeueCell(with: RecentSearchCollectionViewCell.self, indexPath: indexPath)
            if let model = self.recentSearchModel?.result?.resultData?[indexPath.row] {
                cell.searchData = model
            }
            return cell
        case .trade:
            let cell = collectionView.dequeueCell(with: tradeCollectionViewCell.self, indexPath: indexPath)
            cell.tradeNameLabel.text = tradeModel?.result?.trade![indexPath.item].tradeName
            ///
            let status = tradeModel?.result?.trade![indexPath.item].isSelected ?? false
            cell.selectedImageView.isHidden = !status
            cell.iconImageView.sd_setImage(with: URL(string:(tradeModel?.result?.trade![indexPath.item].selectedUrl ?? "")), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
                let resizedImage = image?.resized(toWidth: kScreenWidth * 0.5, isOpaque: false)
                if status {
    //                    cell.tradeImageView.backgroundColor = UIColor(hex: "#0B41A8")
                    cell.iconImageView.image = resizedImage?.imageWithColor(AppColors.themeYellow)
                } else {
    //                    cell.tradeImageView.backgroundColor = UIColor(hex: "#D5E5EF")
    //                    cell.iconImageView.image = resizedImage
                    cell.iconImageView.image = resizedImage?.imageWithColor(.white)
                }
            }
            if status {
                cell.tradeImageView.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.2549019608, blue: 0.6588235294, alpha: 1)
            } else {
                cell.tradeImageView.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            }
            cell.tradeImageView.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellSection[indexPath.section] {
        case .recentSearch:
            let size = kScreenWidth
            return CGSize(width: size, height: 50 + 10)
        case .trade:
            let size = (kScreenWidth - 60) / 3
            return CGSize(width: size, height: size + 25)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellSection[indexPath.section] {
        case .recentSearch:
            if let model = self.recentSearchModel?.result?.resultData?[indexPath.row] {
                kAppDelegate.searchingBuilderModel?.category = model
                kAppDelegate.searchingBuilderModel?.trade = nil
                self.goToLocationVC()
            }
        case .trade:
            self.setSelectedTrades(index: indexPath.row)
            kAppDelegate.searchingBuilderModel?.category = SearchedResultData()
            kAppDelegate.searchingBuilderModel?.trade = tradeModel?.result?.trade![indexPath.row]
            kAppDelegate.searchingBuilderModel?.totalSpecialisationCount = tradeModel?.result?.trade![indexPath.row].specialisations?.count ?? 0
            self.goToSearchedResultVC()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeaderCollectionView", for: indexPath) as? TitleHeaderCollectionView else { return UICollectionReusableView() }
        switch cellSection[indexPath.section] {
        case .recentSearch:
            headerView.titleLabel.text = "Recent searches"
        case .trade:
            headerView.titleLabel.text = "Categories"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 50)
    }
}
