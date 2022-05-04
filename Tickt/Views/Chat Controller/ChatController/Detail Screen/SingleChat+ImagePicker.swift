//
//  SingleChat+ImagePicker.swift
//  Tickt
//
//  Created by Vijay's Macbook on 23/07/21.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices


extension SingleChatVC: CommonButtonDelegate {        
    
    func takeVideo() {
        captureImagePopUp(delegate: self, croppingEnabled: false, mediaType: [kUTTypeMovie as String], openCamera: true)
    }
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, mediaType: [kUTTypeMovie as String, kUTTypeImage as String], openCamera: false)
    }
}

extension SingleChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chatImages = image
            sendImage(mimeType: .imageJpeg)
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoUrl.path) {
            mainQueue { [weak self] in
                guard let self = self else { return }
                self.encodeVideo(videoURL: videoUrl, thumbnail: UIImage())
            }
        }
        view.endEditing(true)
    }
    
    func encodeVideo(videoURL: URL, thumbnail: UIImage)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
        //Create Export session
        exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        //Creating temp path to save the converted video
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4").absoluteString
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory2.appendingPathComponent("\(Date().toTimestamp)rendered-Video.mp4")
        deleteFile(filePath: filePath)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath)
            }
            catch let error {
                print(error)
            }
        }
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch self.exportSession!.status {
            case .failed:
                debugPrint(self.exportSession.error ?? "")
            case .cancelled:
                debugPrint("Export canceled")
            case .completed:
                self.mainQueue { [weak self] in
                    self?.finalVideoUrl = self?.exportSession.outputURL?.absoluteString ?? ""
                    self?.sendImage(mimeType: .videoMp4)
                }
            default:
                break
            }
        })
    }

    func deleteFile(filePath: URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        } catch {
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }    
}

