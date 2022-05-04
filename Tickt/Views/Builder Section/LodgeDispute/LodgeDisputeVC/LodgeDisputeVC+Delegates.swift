//
//  LodgeDisputeVC+Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import PhotosUI
import Foundation

extension LodgeDisputeVC: LodgeDisputeVMDelegate {
    
    func success() {
        goToSuccessScreen()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}


extension LodgeDisputeVC: CommonButtonDelegate {
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
}


extension LodgeDisputeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.lodgeDisputeModel.images.append(image)
            self.tableViewOutlet.reloadData()
        }
    }
}


extension LodgeDisputeVC: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        let identifier = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifier, options: nil)
        if let pickedAsset = fetchResult.firstObject {
            if let image = self.getAssetThumbnail(asset: pickedAsset) {
                self.lodgeDisputeModel.images.append(image)
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail: UIImage?
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}



