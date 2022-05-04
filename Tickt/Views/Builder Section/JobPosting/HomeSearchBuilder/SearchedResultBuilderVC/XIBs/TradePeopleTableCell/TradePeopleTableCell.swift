//
//  TradePeopleTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 17/04/21.
//

import UIKit

class TradePeopleTableCell: UITableViewCell {

    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    ///
    @IBOutlet weak var tradesCollectionview: DynamicHeightCollectionView!
    @IBOutlet weak var tradesChipsFlow: ChipsCollectionViewFlowLayout!
    ///
    @IBOutlet weak var specialisationCollectionview: DynamicHeightCollectionView!
    @IBOutlet weak var specialisationChipsFlow: ChipsCollectionViewFlowLayout!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    //MARK:- Variables
    var tradeModel = [BuilderHomeTradeData]() { didSet { self.tradesCollectionview.reloadData() }}
    var specialisationModel = [BuilderHomeSpecialisation]() { didSet { self.specialisationCollectionview.reloadData() }}
//    var didSelectClosure: ((CellType, IndexPath, Bool)->(Void))? = nil
    private let chipsItemPadding: CGFloat = 16.0
    var extraTradeCellSize: CGSize = CGSize.zero
    var extraSpecCellSize: CGSize = CGSize.zero
    var isSelectionEnable: Bool = true
    var cellFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
    var buttonClosure: ((IndexPath)->(Void))? = nil
    var tableView: UITableView? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- LifeCycle Methods
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            self.buttonClosure?(index)
        }
    }
}

extension TradePeopleTableCell {
    
    private func configureUI() {
        self.chipsCollectionFlowLayoutSetUp()
        self.setupCollectionView()
        self.selectionStyle = .none
    }
    
    private func setupCollectionView() {
        self.tradesCollectionview.registerCell(with: RectangularTradeCollectionViewCell.self)
        self.specialisationCollectionview.registerCell(with: SpecialisationsCollectionViewCell.self)
        ///
        self.tradesCollectionview.delegate = self
        self.specialisationCollectionview.delegate = self
        ///
        self.tradesCollectionview.dataSource = self
        self.specialisationCollectionview.dataSource = self
        ///
        self.tradesCollectionview.isScrollEnabled = false
        self.specialisationCollectionview.isScrollEnabled = false
        ///
        self.tradesCollectionview.reloadData()
        self.specialisationCollectionview.reloadData()
    }
    
    private func chipsCollectionFlowLayoutSetUp() {
        self.tradesChipsFlow.invalidateLayout()
        self.tradesChipsFlow.minimumLineSpacing = self.chipsItemPadding
        self.tradesChipsFlow.minimumInteritemSpacing = self.chipsItemPadding
        self.tradesChipsFlow.sectionHeadersPinToVisibleBounds = true
        self.tradesChipsFlow.sectionFootersPinToVisibleBounds = true
        self.tradesChipsFlow.headerReferenceSize = CGSize.zero
        self.tradesChipsFlow.footerReferenceSize = CGSize.zero
        self.tradesCollectionview.setNeedsLayout()
        ///
        self.specialisationChipsFlow.invalidateLayout()
        self.specialisationChipsFlow.minimumLineSpacing = self.chipsItemPadding
        self.specialisationChipsFlow.minimumInteritemSpacing = self.chipsItemPadding
        self.specialisationChipsFlow.sectionHeadersPinToVisibleBounds = true
        self.specialisationChipsFlow.sectionFootersPinToVisibleBounds = true
        self.specialisationChipsFlow.headerReferenceSize = CGSize.zero
        self.specialisationChipsFlow.footerReferenceSize = CGSize.zero
        self.specialisationCollectionview.setNeedsLayout()
    }
}

//MARK:- UIPopulation
//===================
extension TradePeopleTableCell {
    
    func populateUI(title: String, dataArrayTrade: [BuilderHomeTradeData], dataArraySpecialisation: [BuilderHomeSpecialisation]) {
        self.titleLabel.text = title
        self.tradeModel = dataArrayTrade
        self.specialisationModel = dataArraySpecialisation
    }
}

extension TradePeopleTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === tradesCollectionview {
            return self.tradeModel.count
        }else {
            return self.specialisationModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        if collectionView === tradesCollectionview {
            return getJobTypeCell(collectionView: collectionView, indexPath: indexPath)
        }else {
            return getSpecialisationCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
}

// MARK: - ChipsCollectionViewLayoutDelegate
//==========================================
extension TradePeopleTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var title = ""
        if collectionView === tradesCollectionview {
            title = self.tradeModel[indexPath.row].tradeName
        }else {
            title = self.specialisationModel[indexPath.row].specializationName
        }
        ///
        var size = title.size(withAttributes: [NSAttributedString.Key.font: cellFont])
        
        if collectionView === tradesCollectionview {
            size.width += extraTradeCellSize.width
            size.height = size.height + extraTradeCellSize.height
        }else {
            size.width += extraSpecCellSize.width
            size.height = size.height + abs(extraSpecCellSize.height - size.height)
        }
        ///
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return size
    }
}

extension TradePeopleTableCell {
    
    private func getJobTypeCell(collectionView: UICollectionView, indexPath: IndexPath) -> RectangularTradeCollectionViewCell {
        let cell = collectionView.dequeueCell(with: RectangularTradeCollectionViewCell.self, indexPath: indexPath)
        let model = self.tradeModel[indexPath.row]
        cell.iconImaegView.sd_setImage(with: URL(string:(model.tradeSelectedUrl)), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
            cell.iconImaegView.image = image
        }
        cell.titleLabel.text = model.tradeName
        return cell
    }
    
    private func getSpecialisationCell(collectionView: UICollectionView, indexPath: IndexPath) -> SpecialisationsCollectionViewCell {
        let cell = collectionView.dequeueCell(with: SpecialisationsCollectionViewCell.self, indexPath: indexPath)
        cell.rightConstrint.constant = 0
        cell.topConstraint.constant = 0
        ///
        let model = specialisationModel[indexPath.row]
        cell.spelisationNameLabel.text = model.specializationName
        cell.spelisationNameLabel.textColor = .red
        cell.spelisationNameLabel.textColor = AppColors.themeBlue
        cell.backView.backgroundColor = AppColors.backGorundWhite
        cell.spelisationNameLabel.font = cellFont
        return cell
    }
}
