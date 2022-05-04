//
//  SentImageTextCell.swift
// Tickt
//
//  Created by Admin on 14/06/21.
//  Copyright © 2021Tickt. All rights reserved.
//

import UIKit
import AVKit

class SentImageTextCell: UITableViewCell {

    @IBAction func playButtonAction(_ sender: UIButton) {
        let player = AVPlayer(url: URL(string: self.videoUrl)!)
        let vc = AVPlayerViewController()
        vc.player = player
        kAppDelegate.window?.rootViewController?.present(vc, animated: true, completion: {
            vc.player?.play()
        })
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sendeImage: UIImageView!
    @IBOutlet weak var messageTimeLabel: UILabel!
//    @IBOutlet weak var seenUnseenTick: UIImageView!
    @IBOutlet weak var messageContainer: SentImageMessageView!
    @IBOutlet weak var uploadingImageLoader: UIActivityIndicatorView!
        
    var videoUrl = String()
            
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.isHidden = true
        uploadingImageLoader.isHidden = true
        sendeImage.backgroundColor = UIColor.gray
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        sendeImage.round(radius: 10)
    }
    
    func populate(message: ChatMessage) {
        
        if message.messageType == .image {
            let _ = URL(string: message.mediaURL)
            if message.messageStatus == DeliveryStatus.read {
//                seenUnseenTick.image = #imageLiteral(resourceName: "icDoubleTick")
            } else if message.messageStatus == DeliveryStatus.send {
//                seenUnseenTick.image = #imageLiteral(resourceName: "icSingleTick")
                uploadingImageLoader.stopAnimating()
            } else {
                uploadingImageLoader.startAnimating()
            }
            
//            if message.isDeleted {
//               sendeImage.image = #imageLiteral(resourceName: "Group 1398")
//            } else {
//                sendeImage.sd_setImage(with: url, placeholderImage: nil)
//            }
        }
        messageTimeLabel.text = dateManager.string(from: message.messageTimestamp, dateFormat: "hh:mm a", inMilliSeconds: true)
        setNeedsDisplay()
    }
}

