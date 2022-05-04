//
//  DynamicHeightCollectionViewTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 26/03/21.
//

import UIKit

class DynamicHeightCollectionViewTableCell: UITableViewCell {
    
    enum CellType {
        case trade
        case jobType
        case jobDetail
        case specialisation
        case activeJobDetail
        case specialisationDetail
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewOutlet: DynamicHeightCollectionView!
    @IBOutlet weak var chipsCollectionViewFlowLayout: ChipsCollectionViewFlowLayout!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBackView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    var isJobDetail: Bool? {
        didSet {
            editButton.isHidden = isJobDetail ?? false
        }
    }
    
    var jobTypeModel = [ResulDateObject]() { didSet { self.collectionViewOutlet.reloadData() }}
    var specialisationModel = [SpecializationModel]() { didSet { self.collectionViewOutlet.reloadData() }}
    var specialisationArray = [SpecializationData]() { didSet { self.collectionViewOutlet.reloadData() }}
    var jobTypeDetailModel = [JobTypeData]() { didSet { self.collectionViewOutlet.reloadData() }}
    var didSelectClosure: ((CellType, IndexPath, Bool)->(Void))? = nil
    var titleLabelFont: UIFont = UIFont.kAppDefaultFontBold(ofSize: 18)
    var cellFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
    var isSelectionEnable: Bool = true
    var extraCellSize: CGSize = CGSize.zero
    private var cellType: CellType = .jobType
    ///
    private let chipsItemPadding: CGFloat = 16.0
    
    //MARK:- Variables
    var editButtonClosure: (()->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.editButtonClosure?()
    }
}

extension DynamicHeightCollectionViewTableCell {
    
    private func configureUI() {
        self.titleLabel.font = titleLabelFont
        self.chipsCollectionFlowLayoutSetUp()
        self.setupCollectionView()
        self.selectionStyle = .none
    }
    
    private func setupCollectionView() {
        collectionViewOutlet.registerCell(with: JobCell.self)
        collectionViewOutlet.registerCell(with: JobTypeCollectionViewCell.self)
        collectionViewOutlet.registerCell(with: SpecialisationsCollectionViewCell.self)
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.isScrollEnabled = false
        collectionViewOutlet.reloadData()
    }
    
    private func chipsCollectionFlowLayoutSetUp() {
        self.chipsCollectionViewFlowLayout.invalidateLayout()
        self.chipsCollectionViewFlowLayout.minimumLineSpacing = self.chipsItemPadding
        self.chipsCollectionViewFlowLayout.minimumInteritemSpacing = self.chipsItemPadding
        self.chipsCollectionViewFlowLayout.sectionHeadersPinToVisibleBounds = true
        self.chipsCollectionViewFlowLayout.sectionFootersPinToVisibleBounds = true
        self.chipsCollectionViewFlowLayout.headerReferenceSize = CGSize.zero
        self.chipsCollectionViewFlowLayout.footerReferenceSize = CGSize.zero
        self.collectionViewOutlet.setNeedsLayout()
    }
}

//MARK:- UIPopulation
//===================
extension DynamicHeightCollectionViewTableCell {

    func populateUI(title: String, dataArray: [JobTypeData], cellType: CellType) {
        self.cellType = cellType
        titleLabel.text = title
        isSelectionEnable = false
        jobTypeDetailModel = dataArray
    }
    
    func populateUI(title: String, dataArray: [ResulDateObject], cellType: CellType) {
        self.cellType = cellType
        self.titleLabel.text = title
        self.jobTypeModel = dataArray
    }
    
    func populateUI(title: String, dataArray: [SpecializationModel], cellType: CellType) {
        self.cellType = cellType
        self.titleLabel.text = title
        self.specialisationModel = dataArray
    }
    
