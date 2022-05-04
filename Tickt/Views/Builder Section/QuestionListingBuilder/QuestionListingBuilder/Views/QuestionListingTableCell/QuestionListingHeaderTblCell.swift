//
//  QuestionListingHeaderTblCell.swift
//  Tickt
//
//  Created by Admin on 19/12/21.
//

import UIKit

protocol QuestionListingHeaderTblCellDelegate : AnyObject {
    func anwereTapped(section:Int)
    func showAll(section:Int)
}


class QuestionListingHeaderTblCell: UITableViewCell {

    
    //MARK:-Properties.
    weak var delegate:QuestionListingHeaderTblCellDelegate?
    
    
    //MARK:-IBOutlets.
    @IBOutlet weak var uerImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnAnswer: UIButton!
    @IBOutlet weak var btnShowAnswer: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func populateUI(index:Int,question:QuestionResults) {
        btnAnswer.tag = index
        btnShowAnswer.tag = index
        btnShowAnswer.isHidden = true
        lblQuestion.text = question.question
        lblDate.text = question.createdAt
        if kUserDefaults.isTradie() {
            btnAnswer.isHidden = true
        }else{
            btnAnswer.isHidden = question.answers.count > 0
        }
        
        lblName.text = question.tradieData.first?.firstName
        let image = question.tradieData.first?.tradieImage
        uerImageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
    }
    
    //MARK:-IBActions.
    @IBAction func answerBtnTapped(_ sender: UIButton) {
        self.delegate?.anwereTapped(section: sender.tag)
    }
    
    @IBAction func btnShowAnswerTapped(_ sender: UIButton) {
        self.delegate?.showAll(section: sender.tag)
    }
    
}
