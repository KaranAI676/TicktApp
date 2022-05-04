//
//  NotificationBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 18/07/21.
//

import Foundation
import SwiftyJSON

protocol NotificationBuilderVMDelegate: AnyObject {
    
    func success()
    func markAllRead()
    func failure(message: String)
    func markSingleNotificationRead(indexPath: IndexPath)
}

class NotificationBuilderVM: BaseVM {
    
    var model: NotificationModel? = nil
    var tableViewOutlet = UITableView()
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    weak var delegate: NotificationBuilderVMDelegate? = nil
    
    func readSingleNotification(notificationId: String, indexPath: IndexPath) {
        ApiManager.request(methodName: EndPoint.readNotification.path, parameters: [ApiKeys.notificationId: notificationId], methodType: .put, showLoader: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let _: GenericResponse = self.handleSuccess(data: data) {
                    self.delegate?.markSingleNotificationRead(indexPath: indexPath)
                }
            case .failure(let error):
                Console.log(error?.localizedDescription)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func readAllNotification(showLoader: Bool = true, pullToRefresh: Bool = false) {
        setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        let endPoint = "?" + ApiKeys.page + "=" + "\(pageNo)" + "&\(ApiKeys.markRead)=1"
        ApiManager.request(methodName: EndPoint.homeNotification.path + endPoint, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: NotificationModel = NotificationModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.parseModel(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse, isMarkRead: true)
                } else {
                    self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getNotifications(showLoader: Bool = true, pullToRefresh: Bool = false) {
        
        setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        let endPoint = "?" + ApiKeys.page + "=" + "\(pageNo)"
        ApiManager.request(methodName: EndPoint.homeNotification.path + endPoint, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: NotificationModel = NotificationModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.parseModel(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse, isMarkRead: false)
                } else {
                    self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension NotificationBuilderVM {
    
    private func parseModel(showLoader: Bool, pullToRefresh: Bool, model: NotificationModel, isMarkRead: Bool) {
        if isMarkRead {
            delegate?.markAllRead()
        } else {
            if pullToRefresh || self.pageNo == 1 {
                self.model = nil
            }
            
            if self.model == nil {
                self.model = model
            } else {
                self.model?.result.list.append(contentsOf: model.result.list)
            }
            pageNo += 1
            nextHit = (self.model?.result.list.count ?? 0) < model.result.count
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            self.delegate?.success()
        }
    }
    
    private func setup(type: ResponseType, shouldShowLoader: Bool, pullToRefresh: Bool, error: String? = nil) {
        switch type {
        case .willHit:
            isHittingApi = true
            if pullToRefresh {
                self.pageNo = 1
            }
            
            if shouldShowLoader {
                tableViewOutlet.showBottomLoader(delegate: self)
            }
        case .success:
            tableViewOutlet.hideBottomLoader()
        case .failure:
            if shouldShowLoader {
                tableViewOutlet.showBottomLoader(delegate: self, isNetworkConnected: false)
            }else {
                tableViewOutlet.hideBottomLoader()
            }
            self.delegate?.failure(message: error ?? "")
        }
    }
    
    func hitPagination(index: Int) {
        if nextHit && index == (model?.result.list.count ?? 0) - 1 && !isHittingApi {
            if CommonFunctions.isConnectedToNetwork() {
                getNotifications(showLoader: false)
            }else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension NotificationBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            getNotifications(showLoader: false)
        }
    }
}
