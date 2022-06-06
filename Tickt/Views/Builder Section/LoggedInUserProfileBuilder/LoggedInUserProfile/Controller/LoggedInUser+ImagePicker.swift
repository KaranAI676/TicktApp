//
//  LoggedInUser+ImagePicker.swift
//  Tickt
//
//  Created by Vijay's Macbook on 29/06/21.
//

import AVKit
import Foundation
import AVFoundation
import MobileCoreServices
//import SwiftyDropbox

extension LoggedInUserProfileBuilderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if kUserDefaults.isTradie() {
                viewModel.uploadImages(image: image)
            } else {
                viewModel.changeProfilePicture(image: image)
            }
        }
    }
}

extension LoggedInUserProfileBuilderVC: CommonButtonDelegate {
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: true, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: true, mediaType: [kUTTypeImage as String], openCamera: false)
    }
    
//    func selectDocumentFromDropbox() {
//        //account_info.read //files.content.read
//        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
//        DropboxClientsManager.authorizeFromControllerV2(
//            UIApplication.shared,
//            controller: self,
//            loadingStatusDelegate: nil,
//            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
//            scopeRequest: scopeRequest
//        )
//
//    }
}
