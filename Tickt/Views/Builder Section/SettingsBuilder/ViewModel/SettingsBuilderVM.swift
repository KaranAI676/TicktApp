//
//  SettingsBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 12/07/21.
//

import Foundation
import SwiftyJSON

protocol SettingsBuilderVMDelegate: AnyObject {
    func failure(message: String)
    func didGetSettingData(model: SettingsBuilderResultModel)
    func updateSettingFailure(index: IndexPath, state: Bool,pushArray:[Int])
    func didSuccessUpdateSetting(index: IndexPath, state: Bool,pushArray:[Int])
}

class SettingsBuilderVM: BaseVM {
    
    weak var delegate: SettingsBuilderVMDelegate? = nil
    
    func getSettingData() {
        let endPoint = kUserDefaults.isTradie() ? EndPoint.profileTradieGetSettingsData.path : EndPoint.profileBuilderGetSettingsData.path
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: SettingsBuilderModel = SettingsBuilderModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.didGetSettingData(model: serverResponse.result)
                } else {
                    self.delegate?.failure(message: "")
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    // func updateSettingData(index: IndexPath, sectionArray: SettingsBuilderVC.SectionArray, cellArray: SettingsBuilderVC.CellArray, state: Bool) {
    func updateSettingData(index: IndexPath,selectedIndex:[Int],oldIndex:[Int], state: Bool) {
        
        var params = JSONDictionary()
        params["pushNotificationCategory"] = selectedIndex //[sectionArray.keyValue: [cellArray.keyValue: state]]
        let endPoint = kUserDefaults.isTradie() ? EndPoint.profileTradieSettings.path : EndPoint.profileBuilderSettings.path
        ApiManager.request(methodName: endPoint, parameters: params, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                self.delegate?.didSuccessUpdateSetting(index: index, state: state, pushArray: selectedIndex)
            case .failure(_):
                self.delegate?.updateSettingFailure(index: index, state: !state, pushArray: oldIndex)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
