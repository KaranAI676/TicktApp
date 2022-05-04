//
//  AnyQualificationsVC.swift
//  Tickt
//
//  Created by S H U B H A M on 08/03/21.
//

import UIKit
import TagCellLayout

class AnyQualificationsVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var topbgView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    ///
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var watermarkLabel: UILabel!
    
    var isEdit = false
    var currentIndex = 0
    let viewModel = QualificationVM()
    var model: [SpecializationModel] = []
    var selectedImages = [(Data, String, Int, String, String)]() //Data, FileName, Index, Id, FileType
    var oneLineHeight: CGFloat {
        return 32.0
    }
    
    var rightLeftSpacing: CGFloat {
        return 45
    }
    
    var docArrayClosure: ((_ docArray: [QualificationDoc])->())?
    
    //MARK:- LifeCycle Methods
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
            let selectedList = model.filter {($0.isSelected ?? false)}
            if selectedList.count > 0 && selectedList.count == selectedImages.count {
                kAppDelegate.signupModel.docImages = selectedImages
                kAppDelegate.signupModel.qualifications = selectedList
                if isEdit {
                    viewModel.delegate = self
                    viewModel.uploadImages()
                } else {
                    goToAbnVC()
                }
            } else {
                CommonFunctions.showToastWithMessage("Please upload all the documents.")
            }
        case skipButton:
            goToAbnVC()
        default:
            break
        }
        disableButton(sender)
    }
    
    private func goToAbnVC() {
        let abnVC = AddAbnVC.instantiate(fromAppStoryboard: .registration)
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(abnVC, animated: true)
        }
    }
}

extension AnyQualificationsVC {
    
    private func initialSetup() {
        if isEdit {
            skipButton.isHidden = true
        }
        for list in kAppDelegate.signupModel.tradeList {
            model.append(contentsOf: list.qualifications ?? [])
        }
        
        if model.count == 0 {
            watermarkLabel.isHidden = false
        } else {
            watermarkLabel.isHidden = true
        }
        setupCollectionView()
        setupDotImage()
    }
    
    private func setupDotImage() {
        switch kUserDefaults.getUserType() {
        case 1: /// Tradie
            dotImageView.image = #imageLiteral(resourceName: "pgTradie_7")
            if isEdit {
                signUpButton.setTitle("Save", for: .normal)
                dotImageView.isHidden = true
            }
        case 2: /// Builder
            dotImageView.image = #imageLiteral(resourceName: "pgBuilder_4")
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
        collectionViewOutlet.registerCell(with: RatioButtonWithTitleCollectionViewCell.self)
    }
    
    private func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.photo, .gallery, .document]
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK:- CollectionDelegate
//=========================
extension AnyQualificationsVC: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: RatioButtonWithTitleCollectionViewCell.self, indexPath: indexPath)
        cell.titleLabel.text = self.model[indexPath.row].name
        let checkStatus = model[indexPath.row].isSelected ?? false
        cell.checkBoxButton.isSelected = checkStatus
        if checkStatus {
            cell.uploadDocumentButton.isUserInteractionEnabled = true
        } else {
            cell.uploadDocumentButton.isUserInteractionEnabled = false
        }
        cell.uploadDocumentButton.alpha = checkStatus ? 1 : 0.35
        cell.collectionView = collectionView
        
        let uploadStatus = model[indexPath.row].isUploaded ?? false
        if uploadStatus {
            cell.imageLabel.text = "Doc \(indexPath.row + 1)"
            cell.uploadedView.isHidden = false
            cell.deleteImageButton.isHidden = false
        } else {
            cell.uploadedView.isHidden = true
            cell.deleteImageButton.isHidden = true
        }
        
        cell.buttonClosure = { [weak self] (index) in
            guard let self = self else { return }
            let status = self.model[index.row].isSelected ?? false
            self.model[index.row].isSelected = !status
            if !status {
                self.collectionViewOutlet.reloadItems(at: [index])
            } else {
                if (self.model[index.row].isUploaded ?? false) {
                    self.deleteAlert(indexPath: index)
                } else {
                    self.collectionViewOutlet.reloadItems(at: [index])
                }
            }
        }
        
        cell.uploadButtonAction = { [weak self] (index) in
            self?.currentIndex = index.row
            self?.goToCommonPopupVC()
        }
        
        cell.deleteImageButtonAction = { [weak self] index in
            self?.deleteAlert(indexPath: index)
        }
        return cell
    }
        
    private func deleteAlert(indexPath: IndexPath) {
        
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton,
                                             alertTitle: "DELETE",
                                             alertMessage: "Are you sure?\n you want to delete this document.",
                                             acceptButtonTitle: "Ok",
                                             declineButtonTitle: "Cancel") { [weak self] in
            self?.deleteImage(indexPath: indexPath)
        } dismissCompletion: { }
    }
    
    private func deleteImage(indexPath: IndexPath) {
        model[indexPath.row].isSelected = false
        model[indexPath.row].isUploaded = false
        let objectIndex = selectedImages.firstIndex { (image, name, index, id, mimeType) -> Bool in
            return index == indexPath.row
        }
        if objectIndex != nil {
            selectedImages.remove(at: objectIndex!)
            mainQueue { [weak self] in
                self?.collectionViewOutlet.reloadItems(at: [indexPath])
            }
        }
    }
}

//MARK:- TagCellLayoutDelegate
//============================
extension AnyQualificationsVC: TagCellLayoutDelegate {

    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        let widthFactor = (kScreenWidth / 320) > 1.2 ? 1.2 : (kScreenWidth / 320)
        var size = textSize(text: model[index].name, font: UIFont.kAppDefaultFontMedium(ofSize: 13 * widthFactor), collectionView: collectionViewOutlet)
        size.height += 8.0
        size.width = self.model.count > 1 ? self.collectionViewOutlet.bounds.width : self.collectionViewOutlet.bounds.width
        return size
    }

    func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
        ///
        var frame = collectionView.bounds
        frame.size.height = 9999.0
        ///
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
        var size = label.sizeThatFits(frame.size)
        size.height = max(self.oneLineHeight, size.height + self.rightLeftSpacing)
        return size
    }
}