    func populateUI(title: String, dataArray: [SpecializationData], cellType: CellType) {
        self.cellType = cellType
        titleLabel.text = title
        specialisationArray = dataArray
    }
}


//MARK:- Extensions
//MARK:============
extension DynamicHeightCollectionViewTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch cellType {
        case .jobType:
            return jobTypeModel.count
        case .specialisation:
            return specialisationModel.count
        case .jobDetail, .activeJobDetail:
            return jobTypeDetailModel.count
        case .specialisationDetail:
            return specialisationArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        switch cellType {
        case .jobType, .jobDetail:
            return getJobTypeCell(collectionView: collectionView, indexPath: indexPath)
        case .specialisation, .specialisationDetail:
            return getSpecialisationCell(collectionView: collectionView, indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellType {
        case .jobType:
            self.jobTypeModel[indexPath.row].isSelected = !self.jobTypeModel[indexPath.row].isSelected
            self.didSelectClosure?(cellType, indexPath, self.jobTypeModel[indexPath.row].isSelected)
        case .specialisation:
            self.specialisationModel[indexPath.row].isSelected = !(self.specialisationModel[indexPath.row].isSelected ?? false)
            self.didSelectClosure?(cellType, indexPath, self.specialisationModel[indexPath.row].isSelected ?? false)
        default:
            break
        }
    }
}

// MARK: - ChipsCollectionViewLayoutDelegate
//==========================================
extension DynamicHeightCollectionViewTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var title = ""
        switch cellType {
        case .jobType:
            title = self.jobTypeModel[indexPath.row].name
        case .specialisation:
            title = self.specialisationModel[indexPath.row].name
        case .jobDetail, .activeJobDetail:
            title = self.jobTypeDetailModel[indexPath.row].jobTypeName
        case .specialisationDetail:
            title = self.specialisationArray[indexPath.row].specializationName
        default:
            break
        }
        ///
        var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 12.0)])
        switch cellType {
        case .jobType, .jobDetail:
            size.width += extraCellSize.width
            size.height = size.height + extraCellSize.height
        case .specialisation, .specialisationDetail:
            size.width += extraCellSize.width
            size.height = size.height + abs(extraCellSize.height - size.height)
        default:
            break
        }
        ///
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return size
    }
}


//MARK:- CellForItemAt: Return CollectionViewCell
//===============================================
extension DynamicHeightCollectionViewTableCell {
    
    func getJobCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCell.defaultReuseIdentifier, for: indexPath) as? JobCell else {
            return UICollectionViewCell()
        }

        cell.jobTypeLabel.text = jobTypeDetailModel[indexPath.row].jobTypeName
        cell.jobImageView.sd_setImage(with: URL(string:(jobTypeDetailModel[indexPath.row].jobTypeName)), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
            let resizedImage = image?.resized(toWidth: kScreenWidth * 0.5, isOpaque: false)
            cell.jobImageView.image = resizedImage
        }
        return cell
    }
    
    private func getJobTypeCell(collectionView: UICollectionView, indexPath: IndexPath) -> JobTypeCollectionViewCell {
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
        } else {
            let model = jobTypeDetailModel[indexPath.row]
            cell.spelisationNameLabel.text = model.jobTypeName
            cell.backView.backgroundColor = UIColor(hex: "#F7F8FA")
            cell.imageViewOutlet.sd_setImage(with: URL(string:(model.jobTypeImage)), placeholderImage: nil)
        }
        return cell
    }
    
    private func getSpecialisationCell(collectionView: UICollectionView, indexPath: IndexPath) -> SpecialisationsCollectionViewCell {
        let cell = collectionView.dequeueCell(with: SpecialisationsCollectionViewCell.self, indexPath: indexPath)
        cell.topConstraint.constant = 0
        cell.rightConstrint.constant = 0
        cell.spelisationNameLabel.font = cellFont
        if cellType == .specialisation {
            let model = specialisationModel[indexPath.row]
            cell.spelisationNameLabel.text = model.name
            cell.spelisationNameLabel.textColor = isSelectionEnable ? ((model.isSelected ?? false) ? AppColors.pureWhite : AppColors.themeBlue) : AppColors.themeBlue
            cell.backView.backgroundColor = isSelectionEnable ? ((model.isSelected ?? false) ? AppColors.backGroundBlue : AppColors.backGorundWhite) : AppColors.backGorundWhite
        } else {
            let model = specialisationArray[indexPath.row]
            cell.spelisationNameLabel.text = model.specializationName
            cell.spelisationNameLabel.textColor = AppColors.themeBlue
            cell.backView.backgroundColor = AppColors.appGrey
        }
        return cell
    }
}
