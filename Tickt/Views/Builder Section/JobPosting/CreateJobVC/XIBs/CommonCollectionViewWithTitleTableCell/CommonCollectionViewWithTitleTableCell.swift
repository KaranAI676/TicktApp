//
//  CommonCollectionViewTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 22/03/21.
//

import UIKit

class CommonCollectionViewWithTitleTableCell: UITableViewCell {

    enum CellType {
        case jobPreivew
        case trades
        case images
        case jobDetail
        case activeJobDetail
        case savedTradies
        case jobType
        case commonJobDetail
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    ///
    @IBOutlet weak var stackViewOutlet: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    ///
    @IBOutlet weak var titleLabelBackView: UIView!
    @IBOutlet weak var editBackView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottpmConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionVIewHeightConst: NSLayoutConstraint!
    
    //MARK:- Variables
    var isSelectionEnable: Bool = false
    var cellFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
    var didSelectClosure: ((CellType, IndexPath, Bool)->(Void))? = nil
    var savedTradiesModel = [SavedTradies]()  { didSet { collectionViewOutlet.reloadData() }}
    var isJobDetail: Bool? {
        didSet {
            editButton.isHidden = isJobDetail ?? false
        }
    }
    var editButtonClosure: (()->(Void))? = nil
    var saveTradieClosure: ((IndexPath)->Void)? = nil
    var modelUpdateClosure: ((Bool, Int) -> (Void))? = nil
    var photoPreviewAction: ((_ urlString: String) -> ())? = nil
    var imagePreviewAction: ((_ image: UIImage) -> ())? = nil
    var imagePreviewWithUrlAction: ((_ image: UIImage?, _ url: URL?) -> ())? = nil
    var docPreviewAction: ((_ url: URL) -> ())? = nil
    var videoPreviewAction: ((_ url: URL) -> ())? = nil
    var cellType: CellType = .trades
    var imagesModel = [(UIImage, MediaTypes, URL?)]() {
        didSet {
            self.collectionViewOutlet.reloadData()
        }
    }
    var model = [TradeList]() {
        didSet {
            self.collectionViewOutlet.reloadData()
        }
    }
    var builderTradeModel = [SavedTradies]() {
        didSet {
            self.collectionViewOutlet.reloadData()
        }
    }
    
    var photosArray = [PhotosObject]() {
        didSet {
            self.collectionViewOutlet.reloadData()
        }
    }
    
    var jobTypeModel = [ResulDateObject]() {
        didSet {
            self.collectionViewOutlet.reloadData()
        }
    }
    var jobPreviewImages = [UploadMediaObject]() {
        didSet {
            self.collectionViewOutlet.reloadData()
        }
    }
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Action
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.editButtonClosure?()
    }
}

extension CommonCollectionViewWithTitleTableCell {
    
    private func configUI() {
        self.selectionStyle = .none
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
        ///
        self.collectionViewOutlet.registerCell(with: tradeCollectionViewCell.self)
        self.collectionViewOutlet.registerCell(with: ImageViewCollectionCell.self)
        self.collectionViewOutlet.registerCell(with: JobTypeCollectionViewCell.self)
        self.collectionViewOutlet.registerCell(with: TradePeopleCollectionViewCell.self)
    }
}

extension CommonCollectionViewWithTitleTableCell {
    
    func populateUI(title: String, dataArray: [TradeList]?) {
        self.titleLabel.text = title
        self.cellType = .trades
        if let dataArray = dataArray {
            self.model = dataArray
        }
    }
    
    func populateUI(title: String, dataArray: [(UIImage, MediaTypes, URL?)]?) {
        self.titleLabel.text = title
        self.cellType = .images
        if let dataArray = dataArray {
            self.imagesModel = dataArray
        }
    }
    
    func populateUI(title: String, dataArray: [UploadMediaObject]?) {
        self.titleLabel.text = title
        self.cellType = .jobPreivew
        if let dataArray = dataArray {
            self.jobPreviewImages = dataArray
        }
    }
    
    func populateUI(title: String, saveTradies: [SavedTradies]) {
        self.titleLabel.text = title
        self.cellType = .savedTradies
        self.savedTradiesModel = saveTradies
    }
    
    func populateUIFromUrlArray(title: String, dataArray: [PhotosObject]) {
        titleLabel.text = title
        cellType = .jobDetail
        photosArray = dataArray
    }
    
    func populateUIFromUrlsArray(title: String, dataArray: [PhotosObject]) {
        titleLabel.text = title
        cellType = .commonJobDetail
        photosArray = dataArray
    }
    
