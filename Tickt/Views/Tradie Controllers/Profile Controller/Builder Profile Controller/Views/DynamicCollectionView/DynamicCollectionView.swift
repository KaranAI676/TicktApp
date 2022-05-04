//
//  DynamicCollectionView.swift
//  Tickt
//
//  Created by S H U B H A M on 20/05/21.
//

import UIKit

class DynamicCollectionView: UITableViewCell {
    
    enum CellType {
        case profileDetail
        case openJobAppication
    }
    
    var areasOfJob: [AreasOfjob]? {
        didSet {
            dynamicCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var dynamicCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var chipCollectionViewFlowLayout: ChipsCollectionViewFlowLayout!
    
    var extraCellSize: CGSize = CGSize.zero
    var cellType: CellType = .profileDetail
    private let chipsItemPadding: CGFloat = 16.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        chipsCollectionFlowLayoutSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DynamicCollectionView {
    
    private func setupCollectionView() {
        dynamicCollectionView.registerCell(with: SpecialisationsCollectionViewCell.self)
        dynamicCollectionView.delegate = self
        dynamicCollectionView.dataSource = self
        dynamicCollectionView.isScrollEnabled = false
        dynamicCollectionView.reloadData()
    }
    
    private func chipsCollectionFlowLayoutSetUp() {
        chipCollectionViewFlowLayout.invalidateLayout()
        chipCollectionViewFlowLayout.minimumLineSpacing = chipsItemPadding
        chipCollectionViewFlowLayout.minimumInteritemSpacing = chipsItemPadding - 6
        chipCollectionViewFlowLayout.sectionHeadersPinToVisibleBounds = true
        chipCollectionViewFlowLayout.sectionFootersPinToVisibleBounds = true
        chipCollectionViewFlowLayout.headerReferenceSize = CGSize.zero
        chipCollectionViewFlowLayout.footerReferenceSize = CGSize.zero
        dynamicCollectionView.setNeedsLayout()
    }
}

extension DynamicCollectionView: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areasOfJob?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: SpecialisationsCollectionViewCell.self, indexPath: indexPath)        
        switch cellType {
        case .profileDetail:
            cell.topConstraint.constant = 0            
            cell.setUIForAreaOfJobs(specializationName: areasOfJob![indexPath.row].specializationName)
        default:
            break
        }
        return cell
    }
}

extension DynamicCollectionView {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var title = ""
        switch cellType {
        case .profileDetail:
            title = areasOfJob![indexPath.row].specializationName
        case .openJobAppication:
            title = ""
        }
        var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 12.0)])
        switch cellType {
        case .profileDetail:
            size.width += extraCellSize.width
            size.height = size.height + extraCellSize.height
        case .openJobAppication:
            size.width += extraCellSize.width
            size.height = size.height + abs(extraCellSize.height - size.height)
        }
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return size
    }
}

extension DynamicCollectionView {
    
    private func loadBuilderSpecialization(_ cellType: CellType) {
        
    }
}
