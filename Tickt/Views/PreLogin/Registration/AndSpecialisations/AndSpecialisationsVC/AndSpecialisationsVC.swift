//
//  AndSpecialisationsVCViewController.swift
//  Tickt
//
//  Created by S H U B H A M on 08/03/21.
//

import UIKit
import TagCellLayout

class AndSpecialisationsVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///Nav View
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var watermarkLabel: CustomRegularLabel!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    ///
    @IBOutlet weak var signUpButton: UIButton!
      
    var isEdit = false
    var model: [SpecializationModel] = []
    var selectedSpecializationClosure: ((_ specializations: [SpecializationModel])->())?
    
    var oneLineHeight: CGFloat {
        return 32.0
    }
    
    var rightLeftSpacing: CGFloat {
        return 24
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case signUpButton:
            collectionViewOutlet.reloadData()
            let selectedList = model.filter {($0.isSelected ?? false)}
            if selectedList.count > 0 {
                kAppDelegate.signupModel.specializations = selectedList
                if kUserDefaults.isTradie() {
                    if isEdit {
                        selectedSpecializationClosure?(selectedList)
                        navigationController?.popViewController(animated: false)
                    } else {
                        let qualificationVC = AnyQualificationsVC.instantiate(fromAppStoryboard: .registration)
                        mainQueue { [weak self] in
                            self?.navigationController?.pushViewController(qualificationVC, animated: true)
                        }
                    }
                } else {
                    let companyDetailVC = CompanyDetailsVC.instantiate(fromAppStoryboard: .registration)
                    mainQueue { [weak self] in
                        self?.navigationController?.pushViewController(companyDetailVC, animated: true)
                    }
                }
            } else {
                CommonFunctions.showToastWithMessage(Validation.errorSpecializationEmpty)
            }
        default:
            break
        }
        disableButton(sender)
    }
}


extension AndSpecialisationsVC {
    
    private func initialSetup() {
        
        for list in kAppDelegate.signupModel.tradeList {
            model.append(contentsOf: list.specialisations ?? [])
        }
        watermarkLabel.isHidden = !(model.count == 0)
        collectionViewOutlet.isHidden = model.count == 0
        setupCollectionView()
        setupDotImage()
        if isEdit {
            signUpButton.setTitle("Save", for: .normal)
            dotImageView.isHidden = true
            screenTitleLabel.text = "Specialisations"
        }
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_6")
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_6")
        default:
            break
        }
    }
        
    private func setupCollectionView() {
        registerCell()
        collectionViewOutlet.contentInset.bottom = 40
        collectionViewOutlet.showsVerticalScrollIndicator = false
        collectionViewOutlet.showsHorizontalScrollIndicator = false
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
        let layout = TagCellLayout(alignment: .left, delegate: self)
        collectionViewOutlet.collectionViewLayout = layout
    }
    
    private func registerCell() {
        self.collectionViewOutlet.registerCell(with: SpecialisationsCollectionViewCell.self)
    }
}

//MARK:- CollectionDelegate
//=========================
extension AndSpecialisationsVC: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: SpecialisationsCollectionViewCell.self, indexPath: indexPath)
        cell.spelisationNameLabel.text = model[indexPath.row].name
        cell.spelisationNameLabel.font = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
        cell.spelisationNameLabel.textColor = (model[indexPath.row].isSelected ?? false) ? AppColors.pureWhite : AppColors.themeBlue
        cell.backView.backgroundColor = (model[indexPath.row].isSelected ?? false) ? AppColors.backGroundBlue : AppColors.backGorundWhite
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let status = model[indexPath.row].isSelected
        model[indexPath.row].isSelected = !(status ?? false)
        collectionViewOutlet.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension AndSpecialisationsVC: TagCellLayoutDelegate {
    
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        var size = textSize(text: model[index].name, font: UIFont.systemFont(ofSize: 12.0), collectionView: collectionViewOutlet)
        size.height = size.height - abs(32 - size.height) + 16
        size.width += (16+12)
        return size
    }
    
    func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
        var frame = collectionView.bounds
        frame.size.height = 9999.0
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
        var size = label.sizeThatFits(frame.size)
        size.height = max(self.oneLineHeight, size.height + self.rightLeftSpacing)
        return size
    }
}
