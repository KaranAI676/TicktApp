//
//  QuestionVC+Delegate.swift
//  Tickt
//
//  Created by Admin on 05/05/21.
//

import Foundation

extension QuestionVC: UpdateQuestionDelegate {
    func didQuestionAdded(question: QuestionData) {
        // ARSH  questionModel?.result.list.insert(QuestionResult(questionData: question), at: 0)
        questionTableView.reloadData()
        questionCountLabel.text = "\(questionModel?.result.list.count ?? 0) question(s)"
        checkWaterMark()
        updateQuestionCountAction?(questionModel?.result.list.count ?? 0)
    }
    
    func didEditedQuestion(question: QuestionData) {
     // Arsh   questionModel?.result.list[editIndex].questionData = question
        questionTableView.reloadSections(IndexSet(arrayLiteral: editIndex), with: .automatic)
    }
}

extension QuestionVC: GetQuestionDelegate {
    func successDeleteAnswer() {
        self.viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    
    func checkWaterMark() {
        if (questionModel?.result.list.count ?? 0) > 0 {
            watermarkLabel.isHidden = true
        } else {
            watermarkLabel.isHidden = false
        }
    }
    
    func didQuestionDeleted(index: Int) {
        questionModel?.result.list.remove(at: index)
        questionCountLabel.text = "\(questionModel?.result.list.count ?? 0) question(s)"
        mainQueue { [weak self] in
            self?.questionTableView.reloadData()
        }
        checkWaterMark()
        updateQuestionCountAction?(questionModel?.result.list.count ?? 0)
    }
    
    func didGetQuestions(model: QuestionModel) {
        questionModel = model
        questionCountLabel.text = "\(model.result.list.count ?? 0) questions"
        refreshControl.endRefreshing()
        mainQueue { [weak self] in
            self?.questionTableView.reloadData()
        }
        checkWaterMark()
    }
    
    func failure() {
        refreshControl.endRefreshing()
    }
}
