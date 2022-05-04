//
//  PortfolioDetailsBuilderVC+Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 13/06/21.
//

import Foundation

extension PortfolioDetailsBuilderVC: AddPortfolioBuilderVCDelegate {
    
    func getUpdatedPortfolios(model: PortfoliaData) {
        
        if kUserDefaults.isTradie() {
            if model.portfolioId.isEmpty {
                let portFolioId = self.model?.portfolioId ?? ""
                self.model = TradieProfilePortfolio(model)
                self.model?.portfolioId = portFolioId
            } else {
                self.model = TradieProfilePortfolio(model)
            }
            navTitleLabel.text = self.model?.jobName ?? loggedInBuilderPortfolio?.jobName ?? ""
        } else {
            loggedInBuilderPortfolio = model
            navTitleLabel.text = self.model?.jobName ?? loggedInBuilderPortfolio?.jobName ?? ""
        }
        tableViewOutlet.reloadData()
    }
}

extension PortfolioDetailsBuilderVC: PortfolioDetailsBuilderVMDelegate {
    
    func deleteSuccess() {        
        if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
            mainQueue { [weak self] in
                NotificationCenter.default.post(name: NotificationName.refreshProfile, object: nil, userInfo: nil)
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            pop()
        }
//        if let tradieModel = model {
            
//            delegate?.getDeletedPortFolio(id: tradieModel.portfolioId)
//            pop()
//        }
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
