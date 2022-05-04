//
//  EditProfile+ImagePicker.swift
//  Tickt
//
//  Created by Vijay's Macbook on 30/06/21.
//

import Foundation

extension EditProfileDetailsBuilderVC: CommonButtonDelegate, UIImagePickerControllerDelegate {
    
    func selectDocument() {
        openDocumentPicker()
    }
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        updateTableCell(imageUrl: info[UIImagePickerController.InfoKey.imageURL], docData: image.jpegData(compressionQuality: 0.5) ?? Data(), mimeType: "image/jpeg")
    }
}
