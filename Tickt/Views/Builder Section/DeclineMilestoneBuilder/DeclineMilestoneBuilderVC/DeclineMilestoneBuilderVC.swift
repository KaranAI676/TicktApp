//
//  DeclineMilestoneBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import UIKit

class DeclineMilestoneBuilderVC: BaseVC {

    enum SectionArray {
        case detail
        case images
        case uploadPlaceHolder
        
        var title: String {
            switch self {
            case .detail:
                return "Your reason"
            default:
                return ""
            }
        }
        
        var height: CGFloat {
            switch self {
            case .detail:
                return 30
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
        
        var color: UIColor {
            switch self {
            case .detail:
                return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            default:
                return .clear
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
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var jobId: String = ""
    var jobName: String = ""
    var milestoneId: String = ""
    var viewModel = DeclineMIlestoneBuilderVM()
    var declineMilestoneModel = DeclineMilestoneBuilderModel()
    var sectionArray: [SectionArray] = []
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case continueButton:
            if validate() {
                viewModel.decliningMilestone(model: declineMilestoneModel)
            }
        default:
            break
        }
        disableButton(sender)
    }
}


extension DeclineMilestoneBuilderVC {
    
    func initialSetup() {
        viewModel.delegate = self
        declineMilestoneModel.jobId = jobId
        declineMilestoneModel.jobName = jobName
        declineMilestoneModel.milestoneId = milestoneId
        navTitleLabel.text = jobName
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextViewTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: UploadImageTableCell.self)
        tableViewOutlet.registerCell(with: ReasonsTableViewCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func goToSuccessScreen() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .milestoneDeclinedBuilder
        push(vc: vc)
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
}

extension DeclineMilestoneBuilderVC {
    
    func validate() -> Bool {
        
        if self.declineMilestoneModel.reasonText.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter reason")
            return false
        }
        
//        if declineMilestoneModel.images.isEmpty {
//            CommonFunctions.showToastWithMessage("Please select atleast a image")
//            return false
//        }
        
        return true
    }
}


extension DeclineMilestoneBuilderVC {
    
    func getSectionArray() -> [SectionArray] {
        
        var sectionArray: [SectionArray] = [.detail]
        self.declineMilestoneModel.images.isEmpty ? sectionArray.append(.uploadPlaceHolder) : sectionArray.append(.images)
        self.sectionArray = sectionArray
        return sectionArray
        
    }
}



extension DeclineMilestoneBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getSectionArray().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .detail:
            let cell = tableView.dequeueCell(with: CommonTextViewTableCell.self)
            cell.tableView = tableView
            cell.textViewOutlet.text = declineMilestoneModel.reasonText
            cell.cellType = .declineMilestone
            cell.updateTextWithIndexClosure = { [weak self] (text, index) in
                guard let self = self else { return }
                self.declineMilestoneModel.reasonText = text
            }
            return cell
        case .images:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.photosModel = self.declineMilestoneModel.images
            cell.maxMediaCanAllow = 6
            cell.imageTapped = { [weak self] (tappedType, index) in
                guard let self = self else { return }
                switch tappedType {
                case .imageTapped:
                    break
//                    CommonFunctions.showToastWithMessage("Preview")
                case .uploadImage:
                    self.goToCommonPopupVC()
                case .crossTapped:
                    self.declineMilestoneModel.images.remove(at: index.row)
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
        header.headerLabel.text = sectionArray[section].title
        header.headerLabel.textColor = sectionArray[section].color
        header.headerLabel.font = sectionArray[section].font
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}


extension DeclineMilestoneBuilderVC: DeclineMIlestoneBuilderVMDelegate {
    
    func success() {
        if let remainingNonApprovedCount = kAppDelegate.totalMilestonesNonApproved, remainingNonApprovedCount > 1  {
            NotificationCenter.default.post(name: NotificationName.milestoneAcceptDecline, object: nil, userInfo: [ApiKeys.milestoneId: milestoneId, ApiKeys.status: 3])
        }
        goToSuccessScreen()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}


extension DeclineMilestoneBuilderVC: CommonButtonDelegate {
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
}


extension DeclineMilestoneBuilderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.declineMilestoneModel.images.append(image)
            self.tableViewOutlet.reloadData()
        }
    }
}
