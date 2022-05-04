//
//  ReceivedTextCell.swift
//  HairInferno
//
//  Created by Apple on 15/11/18.
//  Copyright © 2018 AppInventiv. All rights reserved.
//

import UIKit
import AVKit

class ReceivedImageTextCell: UITableViewCell {
    
    var videoUrl = String()
    var openProfileClosure: (()->())?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var receiveImageView: UIImageView!
    @IBOutlet weak var messageTimeReceivedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        receiveImageView.backgroundColor = UIColor.gray
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        receiveImageView.round(radius: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addGesture() {
        receiveImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(tapTarget(_:)))
        receiveImageView.addGestureRecognizer(imageGesture)
    }
    
    @objc private func tapTarget(_ sender: UIGestureRecognizer){
        openProfileClosure?()
    }
    
    func populate(message: ChatMessage) {
        if message.messageType == .image {
            let _ = URL(string: message.mediaURL)
            if message.isDeleted {
                receiveImageView.image = #imageLiteral(resourceName: "uploadDocumentPlaceHolder")
            } else {
                //                receiveImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
        
        messageTimeReceivedLabel.text = dateManager.string(from: message.messageTimestamp, dateFormat: "hh:mm a", inMilliSeconds: true)
        setNeedsDisplay()
    }
}



