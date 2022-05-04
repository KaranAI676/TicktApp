//
//  Qualification+Delegate.swift
//  Tickt
//
//  Created by Admin on 17/03/21.
//

import UIKit
import Foundation

extension AnyQualificationsVC: CommonButtonDelegate {
    
    func selectDocument() {
        openDocumentPicker()
    }
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
}

extension AnyQualificationsVC: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        updateCollectionCell(imageUrl: info[UIImagePickerController.InfoKey.imageURL], docData: image.jpegData(compressionQuality: 0.5) ?? Data(), mimeType: "image/jpeg")
    }
    
    func updateCollectionCell(imageUrl: Any?, docData: Data, mimeType: String) {
        var documentName = ""
        if let url = imageUrl as? URL {
            documentName = url.lastPathComponent
        } else {
            documentName = "Document"
        }
        print("DocumentType: ", documentName)
        
        let index = selectedImages.firstIndex { (data, name, index, id, mimeType) -> Bool in
            return index == currentIndex
        }
        
        if let objectIndex = index {
            selectedImages[objectIndex] = (docData, documentName, currentIndex, model[objectIndex].id, mimeType)
        } else {
            selectedImages.append((docData, documentName, currentIndex, model[currentIndex].id, mimeType))
        }

        model[currentIndex].isUploaded = true        
        collectionViewOutlet.reloadItems(at: [IndexPath(item: currentIndex, section: 0)])
    }
}

extension AnyQualificationsVC: EditQualificationDelegate {
    func didDocUploaded(docArray: [QualificationDoc]) {
        docArrayClosure?(docArray)
        pop()
    }
}
