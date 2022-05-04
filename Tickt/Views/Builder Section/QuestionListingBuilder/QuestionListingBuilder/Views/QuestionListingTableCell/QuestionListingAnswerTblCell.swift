//
//  QuestionListingAnswerTblCell.swift
//  Tickt
//
//  Created by Admin on 19/12/21.
//

import UIKit

protocol QuestionListingAnswerTblCellDelegate : AnyObject {
    func editTapped(index:IndexPath)
    func deleteTapped(index:IndexPath)
    func replyTapped(index:IndexPath)
    func moreTapped(index:IndexPath)
}

class QuestionListingAnswerTblCell: UITableViewCell {
    
    
    //MARK:-Properties.
    weak var delegate:QuestionListingAnswerTblCellDelegate?
    var currentIndexPath:IndexPath = IndexPath()
    
    
    //MARK:-IBOutlets.
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnShowMore: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func populateUI(indexPath:IndexPath,answer:AnswerData,count:Int,showAll:Bool) {
        currentIndexPath = indexPath
        lblDate.text = answer.createdAt
        lblName.text = (answer.sender_user_type == 1) ? answer.tradie.first?.firstName : answer.builder.first?.firstName
        lblAnswer.text = answer.answer
        let image = (answer.sender_user_type == 1) ? answer.tradie.first?.user_image : answer.builder.first?.user_image
        imageUser.sd_setImage(with: URL(string: image ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        if count > 3 {
            if showAll {
                btnShowMore.isHidden = (indexPath.row != count - 1)
            }else{
                btnShowMore.isHidden = !(indexPath.row == 2)
            }
        }else{
            btnShowMore.isHidden = true
        }
        
        btnShowMore.setTitle(showAll ? "Hide Answer" : "Show Answer", for: .normal)
        
        if kUserDefaults.isTradie()  {
            if (answer.sender_user_type == 1) && (indexPath.row == count - 1) {
                self.btnDelete.isHidden = false
                self.btnEdit.isHidden = false
                self.btnReply.isHidden = true
            }else if (answer.sender_user_type == 2) && (indexPath.row == count - 1) {
                self.btnDelete.isHidden = true
                self.btnEdit.isHidden = true
                self.btnReply.isHidden = false
            }else{
                self.btnDelete.isHidden = true
                self.btnEdit.isHidden = true
                self.btnReply.isHidden = true
            }
        }else{
            if (answer.sender_user_type == 2) && (indexPath.row == count - 1) {
                self.btnDelete.isHidden = false
                self.btnEdit.isHidden = false
                self.btnReply.isHidden = true
            }else if (answer.sender_user_type == 1) && (indexPath.row == count - 1) {
                self.btnDelete.isHidden = true
                self.btnEdit.isHidden = true
                self.btnReply.isHidden = false
            }else{
                self.btnDelete.isHidden = true
                self.btnEdit.isHidden = true
                self.btnReply.isHidden = true
            }
        }
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        self.delegate?.editTapped(index: currentIndexPath)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.delegate?.deleteTapped(index: currentIndexPath)
    }
    
    @IBAction func btnReplyTapped(_ sender: UIButton) {
        self.delegate?.replyTapped(index: currentIndexPath)
    }
    
    @IBAction func btnShowMoreTapped(_ sender: UIButton) {
        self.delegate?.moreTapped(index: currentIndexPath)
    }
}
