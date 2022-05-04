//
//  PortfolioDetailsBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 29/06/21.
//

import Foundation

protocol PortfolioDetailsBuilderVMDelegate: AnyObject {
    
    func deleteSuccess()
    func failure(message: String)
}

class PortfolioDetailsBuilderVM: BaseVM {
    
    weak var delegate: PortfolioDetailsBuilderVMDelegate? = nil
    
    func deleteTradiePortfolio(id: String) {
        ApiManager.request(methodName: EndPoint.deleteTradiePortfilio.path + "?\(ApiKeys.portfolioId)=\(id)", parameters: nil, methodType: .delete) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.delegate?.deleteSuccess()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
