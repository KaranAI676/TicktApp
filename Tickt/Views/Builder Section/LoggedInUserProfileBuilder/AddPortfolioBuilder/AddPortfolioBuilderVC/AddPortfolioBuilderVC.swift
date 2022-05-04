//
//  AddPortfolioBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import UIKit

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
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
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
