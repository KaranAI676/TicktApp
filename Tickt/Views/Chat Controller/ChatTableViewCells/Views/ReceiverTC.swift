//
//  ReceiverTC.swift
// Tickt
//
//  Created by Admin on 11/06/21.
//  Copyright © 2021Tickt. All rights reserved.
//

import UIKit

class ReceiverTC: UITableViewCell {

    @IBOutlet weak var receiverBubbleView: UIView!
    @IBOutlet weak var receiverMessageTimeLabel: UILabel!
    @IBOutlet weak var receiverTextMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        receiverBubbleView.roundCorner([.topLeft,.topRight,.bottomLeft], radius: 12)
    }
    
    func populateData(time : String , message : String) {
        receiverMessageTimeLabel.text = time
        receiverTextMessageLabel.text = message
    }
    
    func populate(message: ChatMessage) {
        receiverTextMessageLabel.text = message.messageText
        receiverMessageTimeLabel.text = dateManager.string(from: message.messageTimestamp, dateFormat: "hh:mm a", inMilliSeconds: true)
        setNeedsDisplay()
    }
}

