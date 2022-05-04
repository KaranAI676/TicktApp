//
//  SettingsBuilderVC + Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 12/07/21.
//

import Foundation

extension SettingsBuilderVC {
    
    func initialSetup() {
        setupTableView()
        viewModel.delegate = self
        viewModel.getSettingData()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: TitleLabelForNamesTableCell.self)
        tableViewOutlet.registerCell(with: CommonTitleWithSwitchTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func updateModel(index: IndexPath, state: Bool,pushArray: [Int]){
        model?.pushNotificationCategory = pushArray
        selectedPushArray.removeAll()
        selectedPushArray = pushArray
//        switch sectionArray[index.section] {
//        case .message:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.messages.email = state
//            case .push:
//                self.model?.messages.pushNotification = state
//            case .smsMessages:
//                self.model?.messages.smsMessages = state
//            default:
//                break
//            }
//        case .reminders:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .CHAT:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .PAYMENT:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .ADMIN_UPDATE:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .MILESTONE_UPDATE:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .REVIEW:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .VOUCH:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .CHANGE_REQUEST:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .CANCELATION:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .DISPUTE:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        case .QUESTION:
//            switch cellArray[index.row] {
//            case .email:
//                self.model?.reminders.email = state
//            case .push:
//                self.model?.reminders.pushNotification = state
//            case .smsMessages:
//                self.model?.reminders.smsMessages = state
//            default:
//                break
//            }
//        }
        tableViewOutlet.reloadRows(at: [index], with: .automatic)
    }
}
