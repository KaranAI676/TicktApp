//
//  NotificationTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 18/07/21.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    enum NotificationReadMode: Int {
        case read = 1
        case unread = 0
        
        var isRead: Bool {
            switch self {
            case .read:
                return true
            case .unread:
                return false
            }
        }
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var dotView: UIView!
    ///
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    ///
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK:- Variables
    var model: NotificationListingModel? = nil {
        didSet {
            populateUI()
        }
    }
    var tableView: UITableView? = nil
    var buttonClosure: ((IndexPath)-> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tableView = tableView else { return }
        if let index = tableViewIndexPath(tableView) {
            buttonClosure?(index)
        }
    }
}

extension NotificationTableCell {
    
    private func configUI() {
        buttonBackView.isHidden = true
    }
    
    private func populateUI() {
        guard let model = model else { return }
        jobNameLabel.text =  model.title
        descriptionLabel.text = model.notificationText
        timeLabel.text = model.createdAt?.convertToDate().timeSince
        bigImageView.sd_setImage(with: URL(string: model.image ?? ""), placeholderImage: nil)
        dotView.isHidden = NotificationReadMode(rawValue: model.read ?? 0)?.isRead ?? false
    }
}
