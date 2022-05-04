////
////  AddQualificationPreviewVC.swift
////  Tickt
////
////  Created by S H U B H A M on 09/03/21.
////
//
//import UIKit
//
//class AddQualificationPreviewVC: BaseVC {
//
//    //MARK:- IB Outlets
//    @IBOutlet weak var topbgView: UIView!
//    @IBOutlet weak var screenTitleLabel: UILabel!
//    @IBOutlet weak var pageController:
//    UIPageControl!
//    @IBOutlet weak var dotImageView: UIImageView!
//    ///Nav View
//    @IBOutlet weak var navBehindView: UIView!
//    @IBOutlet weak var navBarView: UIView!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var doneButton: UIButton!
//    ///
//    @IBOutlet weak var tableViewOutlet: UITableView!
//    /// Bottom Buttons
//    @IBOutlet weak var uploadButton: UIButton!
//    @IBOutlet weak var addLaterButton: UIButton!
//    ///Place holder view
//    @IBOutlet weak var placeholderView: UIView!
//    @IBOutlet weak var placeHolderImageView: UIImageView!
//    @IBOutlet weak var placeHoldertextLabel: UILabel!
//
//    //MARK:- Variables
//    var model = [(UIImage, String)]()
//
//    //MARK:- LifeCycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initialSetup()
//    }
//
//    //MARK:- IB Actions
//    @IBAction func buttonTapped(_ sender: UIButton) {
//        switch sender {
//        case backButton:
//            pop()
//        case uploadButton:
//            goToCommonPopupVC()
//        case addLaterButton, doneButton:
//            if model.count > 0 {
////                kAppDelegate.signupModel.docImages.append(contentsOf: model)
//            }
//            let abnVC = AddAbnVC.instantiate(fromAppStoryboard: .registration)
//            push(vc: abnVC)
//        default:
//            break
//        }
//        disableButton(sender)
//    }
//}
//
////MARK:- Private Methods
////======================
//extension AddQualificationPreviewVC {
//
//    private func initialSetup() {
//        setupTableView()
//    }
//
//    private func setupTableView() {
//        registerCells()
//        tableViewOutlet.dataSource = self
//        tableViewOutlet.delegate = self
//        doneButton.isHidden = true
//    }
//
//    private func registerCells() {
//        tableViewOutlet.registerCell(with: PreviewOfDocumentTableCell.self)
//    }
//
//    private func goToCommonPopupVC() {
//        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.delegate = self
//        vc.isAnimated = true
//        mainQueue { [weak self] in
//            self?.navigationController?.present(vc, animated: true, completion: nil)
//        }
//    }
//}
//
////MARK:- TableDelegate
////====================
//extension AddQualificationPreviewVC: TableDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableViewOutlet.isHidden = !(self.model.count > 0)
//        placeholderView.isHidden = !self.tableViewOutlet.isHidden
//        return model.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueCell(with: PreviewOfDocumentTableCell.self)
//        cell.documentImageView.image = self.model[indexPath.row].0
//        cell.documentNameLabel.text = self.model[indexPath.row].1
//        cell.tableView = tableView
//
//        cell.buttonClosure = { [weak self] (index) in
//            guard let self = self else { return }
//            self.model.remove(at: index.row)
//            if self.model.count == 0 {
//                self.doneButton.isHidden = true
//            } else {
//                self.doneButton.isHidden = false
//            }
//            self.tableViewOutlet.reloadData()
//        }
//        return cell
//    }
//}
//
////MARK:- CommonButtonDelegate
////==========================
//extension AddQualificationPreviewVC: CommonButtonDelegate {
//
//    func takePhoto() {
//        captureImagePopUp(delegate: self, croppingEnabled: true, openCamera: true)
//    }
//
//    func galleryButton() {
//        captureImagePopUp(delegate: self, croppingEnabled: true, openCamera: false)
//    }
//}
//
////MARK:- UIImagePickerControllerDelegate
////======================================
//extension AddQualificationPreviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{ return }
//
//        var documentName = ""
//        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//            documentName = url.lastPathComponent
//        } else {
//            documentName = "Document"
//        }
//        model.append((image, documentName))
//        doneButton.isHidden = false
//        tableViewOutlet.reloadData()
//    }
//}
