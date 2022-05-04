//
//  InboxTableViewCell.swift
// Tickt
//
//  Created by Admin on 10/06/21.
//  Copyright © 2021Tickt. All rights reserved.
//

import SDWebImage

class InboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: CustomBoldLabel!
    @IBOutlet weak var jobNameLabel: CustomMediumLabel!
    @IBOutlet weak var lastMessageLabel: CustomRomanLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLabel.isHidden = true
    }

    func populate(inbox: Inbox) {
        
        lastMessageLabel.text = inbox.lastMessage?.messageText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if inbox.lastMessage?.messageType == .image {
            lastMessageLabel.text = "Sent an image"
        }
        
        if inbox.lastMessage?.messageType == .video {
            lastMessageLabel.text = "Sent a video"
        }

        countLabel.isHidden = (inbox.unreadCount == 0)
        countLabel.text = "\(inbox.unreadCount)"
        if let time = inbox.lastMessage?.messageTimestamp {
            timeStampLabel.text = dateManager.elapsedTime(from: time, inMilliSeconds: true)
        }
        if timeStampLabel.text == "51 Years Ago" {
            timeStampLabel.text = ""
        }
        userNameLabel.text = inbox.username
        jobNameLabel.text = inbox.jobName
        userImageView.sd_setImage(with: URL(string: inbox.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
    }
}
