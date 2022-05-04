//
//  PhotoVC+ImagePicker.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

import AVKit
import AVFoundation
import MobileCoreServices

extension PhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageArray.append((image, .image, nil, ""))            
            photoCollectionView.reloadData()
            if imageArray.count > 0 {
                submitPhotosButton.alpha = 1
                submitPhotosButton.isUserInteractionEnabled = true
            }
        }
    }
}

extension PhotoVC: CommonButtonDelegate {        
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, mediaType: [kUTTypeImage as String], openCamera: false)
    }
}
