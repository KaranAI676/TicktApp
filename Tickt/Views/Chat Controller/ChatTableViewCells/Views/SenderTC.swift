//
//  SenderTC.swift
// Tickt
//
//  Created by Admin on 11/06/21.
//  Copyright © 2021Tickt. All rights reserved.
//

import UIKit

class SenderTC: UITableViewCell {
    
    @IBOutlet weak var senderBubbleView: UIView!
    @IBOutlet weak var senderMessageTimeLabel: UILabel!
    @IBOutlet weak var senderTextMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        senderBubbleView.roundCorner([.topLeft,.topRight,.bottomRight], radius: 12)
    }
    
    func populateData(time: String, message: String) {
        senderMessageTimeLabel.text = time
        senderTextMessageLabel.text = message
    }
    
    func populate(message: ChatMessage) {
        senderTextMessageLabel.text = message.messageText
        senderMessageTimeLabel.text = dateManager.string(from: message.messageTimestamp, dateFormat: "hh:mm a", inMilliSeconds: true)
        setNeedsDisplay()
    }
}

