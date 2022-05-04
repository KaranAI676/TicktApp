//
//  HourVC+TextField.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//


extension HourVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setupTimePicker()
        textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButton))
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        formattedHour = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
    }
}
