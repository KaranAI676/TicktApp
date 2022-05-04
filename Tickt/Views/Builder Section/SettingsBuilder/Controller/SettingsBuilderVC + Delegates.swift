//
//  SettingsBuilderVC + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 12/07/21.
//

import Foundation

extension SettingsBuilderVC: SettingsBuilderVMDelegate {
    
    func didGetSettingData(model: SettingsBuilderResultModel) {
        self.model = model
        self.selectedPushArray = model.pushNotificationCategory
        tableViewOutlet.reloadData()
    }
    
    func updateSettingFailure(index: IndexPath, state: Bool, pushArray: [Int]) {
        updateModel(index: index, state: state,pushArray:pushArray)
    }
    
    func didSuccessUpdateSetting(index: IndexPath, state: Bool, pushArray: [Int]) {
        updateModel(index: index, state: state,pushArray:pushArray)
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
