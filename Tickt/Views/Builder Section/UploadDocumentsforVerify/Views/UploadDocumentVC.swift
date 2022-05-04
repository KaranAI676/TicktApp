//
//  UpoadDocumentVC.swift
//  Tickt
//
//  Created by Admin on 21/09/21.
//

import UIKit

enum ImageId{
    case fronId
    case backId
}

class UploadDocumentVC: BaseVC {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var uploadFromGalleryBtn: UIButton!
    @IBOutlet weak var selectedImageView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var screenMessage: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var selectedImage: UIImageView!
    
    var imagePickers:UIImagePickerController?
    var ImageIdType: ImageId = .fronId
    var frontIdUploaded = false
    var stripeID = ""
    var idImages: [UIImage] = []
    var viewmodel = UploadDocumentVM()

    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
  
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetUp()
    }
    
    
    //MARK:- PRIVATE FUNCTIONS
    //=======================
    private func initailSetUp(){
        addImagePickerToContainerView()
        confirmBtn.isHidden = true
        tryAgainBtn.isHidden = true
        uploadFromGalleryBtn.isHidden = false
        takePhoto.isHidden = false
        selectedImage.isHidden = true
        viewmodel.delegate = self
    }
    
    
    func addImagePickerToContainerView(){
        
        imagePickers = UIImagePickerController()
        if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerController.CameraDevice.front) {
            imagePickers?.delegate = self
            imagePickers?.sourceType = UIImagePickerController.SourceType.camera
            
            //add as a childviewcontroller
            addChild(imagePickers!)
            
            // Add the child's View as a subview
            self.cameraView.addSubview((imagePickers?.view)!)
            imagePickers?.view.frame = cameraView.bounds
            imagePickers?.allowsEditing = false
            imagePickers?.showsCameraControls = false
            imagePickers?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
        }
    }
    
    private func SetupbuttonStates() {
        if ImageIdType == .fronId{
            screenMessage.text = "Make sure the lighting is good and put the front side the of the ID into the frame and then click Take a Photo"
        } else {
            screenMessage.text = "Make sure that the lighting is good and put the back part of ID into the frame and then click Take a Photo"
        }
    }
    
    private func resetButtonAndText(imageType: ImageId = .fronId){
        confirmBtn.isHidden = false
        tryAgainBtn.isHidden = false
        uploadFromGalleryBtn.isHidden = true
        takePhoto.isHidden = true
        screenTitle.text = "Confirm ID photo"
        ImageIdType = imageType
        SetupbuttonStates()
    }

    private func resetButtonforBackImage(imageType: ImageId = .fronId){
        selectedImage.isHidden = true
        selectedImage.image = nil
        screenTitle.text = "Add your ID photo"
        confirmBtn.isHidden = true
        tryAgainBtn.isHidden = true
        uploadFromGalleryBtn.isHidden = false
        takePhoto.isHidden = false
        ImageIdType = imageType
        SetupbuttonStates()
    }
    
    func gotoAccountCreatedSuccessVC() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .idConfirmation
        push(vc: vc)
    }
}

extension UploadDocumentVC {
    @IBAction func takePhotoAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
        } else {
            CommonFunctions.showToastWithMessage("Camera not available.")
        }
    }
    
    @IBAction func uploadFromGallery(_ sender: UIButton) {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func tryAgainbtnTap(_ sender: UIButton) {
        selectedImage.isHidden = true
        selectedImage.image = nil
        confirmBtn.isHidden = true
        tryAgainBtn.isHidden = true
        uploadFromGalleryBtn.isHidden = false
        takePhoto.isHidden = false
        idImages.removeLast()
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
        
    @IBAction func confirmBtnTap(_ sender: UIButton) {
        confirmBtn.isHidden = true
        tryAgainBtn.isHidden = true
        uploadFromGalleryBtn.isHidden = false
        takePhoto.isHidden = false
        if frontIdUploaded {
            
        } else {
            frontIdUploaded = true
        }
        if ImageIdType == .fronId {
            ImageIdType = .backId
            resetButtonforBackImage(imageType: ImageIdType)
        } else {
            ImageIdType = .fronId
            if !idImages.isEmpty {
                viewmodel.uploadDocumentsImages(stripeID: stripeID, front: idImages.first!, backImage: idImages.last!)
            }
        }
    }
}

extension UploadDocumentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        printDebug(image)
        selectedImage.image = image
        selectedImage.isHidden = false
        if frontIdUploaded{
            idImages.insert(image, at: 1)
            resetButtonAndText(imageType: .backId)
        } else {
            idImages.append(image)
            resetButtonAndText(imageType: .fronId)
        }
    }
}

extension UploadDocumentVC: UploadDocumenDelegate{
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
    
    func sucess(msg:String) {
        CommonFunctions.showToastWithMessage(msg)
        gotoAccountCreatedSuccessVC()
    }
}
