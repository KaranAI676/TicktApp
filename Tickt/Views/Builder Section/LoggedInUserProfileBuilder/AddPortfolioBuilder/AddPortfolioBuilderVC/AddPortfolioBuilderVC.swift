//
//  AddPortfolioBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import UIKit
import AssetsPickerViewController
import PhotosUI

struct AddPortfolioBuilderModel {
    
    var id: String = ""
    var images = [(String?, UIImage?)]()
    var jobName: String = ""
    var jobDescription: String = ""
}

protocol AddPortfolioBuilderVCDelegate: AnyObject {
    func getUpdatedPortfolios(model: PortfoliaData)
}

class AddPortfolioBuilderVC: BaseVC {

    enum SectionArray: String {
        case images
        case jobName = "Job Name"
        case jobDescription = "Job Description(Optional)"
        case uploadPlaceHolder
        
        var height: CGFloat {
            switch self {
            case .jobName, .jobDescription:
                return 30
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
        
        var placeholder: String {
            switch self {
            case .jobName:
                return "Enter job name.."
            case .jobDescription:
                return "Describe your job.."
            default:
                return ""
            }
        }
        
        var color: UIColor {
            switch self {
            default:
                return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            }
        }
        
        var capitalization: UITextAutocapitalizationType {
            switch self {
            case .jobName:
                return .words
            case .jobDescription:
                return .sentences
            default:
                return .none
            }
        }
        
        var font: UIFont {
            switch self {
            default:
                return UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var viewModel = AddPortfolioBuilderVM()
    var model = AddPortfolioBuilderModel()
    var sectionArray: [SectionArray] = []
    var assets = [PHAsset]()
    var maxImagesLimit = 6
    weak var delegate: AddPortfolioBuilderVCDelegate? = nil
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case continueButton:
            if validate() {
                viewModel.uploadImages(array: model.images)
            }
        default:
            break
        }
        disableButton(sender)
    }
}

extension AddPortfolioBuilderVC {
    
    func initialSetup() {
        viewModel.delegate = self
        setupTableView()
    }
    
    private func setupTableView() {
        if kUserDefaults.isTradie() {
            descriptionLabel.text = "Tradies who have a portfolio with photos get job faster. "
        } else {
            descriptionLabel.text = "Showcase your work and attract the best talent to your jobs."
        }
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: UploadImageTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: ReasonsTableViewCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        CommonFunctions.showActivityLoader()
        CommonFunctions.delay(delay: 0.2, closure: {
            self.tableViewOutlet.reloadData()
            CommonFunctions.hideActivityLoader()
        })
    }
    
    func goToCommonPopupVC() {
       let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
       vc.modalPresentationStyle = .overCurrentContext
       vc.delegate = self
       vc.isAnimated = true
       vc.buttonTypeArray = [.photo, .gallery]
       mainQueue { [weak self] in
           self?.navigationController?.present(vc, animated: true, completion: nil)
       }
   }
    
    ///To open AssetPicker
    func showImagePicker() {
        let picker = AssetsPickerViewController()
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private func getSectionArray() -> [SectionArray] {
        var sectionArray: [SectionArray] = []
        if model.images.isEmpty {
            sectionArray.append(.uploadPlaceHolder)
        } else {
            sectionArray.append(.images)
        }
        sectionArray.append(.jobName)
        sectionArray.append(.jobDescription)
        
        self.sectionArray = sectionArray
        return sectionArray
    }
    
    private func validate() -> Bool {
        
        if model.images.isEmpty {
            CommonFunctions.showToastWithMessage("Please choose image")
            return false
        }
        
        if model.jobName.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter job name")
            return false
        }
        
//        if model.jobDescription.isEmpty {
//            CommonFunctions.showToastWithMessage("Please enter job description")
//            return false
//        }
//        
        return true
    }
}

extension AddPortfolioBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return getSectionArray().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .jobName, .jobDescription:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.tableView = tableView
            cell.topConstraint.constant = 2
            cell.commonTextFiled.placeholder = sectionArray[indexPath.section].placeholder
            cell.commonTextFiled.autocapitalizationType = sectionArray[indexPath.section].capitalization
            cell.commonTextFiled.delegate = self
            ///
            switch self.sectionArray[indexPath.section] {
            case .jobName:
                cell.commonTextFiled.text = model.jobName
            case.jobDescription:
                cell.commonTextFiled.text = model.jobDescription
            default:
                break
            }
            ///
            cell.updateTextWithIndexClosure = { [weak self] (text, index) in
                guard let self = self else { return }
                switch self.sectionArray[index.section] {
                case .jobName:
                    self.model.jobName = text
                case.jobDescription:
                    self.model.jobDescription = text
                default:
                    break
                }
            }
            return cell
        case .images:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.imagesWithUrls = model.images
            cell.maxMediaCanAllow = 6
            cell.imageTapped = { [weak self] (tappedType, index) in
                guard let self = self else { return }
                switch tappedType {
                case .imageTapped:
                    break
                case .uploadImage:
                    self.goToCommonPopupVC()
                case .crossTapped:
                    self.model.images.remove(at: index.row)
                    self.tableViewOutlet.reloadData()
                }
            }
            cell.layoutIfNeeded()
            return cell
        case .uploadPlaceHolder:
            let cell = tableView.dequeueCell(with: UploadImageTableCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section] {
        case .uploadPlaceHolder:
            self.goToCommonPopupVC()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = sectionArray[section].rawValue
        header.headerLabel.textColor = sectionArray[section].color
        header.headerLabel.font = sectionArray[section].font
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}

extension AddPortfolioBuilderVC: CommonButtonDelegate {
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        showImagePicker()
//        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
}


//MARK:- Extension for Image Picker
//=================================
extension AddPortfolioBuilderVC: AssetsPickerViewControllerDelegate {
    
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        printDebug("Need permission to access photo library.")
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        printDebug("Cancelled.")
    }
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        self.assets = assets
        var itemNumber = 0
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        

        
        for asset in self.assets {
            printDebug(asset)
            if asset.mediaType == .image {
                manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { [weak self] (image, _) in
                    
                    guard let `self` = self else { return }
                    guard let galleryImage = image else { return }
                    self.model.images.append((nil, image))
                    self.tableViewOutlet.reloadData()
//
//                    self.imageArray.append((galleryImage, .image, nil, "", .imageJpeg, nil, nil))
//                    self.setupFlowLayout()
//                    self.collectionViewOutlet.reloadData()

//                    let imageModel = MediaModel()
//                    imageModel.imageName = "\(Int(Date().timeIntervalSince1970))\(itemNumber).png"
//                    imageModel.image = image
//                    imageModel.mediaType = .image
//                    imageModel.progress = 0.1
//                    self.mediaModelList.append(imageModel)
//                    DispatchQueue.main.async {
//                        self.createPostView.mediaCollectionView.reloadData()
//                    }
//                    self.hitUploadImageApi(model: imageModel)
//                    itemNumber += 1
                }
            } else {
            }
        }
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        printDebug("shouldSelect: \(indexPath.row)")
        if (controller.selectedAssets.count + model.images.count) + 1 > (maxImagesLimit) {
            CommonFunctions.showToastWithMessage("Max limit reached")
            return false
        } else {
            return true

        }
        /// can limit selection count
//        if controller.selectedAssets.count > (4 - self.mediaModelList.count) {
//            /// do your job here
//            printDebug("You can select maximum 5 items")
//            CommonFunctions.showToastWithMessage(StringConstant.youCanSelectMax5Items.value)
//            return false
//        } else {
//            if asset.mediaType == .video {
//                let resources = PHAssetResource.assetResources(for: asset) // your PHAsset
//
//                var sizeOnDisk: Int64? = 0
//
//                if let resource = resources.first {
//                    let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
//                    sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
//                    if ((sizeOnDisk ?? 0)/1000000) >= 512 {
//                        CommonFunctions.showToastWithMessage(StringConstant.videoSizeIsTooHigh.value)
//                        return false
//                    }
//                }
//                self.maxVideoCount += 1
//                if self.maxVideoCount > 1 {
//                    printDebug("Max video limit reached")
//                    CommonFunctions.showToastWithMessage(StringConstant.youCanSelectMax1Video.value)
//                    return false
//                } else {
//                    return true
//                }
//            } else {
//                return true
//            }
//        }
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        printDebug("didSelect: \(indexPath.row)")
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        printDebug("shouldDeselect: \(indexPath.row)")
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        printDebug("didDeselect: \(indexPath.row)")
        if asset.mediaType == .video {
//            self.maxVideoCount = 0
        }
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool) {
        printDebug("dismiss completed - byCancel: \(byCancel)")
    }
}

extension AddPortfolioBuilderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.model.images.append((nil, image))
            self.tableViewOutlet.reloadData()
        }
    }
}

extension AddPortfolioBuilderVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return true }
        
        switch sectionArray[index.section] {
        case .jobName:
            return CommonFunctions.textValidation(/*allowedCharacters: CommonFunctions.alphaNumeric,*/ textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 100)
        case .jobDescription:
            return CommonFunctions.textValidation(textField: textField.text ?? "", string: string, range: range, numberOfCharacters: 250)
        default:
            return true
        }
    }
}

extension AddPortfolioBuilderVC: AddPortfolioBuilderVMDelegate {
    func tradiePortFolioAdded(urls: [String], portfolioId: String) {
        let model = PortfoliaData(jobName: self.model.jobName, portfolioId: portfolioId, description: self.model.jobDescription, imagesUrls: urls)
        delegate?.getUpdatedPortfolios(model: model)
        pop()
    }
    
    func success(urls: [String]) {
        if kUserDefaults.isTradie() {
            viewModel.addPorfolio(model: model, urls: urls)
        } else {
            let model = PortfoliaData(jobName: self.model.jobName, portfolioId: self.model.id, description: self.model.jobDescription, imagesUrls: urls)
            delegate?.getUpdatedPortfolios(model: model)
            pop()
        }
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
