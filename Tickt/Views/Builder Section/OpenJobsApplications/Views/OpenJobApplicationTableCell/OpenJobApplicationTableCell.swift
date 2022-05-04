//
//  OpenJobApplicationTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 21/05/21.
//

import UIKit

class OpenJobApplicationTableCell: UITableViewCell {
    
    //MARK:- IB Outlets
    @IBOutlet weak var profilePicImageVIew: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var startImageVeiw: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var forwardBUtton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var collectionViewOutlet: DynamicHeightCollectionView!
    @IBOutlet weak var chipFlowLayout: ChipsCollectionViewFlowLayout!
    
    //MARK:- Variables
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath)->Void)? = nil
    private let chipsItemPadding: CGFloat = 16.0
    var applicationModel: OpenJobApplicationResult? {
        didSet {
            populateUI()
        }
    }
    private var collectionViewDataModel = [tradeSpecial]()
    
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
        guard  let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            self.buttonClosure?(index)
        }
    }
}

extension OpenJobApplicationTableCell {
    
    private func configureUI() {
        self.chipsCollectionFlowLayoutSetUp()
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionViewOutlet.registerCell(with: TradeSpecTableCell.self)
        self.collectionViewOutlet.isScrollEnabled = false
        self.collectionViewOutlet.reloadData()
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
        ///
    }
}

extension OpenJobApplicationTableCell {
    
    private func populateUI() {
        guard  let model = self.applicationModel else { return }
        userNameLabel.text = model.tradieName
        ratingLabel.text = "\(model.ratings), \(model.reviews) reviews"
        statusLabel.text = model.status.uppercased()
        profilePicImageVIew.sd_setImage(with: URL(string: model.tradieImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        ///
        collectionViewDataModel.removeAll()
        let _ = model.tradeData.map({ eachModel in
            let object: tradeSpecial = (eachModel.tradeSelectedUrl, eachModel.tradeName, .trade)
            collectionViewDataModel.append(object)
        })
        let _ = model.specializationData.map({ eachModel in
            let object: tradeSpecial = ("", eachModel.specializationName, .specialisation)
            collectionViewDataModel.append(object)
        })
        if let specialisationArray = CommonFunctions.getCountedSpecialisations(dataArray: collectionViewDataModel, count: 5) as? [tradeSpecial] {
            collectionViewDataModel = specialisationArray
        }
        
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
        self.collectionViewOutlet.reloadData()
    }
}

extension OpenJobApplicationTableCell: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: TradeSpecTableCell.self, indexPath: indexPath)
        cell.model = collectionViewDataModel[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = collectionViewDataModel[indexPath.row].name
        let extraWidth: CGFloat = collectionViewDataModel[indexPath.row].type == .specialisation ? CGFloat.zero + 23 : (16 + 20 + 10 + 14)
        ///
        var size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 12.0)])
        
        size.width += extraWidth
        size.height = size.height + abs(20)
        ///
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return size
    }
}
