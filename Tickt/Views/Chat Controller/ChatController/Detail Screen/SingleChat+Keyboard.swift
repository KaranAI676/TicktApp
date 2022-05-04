//
//  SingleChat+Keyboard.swift
//  Tickt
//
//  Created by Vijay's Macbook on 23/07/21.
//


extension SingleChatVC {
    
    func addKeyBoardObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name:  UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.33, animations: {
                self.messageViewBottomConstraint.constant = keyboardSize.height + 10
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.scrollToLastMessageAfterSending()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.0, animations: {
            self.messageViewBottomConstraint.constant = 10
            self.view.layoutIfNeeded()
        },completion: { (true) in
        })
    }
    
    func didSendPush(message: String, messageId: String, jobId: String, receiverId: String, count: Int) {
        ChatHelper.sendPush(message: message,
                            messageId: messageId,
                            jobId: jobId,
                            receiverId: receiverId,
                            count: count,
                            jobName: jobName)
    }
}
