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

extension LoggedInUserProfileBuilderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, mediaType: [kUTTypeImage as String], openCamera: false)
    }
}
