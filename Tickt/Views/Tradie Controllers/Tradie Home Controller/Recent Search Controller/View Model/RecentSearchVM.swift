//
//  RecentSearchVM.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import Foundation

protocol RecentSearchDelegate: AnyObject {
    func failure(error: String)
    func success(model: SearchedResultModel)
    func didDeletedRecentSearch(indexPath: IndexPath)
    func didGetRecentSearch(model: RecentSearchModel)
}

class RecentSearchVM: BaseVM {
    
    weak var delegate: RecentSearchDelegate?

    func deleteRecentJobs(id: String, indexPath: IndexPath) {
        ApiManager.request(methodName: EndPoint.deleteRecentSearch.path, parameters: [ApiKeys.id: id, ApiKeys.status: "0"], methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didDeletedRecentSearch(indexPath: indexPath)
                    } else {
                        self?.delegate?.failure(error: serverResponse.message)
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getRecentJobs(showLoader: Bool = false) {
        ApiManager.request(methodName: EndPoint.getRecentSearch.path, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: RecentSearchModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success || serverResponse.statusCode == StatusCode.emptyData {
                        self?.delegate?.didGetRecentSearch(model: serverResponse)
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getSearchedJobs(searchText: String) {
        ApiManager.request(methodName: EndPoint.getSearchedData.path + searchText, parameters: nil, methodType: .get, showLoader: false) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: SearchedResultModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success || serverResponse.statusCode == StatusCode.emptyData {
                        self?.delegate?.success(model: serverResponse)
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
