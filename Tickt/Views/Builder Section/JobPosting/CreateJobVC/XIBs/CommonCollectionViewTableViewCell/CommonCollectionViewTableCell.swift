//
//  CommonCollectionViewTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 25/03/21.
//

import UIKit
import TagCellLayout

class CommonCollectionViewTableCell: UITableViewCell {

    enum ButtonType {
        case crossTapped
        case imageTapped
        case uploadImage
    }
    
    enum CellType {
        case photos
        case photosUrls
        case tradeProfile
        case imagesWithUrls
        case loggedInBuilder
        case portfolioImageUrl
        case portfolioImageUrlWithAddMore
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var collectionViewOutlet: DynamicHeightCollectionView!
    @IBOutlet weak var chipFlowLayout: ChipsCollectionViewFlowLayout!
    
    //MARK:- Variables
    
    var chipsItemPadding: CGFloat = 16.0
    var fromProfileShow:Bool = false
    var limitedShows:Bool = false
    var model: TradieProfileResult? {
        didSet {
            self.populateUI(.tradeProfile)
        }
    }
    var loggedIntModel: BuilderProfileResult? {
        didSet {
            self.populateUI(.loggedInBuilder)
        }
    }
    var photoUrlsModel: [String]? {
        didSet {
            self.populateUI(.photosUrls)
        }
    }
    var photosModel: [UIImage]? {
        didSet {
            self.populateUI(.photos)
        }
    }
    var imagesWithUrls: [(url: String?, image: UIImage?)]? {
        didSet {
            self.populateUI(.imagesWithUrls)
        }
    }
    var portfolioImageUrl: [(url: String?, image: UIImage?)]? {
        didSet {
            self.populateUI(.portfolioImageUrl)
        }
    }
    var portfolioImageUrlWithAddMore: [(url: String?, image: UIImage?)]? {
        didSet {
            self.populateUI(.portfolioImageUrlWithAddMore)
        }
    }
    var maxMediaCanAllow: Int = 0
    var showPencilIcon: Bool = false
    private var cellType: CellType = .tradeProfile
    private var collectionViewDataModel = [tradeSpecial]()
    var imageTapped: ((ButtonType, IndexPath)->())? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension CommonCollectionViewTableCell {
    
    private func configUI() {
        setupCollectionView()
        chipsCollectionFlowLayoutSetUp()
        ///
        collectionViewOutlet.registerCell(with: TradeSpecTableCell.self)
        collectionViewOutlet.registerCell(with: PortfolioImageCollectionViewCell.self)
        collectionViewOutlet.registerCell(with: ReasonCollectionViewCell.self)
    }
    
    private func setupCollectionView() {
        collectionViewOutlet.registerCell(with: JobCell.self)
        collectionViewOutlet.registerCell(with: JobTypeCollectionViewCell.self)
        collectionViewOutlet.registerCell(with: SpecialisationsCollectionViewCell.self)
        collectionViewOutlet.registerCell(with: ImageViewCollectionCell.self)
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.isScrollEnabled = false
        collectionViewOutlet.reloadData()
    }
    
    private func chipsCollectionFlowLayoutSetUp() {
        self.chipFlowLayout.invalidateLayout()
        self.chipFlowLayout.minimumLineSpacing = self.chipsItemPadding
        self.chipFlowLayout.minimumInteritemSpacing = self.chipsItemPadding
        self.chipFlowLayout.sectionHeadersPinToVisibleBounds = true
        self.chipFlowLayout.sectionFootersPinToVisibleBounds = true
        self.chipFlowLayout.headerReferenceSize = CGSize.zero
        self.chipFlowLayout.footerReferenceSize = CGSize.zero
        self.collectionViewOutlet.setNeedsLayout()
    }
    
    func populateUI(_ cellType: CellType) {
        self.cellType = cellType
        switch cellType {
        case .tradeProfile:
            collectionViewDataModel.removeAll()
            let tradeObject = self.model?.areasOfSpecialization.tradeData.first
            let object: tradeSpecial = (tradeObject?.tradeSelectedUrl ?? "", tradeObject?.tradeName ?? "", .trade)
            collectionViewDataModel.append(object)
            let _ = model?.areasOfSpecialization.specializationData.map({ eachModel in
                let object: tradeSpecial = ("", eachModel.specializationName, .specialisation)
                collectionViewDataModel.append(object)
            })
            collectionViewOutlet.delegate = self
            collectionViewOutlet.dataSource = self
            collectionViewOutlet.reloadData()
        case .loggedInBuilder:
            collectionViewDataModel.removeAll()
            let _ = loggedIntModel?.areasOfSpecialization.tradeData.map({ eachModel in
                let object: tradeSpecial = (eachModel.tradeSelectedUrl, eachModel.tradeName, .trade)
                collectionViewDataModel.append(object)
            })
            let _ = loggedIntModel?.areasOfSpecialization.specializationData.map({ eachModel in
                let object: tradeSpecial = ("", eachModel.specializationName, .specialisation)
                collectionViewDataModel.append(object)
            })
        case .photosUrls, .photos, .imagesWithUrls, .portfolioImageUrl, .portfolioImageUrlWithAddMore:
            self.collectionViewOutlet.delegate = self
            self.collectionViewOutlet.dataSource = self
            self.collectionViewOutlet.reloadData()
        }
    }
}



extension CommonCollectionViewTableCell: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellType {
        case .tradeProfile, .loggedInBuilder:
            return collectionViewDataModel.count
        case .photosUrls:
            if limitedShows && fromProfileShow {
                return (photoUrlsModel?.count ?? 0 <= 3) ? photoUrlsModel?.count ?? 0 : 3
            }
            return photoUrlsModel?.count ?? 0
        case .imagesWithUrls:
            return (imagesWithUrls?.count ?? 0) == 0 ? 1 : ((imagesWithUrls?.count ?? 0) < maxMediaCanAllow ? (imagesWithUrls?.count ?? 0) + 1 : (imagesWithUrls?.count ?? 0))
        case .portfolioImageUrl:
            if limitedShows && fromProfileShow {
                return 3
            }
            return portfolioImageUrl?.count ?? 0
        case .portfolioImageUrlWithAddMore:
            return (portfolioImageUrlWithAddMore?.count ?? 0) == 0 ? 1 : ((portfolioImageUrlWithAddMore?.count ?? 0) < maxMediaCanAllow ? (portfolioImageUrlWithAddMore?.count ?? 0) + 1 : (portfolioImageUrlWithAddMore?.count ?? 0))
        case .photos:
            return (photosModel?.count ?? 0) == 0 ? 1 : ((photosModel?.count ?? 0) < maxMediaCanAllow ? (photosModel?.count ?? 0) + 1 : (photosModel?.count ?? 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType {
        case .tradeProfile, .loggedInBuilder:
            let cell = collectionView.dequeueCell(with: TradeSpecTableCell.self, indexPath: indexPath)
            cell.model = collectionViewDataModel[indexPath.row]
            return cell
        case .photosUrls:
            let cell = collectionView.dequeueCell(with: PortfolioImageCollectionViewCell.self, indexPath: indexPath)
            cell.imageViewOutlet.round(radius: 3)
            if let link = photoUrlsModel?[indexPath.row] {
                cell.imageViewOutlet.sd_setImage(with: URL(string:(link)), placeholderImage: nil, options: .highPriority)
            }
            return cell
        case .portfolioImageUrl:
            let cell = collectionView.dequeueCell(with: PortfolioImageCollectionViewCell.self, indexPath: indexPath)
            cell.imageViewOutlet.round(radius: 3)
            cell.pencilIconImageView.isHidden = !showPencilIcon
            if let url = portfolioImageUrl?[indexPath.row].url {
                cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
            }else if let image = portfolioImageUrl?[indexPath.row].image {
                cell.imageViewOutlet.image = image
            }
            return cell
        case .portfolioImageUrlWithAddMore:
            let cell = collectionView.dequeueCell(with: PortfolioImageCollectionViewCell.self, indexPath: indexPath)
            cell.imageViewOutlet.round(radius: 3)
            cell.pencilIconImageView.isHidden = !showPencilIcon
            if (portfolioImageUrlWithAddMore?.isEmpty ?? true) || indexPath.row == (portfolioImageUrlWithAddMore?.count ?? 0) {
                cell.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
                cell.pencilIconImageView.isHidden = true
            }else if let url = portfolioImageUrlWithAddMore?[indexPath.row].url {
                cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
            }else if let image = portfolioImageUrlWithAddMore?[indexPath.row].image {
                cell.imageViewOutlet.image = image
            }
            return cell
        case .photos:
            let cell = collectionView.dequeueCell(with: ImageViewCollectionCell.self, indexPath: indexPath)
            cell.collectionView = collectionView
            cell.playButton.isHidden = true
            
            if (photosModel?.isEmpty ?? true) || indexPath.row == (photosModel?.count ?? 0) {
                cell.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
                cell.crossButton.isHidden = true
            } else if let image = photosModel?[indexPath.row] {
                cell.imageViewOutlet.image = image
                cell.crossButton.isHidden = false
            }
            cell.crossButtonClosure = { [weak self] index in
                guard let self = self else { return }
                self.imageTapped?(.crossTapped, index)
            }
            return cell
        case .imagesWithUrls:
            let cell = collectionView.dequeueCell(with: ImageViewCollectionCell.self, indexPath: indexPath)
            cell.collectionView = collectionView
            cell.playButton.isHidden = true
            
            if (imagesWithUrls?.isEmpty ?? true) || indexPath.row == (imagesWithUrls?.count ?? 0) {
                cell.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
                cell.crossButton.isHidden = true
            } else if let url = imagesWithUrls?[indexPath.row].url {
                cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
                cell.crossButton.isHidden = false
            }else if let image = imagesWithUrls?[indexPath.row].image {
                cell.imageViewOutlet.image = image
                cell.crossButton.isHidden = false
            }
            ///
            cell.crossButtonClosure = { [weak self] index in
                guard let self = self else { return }
                self.imageTapped?(.crossTapped, index)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellType {
        case .photos:
            if (photosModel?.isEmpty ?? true) || indexPath.row == (photosModel?.count ?? 0) {
                imageTapped?(.uploadImage, indexPath)
            }else {
                imageTapped?(.imageTapped, indexPath)
            }
        case .imagesWithUrls:
            if (imagesWithUrls?.isEmpty ?? true) || indexPath.row == (imagesWithUrls?.count ?? 0) {
                imageTapped?(.uploadImage, indexPath)
            }else {
                imageTapped?(.imageTapped, indexPath)
            }
        case .photosUrls, .portfolioImageUrl:
            imageTapped?(.imageTapped, indexPath)
        case .portfolioImageUrlWithAddMore:
            if (portfolioImageUrlWithAddMore?.isEmpty ?? true) || indexPath.row == (portfolioImageUrlWithAddMore?.count ?? 0) {
                imageTapped?(.uploadImage, indexPath)
            }else {
                imageTapped?(.imageTapped, indexPath)
            }
        default:
            break
        }
    }
}

//MARK:- UICollectionViewLayout
//=============================
extension CommonCollectionViewTableCell {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch cellType {
        case .tradeProfile, .loggedInBuilder:
            let title = collectionViewDataModel[indexPath.row].name
            let extraWidth: CGFloat = collectionViewDataModel[indexPath.row].type == .specialisation ? CGFloat.zero + 22 : (16 + 20 + 10 + 16)
            ///
            var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 12.0)])
            
            size.width += extraWidth
            size.height = size.height + abs(20)
            ///
            if size.width > collectionView.frame.size.width {
                size.width = collectionView.frame.size.width
            }
            return size
        case .photosUrls, .portfolioImageUrl, .portfolioImageUrlWithAddMore:
            /// (ScreenWidth - (24FromLeft + 24FromRight) - spacingOfEachCell) / noOfCells in each row
            let size: CGFloat = (kScreenWidth - 48 - 35)/3
            return CGSize(width: size, height: size)
        case .photos, .imagesWithUrls:
            return CGSize(width: 120, height: 100)
        }
    }
}

extension CommonCollectionViewTableCell {
    
    private func getCellSize(title: String) -> CGSize {
        var size = CGSize()
        
        /// Width:  (CollectionView width / 2) - leadingSpace
        size.width = (kScreenWidth - 48)/2 - 10
        
        /// Height:  (CollectionView width / 2) - horizontalSpace - buttonWidth - leadingSpace
        let rect = title.boundingRect(with: CGSize.init(width: (kScreenWidth/2) - 12 - 30 - 5, height: CGFloat.greatestFiniteMagnitude), options: ([NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading]), attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 16.0)], context: nil)
        size.height = rect.size.height + 20
        return size
    }
}
