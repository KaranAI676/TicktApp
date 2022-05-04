//
//  WhatIsYourTradeVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/03/21.
//

import UIKit
import SDWebImage

class WhatIsYourTradeVC: BaseVC {
    
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///Nav View
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    ///
    @IBOutlet weak var signUpButton: UIButton!
    
    var isEdit = false
    var viewModel = TradeVM()
    var tradeModel: TradeModel?
    var selectedSpecializationClosure: ((_ specializations: [SpecializationModel], _ trade: TradeDataModel)->())?
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case self.backButton:
            pop()
        case self.signUpButton:
            if let list = tradeModel?.result?.trade, list.count > 0 {
                let selecedTrade = list.filter {$0.isSelected}
                if selecedTrade.count > 0 {
                    kAppDelegate.signupModel.tradeList = selecedTrade
                    let specializationVC = AndSpecialisationsVC.instantiate(fromAppStoryboard: .registration)
                    specializationVC.isEdit = isEdit
                    specializationVC.selectedSpecializationClosure = { [weak self] specializations in
                        let trade = selecedTrade.first
                        var object = TradeDataModel()
                        object.tradeId = trade?.id ?? ""
                        object.tradeSelectedUrl = trade?.selectedUrl ?? ""
                        object.tradeName = trade?.tradeName ?? ""
                        self?.selectedSpecializationClosure?(specializations, object)
                        self?.pop()
                    }
                    mainQueue { [weak self] in
                        self?.navigationController?.pushViewController(specializationVC, animated: true)
                    }
                } else {
                    CommonFunctions.showToastWithMessage(Validation.errorSelectTrade)
                }
            } else {
                CommonFunctions.showToastWithMessage(Validation.errorSelectTrade)
            }
        default:
            break
        }
        disableButton(sender)
    }    
}

//MARK:- Private Methods
//======================
extension WhatIsYourTradeVC {
    
    private func initialSetup() {
        setupCollectionView()
        viewModel.delegate = self
        viewModel.getTradeList()
        setDefaultText()
        setupDotImage()
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_5")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_5")
        default:
            break
        }
    }
    
    private func setDefaultText() {
        switch kUserDefaults.getUserType() {
        case 1:
            self.screenTitleLabel.text = "What is your trade?"
        case 2:
            self.screenTitleLabel.text = "Trade you used most"
        default:
            break
        }
    }
    
    private func registerCell() {
        collectionViewOutlet.registerCell(with: tradeCollectionViewCell.self)
    }
    
    private func setupCollectionView() {
        registerCell()
        collectionViewOutlet.contentInset.bottom = 40
        collectionViewOutlet.showsVerticalScrollIndicator = false
        collectionViewOutlet.showsHorizontalScrollIndicator = false
        let size = (kScreenWidth - 60) / 3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: size, height: size)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        collectionViewOutlet.setCollectionViewLayout(layout, animated: false)
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
    }
}

//MARK:- CollectionDelegate
//=========================
extension WhatIsYourTradeVC: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tradeModel?.result?.trade?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: tradeCollectionViewCell.self, indexPath: indexPath)
        cell.tradeNameLabel.text = tradeModel?.result?.trade![indexPath.item].tradeName
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
            cell.tradeImageView.backgroundColor = UIColor(hex: "#0B41A8")
        } else {
            cell.tradeImageView.backgroundColor = UIColor(hex: "#D5E5EF")
        }
        return cell
    }        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (kScreenWidth - 60) / 3
        return CGSize(width: size, height: size + 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = tradeModel?.result?.trade?.firstIndex(where: { ($0.isSelected ) })
        if index != nil {
            tradeModel?.result?.trade![index!].isSelected = false
            collectionViewOutlet.reloadItems(at: [IndexPath(item: index!, section: 0)])
            if index != indexPath.item {
                tradeModel?.result?.trade![indexPath.item].isSelected = true
            }
            collectionViewOutlet.reloadItems(at: [indexPath])
        } else {
            tradeModel?.result?.trade![indexPath.item].isSelected = true
            collectionViewOutlet.reloadItems(at: [indexPath])
        }
    }
}