    func populateUI(title: String, dataArray: [ResulDateObject], isSelectionEnable: Bool = true) {
        titleLabel.text = title
        cellType = .jobType
        self.isSelectionEnable = isSelectionEnable
        jobTypeModel = dataArray
    }
    
    func setClearBg() {
        self.collectionViewOutlet.backgroundColor = .clear
        self.mainContainerView.backgroundColor = .clear
        self.containerView.backgroundColor = .clear
        self.titleLabelBackView.backgroundColor = .clear
        self.editBackView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
}

extension CommonCollectionViewWithTitleTableCell: CollectionDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellType {
        case .trades:
            return self.model.count
        case .images:
            return imagesModel.count
        case .savedTradies:
            return self.savedTradiesModel.count
        case .jobDetail, .activeJobDetail, .commonJobDetail:
            return photosArray.count
        case .jobType:
            return jobTypeModel.count
        case .jobPreivew:
            return jobPreviewImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType {
        case .trades:
            let cell = collectionView.dequeueCell(with: tradeCollectionViewCell.self, indexPath: indexPath)
            cell.tradeNameLabel.text = self.model[indexPath.row].tradeName
            let status = self.model[indexPath.item].isSelected
                        
            cell.iconImageView.sd_setImage(with: URL(string:(self.model[indexPath.item].selectedUrl ?? "")), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
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
            cell.tradeImageView.backgroundColor = UIColor(hex: "#0B41A8")
            
            cell.selectedImageView.isHidden = !status
            cell.tradeNameLabel.numberOfLines = 1
            return cell
        case .images, .jobDetail, .activeJobDetail, .commonJobDetail:
            let cell = collectionView.dequeueCell(with: ImageViewCollectionCell.self, indexPath: indexPath)
            cell.collectionView = collectionView
            cell.rightConstraint.constant = 0
            cell.crossButton.isHidden = true
            if cellType == .images {
                cell.playButton.isHidden = !(self.imagesModel[indexPath.row].1 == .video)
                cell.imageViewOutlet.image = imagesModel[indexPath.row].0
                cell.playButtonClosure = { [weak self] (index) in
                    guard let self = self else { return }
                    if let url = self.imagesModel[index.row].2 {
                        self.videoPreviewAction?(url)
                    }
                }
            } else {
                cell.playButton.isHidden = !(photosArray[indexPath.row].mediaType == 2)
                cell.playButtonClosure = { [weak self] (index) in
                    guard let self = self else { return }
                    if let url = URL(string: self.photosArray[index.row].link) {
                        self.videoPreviewAction?(url)
                    }
                }
                ///
                if let mediaType = MediaTypes.init(rawValue: photosArray[indexPath.row].mediaType) {
                    CommonFunctions.setMediaImage(cell.imageViewOutlet, type: mediaType, url: photosArray[indexPath.row])
                }else {
                    cell.imageViewOutlet.image = UIImage()
                }
            }
            return cell
        case .savedTradies:
            let cell = collectionView.dequeueCell(with: TradePeopleCollectionViewCell.self, indexPath: indexPath)
            cell.collectionView = collectionView
            cell.extraTradeCellSize = CGSize(width: (71), height: 32)
            cell.extraSpecCellSize = CGSize(width: (16), height: 32)
            ///
            if let specialisationArray: [BuilderHomeSpecialisation] = CommonFunctions.getCountedSpecialisations(dataArray: self.savedTradiesModel[indexPath.row].specializationData) as? [BuilderHomeSpecialisation] {
                cell.populateUI(dataArrayTrade: self.savedTradiesModel[indexPath.row].tradeData, dataArraySpecialisation: specialisationArray)
            }
            cell.userNameLabel.text = self.savedTradiesModel[indexPath.row].tradieName
            cell.ratingLabel.text = "\(self.savedTradiesModel[indexPath.row].ratings) | \(self.savedTradiesModel[indexPath.row].reviews) reviews"
            cell.roleLabel.text = self.savedTradiesModel[indexPath.row].tradeData.first?.tradeName
            cell.lblBusinessName.text = self.savedTradiesModel[indexPath.row].businessName
            cell.profileImageVIew.sd_setImage(with: URL(string:(self.savedTradiesModel[indexPath.row].tradieImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            cell.buttonClosure = { [weak self] (index) in
                guard let self  = self else { return }
                self.saveTradieClosure?(index)
            }
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            cell.updateConstraints()
            return cell
        case .jobType:
            let cell = collectionView.dequeueCell(with: JobTypeCollectionViewCell.self, indexPath: indexPath)
            cell.spelisationNameLabel.font = cellFont
            if cellType == .jobType {
                let model = jobTypeModel[indexPath.row]
                cell.spelisationNameLabel.text = model.name
                cell.spelisationNameLabel.textColor = isSelectionEnable ? ((model.isSelected) ? AppColors.pureWhite : AppColors.themeBlue) : AppColors.themeBlue
                var downloadedImage: UIImage?
                cell.imageViewOutlet.sd_setImage(with: URL(string:(model.image)), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
                    downloadedImage = image
                    if model.isSelected, self.isSelectionEnable {
                        cell.imageViewOutlet.image = downloadedImage?.imageWithColor(UIColor(hex: "#FEE600"))
                    } else {
                        cell.imageViewOutlet.image = downloadedImage
                    }
                }
                cell.backView.backgroundColor = isSelectionEnable ? ((model.isSelected) ? AppColors.backGroundBlue : AppColors.backViewGrey) : AppColors.backViewGrey
            }
            return cell
        case .jobPreivew:
            let cell = collectionView.dequeueCell(with: ImageViewCollectionCell.self, indexPath: indexPath)
            cell.collectionView = collectionView
            cell.rightConstraint.constant = 0
            cell.crossButton.isHidden = true
            cell.playButton.isHidden = !(jobPreviewImages[indexPath.row].type == .video)
            ///
            switch jobPreviewImages[indexPath.row].type {
            case .image:
                if let url = jobPreviewImages[indexPath.row].genericUrl {
                    cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
                }else {
                    cell.imageViewOutlet.image = jobPreviewImages[indexPath.row].image
                }
            case .video:
                if let url = jobPreviewImages[indexPath.row].genericThumbnail {
                    cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
                }else {
                    cell.imageViewOutlet.image = jobPreviewImages[indexPath.row].image
                }
            case .doc, .pdf:
                cell.imageViewOutlet.image = jobPreviewImages[indexPath.row].image
            }
            ///
            cell.playButtonClosure = { [weak self] (index) in
                guard let self = self else { return }
                if let urlString = self.jobPreviewImages[indexPath.row].genericUrl, let url = URL(string: urlString) {
                    self.videoPreviewAction?(url)
                }else if let url = self.jobPreviewImages[indexPath.row].videoUrl {
                    self.videoPreviewAction?(url)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType {
        case .trades:
            return CGSize(width: 100, height: 130)
        case .images, .jobDetail, .activeJobDetail, .commonJobDetail, .jobPreivew:
            return CGSize(width: 100, height: 112)
        case .savedTradies:
            return CGSize(width: UIDevice.width-24-34, height: 122)
        case .jobType:
            let title = jobTypeModel[indexPath.row].name
            var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 12.0)])
            size.width += (36 + 6 + 12 + 10)
            size.height += 45
            return CGSize(width: (size.width), height: size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellType {
        case .trades:
            self.model[indexPath.row].isSelected = !(self.model[indexPath.row].isSelected )
            self.modelUpdateClosure?(self.model[indexPath.row].isSelected, indexPath.row)
        case .commonJobDetail, .jobDetail, .activeJobDetail:
            switch photosArray[indexPath.row].mediaType {
            case 1:
                photoPreviewAction?(photosArray[indexPath.row].link)
            case 3, 4:
                if let url = URL(string: photosArray[indexPath.row].link) {
                    self.docPreviewAction?(url)
                }
            default:
                break
            }
        case .images:
            switch imagesModel[indexPath.row].1 {
            case .doc, .pdf:
                if let url = imagesModel[indexPath.row].2 {
                    self.docPreviewAction?(url)
                }
            case .image:
                self.imagePreviewAction?(imagesModel[indexPath.row].0)
            default:
                break
            }
        case .jobPreivew:
            switch jobPreviewImages[indexPath.row].type {
            case .doc, .pdf:
                if let urlString = jobPreviewImages[indexPath.row].genericUrl, let url = URL(string: urlString) {
                    self.docPreviewAction?(url)
                }else if let url = URL(string: jobPreviewImages[indexPath.row].finalUrl) {
                    self.docPreviewAction?(url)
                }
            case .image:
                self.imagePreviewWithUrlAction?(jobPreviewImages[indexPath.row].image, URL(string: jobPreviewImages[indexPath.row].genericUrl ?? ""))
            default:
                break
            }
        case .jobType:
            self.jobTypeModel[indexPath.row].isSelected = !self.jobTypeModel[indexPath.row].isSelected
            self.didSelectClosure?(cellType, indexPath, self.jobTypeModel[indexPath.row].isSelected)
        default:
            break
        }
    }
}
