//
//  SupportChatBuilderVC + Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import Foundation

extension SupportChatBuilderVC {
    
    func initialSetup() {
        setupTableView()
        optionsModel = CommonFunctions.getSupportChatOptions()
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: ReasonsTableViewCell.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func goToSuccessVC() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .supportChat
        push(vc: vc)
    }
    
    func validate() -> Bool {
        
        guard let model = self.optionsModel else { return false }
        
        let selectedOption = model.first(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        
        self.model.option = selectedOption?.optionType
        
        if self.model.option == nil {
            CommonFunctions.showToastWithMessage("Please select a option")
            return false
        }
        
        if self.model.message.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter a message")
            return false
        }
        
        return true
    }

}
