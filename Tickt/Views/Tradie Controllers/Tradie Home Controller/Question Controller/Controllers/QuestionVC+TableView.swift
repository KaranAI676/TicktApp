//
//  QuestionVC+TableView.swift
//  Tickt
//
//  Created by Admin on 05/05/21.
//

import UIKit

extension QuestionVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionModel?.result.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.questionModel?.result.list[section].isShowAll ?? false {
            return questionModel?.result.list[section].answers.count ?? 0
        }else{
            return (questionModel?.result.list[section].answers.count ?? 0) > 3 ? 3 : (questionModel?.result.list[section].answers.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueCell(with: QuestionListingHeaderTblCell.self)
        if let data = questionModel?.result.list[section] {
            cell.populateUI(index: section, question: data)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: QuestionListingAnswerTblCell.self)
        let totalAnswer = questionModel?.result.list[indexPath.section].answers.count ?? 0
        if let data = questionModel?.result.list[indexPath.section].answers[indexPath.row] {
            cell.populateUI(indexPath: indexPath, answer: data, count: totalAnswer, showAll: questionModel?.result.list[indexPath.section].isShowAll ?? false)
        }
        cell.delegate = self
        return cell
    }
    
    func showAlert(index: Int) {
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "", alertMessage: "Are you sure you want to delete this question?", acceptButtonTitle: "Delete", declineButtonTitle: "Cancel") { [weak self] in
            // arsh  self?.viewModel.deleteQuestions(questionId: self?.questionModel?.result.list[index].questionData?.questionId ?? "", jobId: self?.jobId ?? "", index: index)
        } dismissCompletion: {
            
        }
    }
}


extension QuestionVC : QuestionListingHeaderTblCellDelegate {
    func anwereTapped(section: Int) {
        self.goToAskQuestionVC(isEdit: false,type: .answereReply)
    }
    
    func showAll(section: Int) {
        let curentStatus = self.questionModel?.result.list[section].isShowAll ?? false
        self.questionModel?.result.list[section].isShowAll = !curentStatus
        self.questionTableView.reloadData()
    }
    
    
}


extension QuestionVC : QuestionListingAnswerTblCellDelegate {
    
    func moreTapped(index:IndexPath) {
        let curentStatus = self.questionModel?.result.list[index.section].isShowAll ?? false
        self.questionModel?.result.list[index.section].isShowAll = !curentStatus
        self.questionTableView.reloadData()
    }
    
    func editTapped(index: IndexPath) {
        self.currentIndexPath = index
        self.goToAskQuestionVC(isEdit: true,type: .questionAnswer)
        
    }
    
    func deleteTapped(index: IndexPath) {
        self.currentIndexPath = index
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to delete a answer?", acceptButtonTitle: "Yes", declineButtonTitle: "No") { [self] in
            self.viewModel.deleteAnswer(questionId: questionModel?.result.list[index.section]._id ?? "", answerId: self.questionModel?.result.list[index.section].answers[index.row]._id ?? "")
        } dismissCompletion: { }
    }
    
    func replyTapped(index: IndexPath) {
        self.currentIndexPath = index
        self.goToAskQuestionVC(type: .answereReply)
    }
}
