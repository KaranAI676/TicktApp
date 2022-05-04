//
//  SingleChat+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 23/07/21.
//

import Foundation

extension SingleChatVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatController!.organisedKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = chatController!.organisedData[chatController!.organisedKeys[section]] {
            return arr.count
        } else {
            fatalError("Error \(#line) \(#function)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let chatMessage = chatController!.organisedData[chatController!.organisedKeys[indexPath.section]] {
            let message = chatMessage[indexPath.row]
            if message.senderId == kUserDefaults.getUserId() {
                switch message.messageType {
                case .text:
                    let cell = tableView.dequeueCell(with: ReceiverTC.self)
                    cell.populate(message: message)
                    return cell
                case .image, .video :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SentImageTextCell", for: indexPath) as! SentImageTextCell
                    if message.messageType == .video {
                        cell.sendeImage.image = nil
                        cell.playButton.isHidden = false
                    } else {
                        cell.playButton.isHidden = true
                        cell.sendeImage.image = nil
                        cell.sendeImage.sd_setImage(with: URL(string: message.mediaURL), placeholderImage: nil)
                    }
                    cell.populate(message: message)
                    return cell
                default:
                    let cell = tableView.dequeueCell(with: ReceiverTC.self)
                    cell.populate(message: message)
                    return cell
                }
            } else {
                switch message.messageType {
                case .text:
                    let cell = tableView.dequeueCell(with: SenderTC.self)
                    cell.populate(message: message)
                    return cell
                case .image, .video :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedImageTextCell", for: indexPath) as! ReceivedImageTextCell
                    if message.messageType == .video {
                        cell.playButton.isHidden = false                        
                        cell.receiveImageView.image = nil
                    } else {
                        cell.playButton.isHidden = true
                        cell.receiveImageView.image = nil
                        cell.receiveImageView.sd_setImage(with: URL(string: message.mediaURL), placeholderImage: nil)
                    }
                    cell.populate(message: message)
                    return cell
                default:
                    let cell = tableView.dequeueCell(with: ReceiverTC.self)
                    cell.populate(message: message)
                    return cell
                }
            }
        } else {
            fatalError("No message in cell for row. \nFile: \(#file) \nFunction: \(#function)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        endEditing()
        if let chatMessage = chatController!.organisedData[chatController!.organisedKeys[indexPath.section]] {
            let message = chatMessage[indexPath.row]
            if message.messageType == .image && !message.isDeleted {
                let nextVC = ImagePreviewVC.instantiate(fromAppStoryboard: .search)
                nextVC.urlString = message.mediaURL
                push(vc: nextVC)
            } else if message.messageType == .video && !message.isDeleted {
                if let url = URL(string: message.mediaURL) {
                    playTheVideo(videoUrl: url)
                }
            }
        } else {
            fatalError("No message in cell for row. \nFile: \(#file) \nFunction: \(#function)")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: UIDevice.width, height: 50)
        let view = UIView(frame: rect)
        view.backgroundColor = .clear
        let label = UILabel(frame: rect)
        label.font = UIFont.kAppDefaultFontRegular(ofSize: 14)
        label.text = chatController!.organisedKeys[section]
        label.textColor = UIColor(hex: "#AEAEAE")
        label.textAlignment = .center
        label.backgroundColor = .clear
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
