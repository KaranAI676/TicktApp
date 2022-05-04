//
//  PortfolioDetailsBuilder+Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 13/06/21.
//

import Foundation

extension PortfolioDetailsBuilderVC {
    
    func initialSetup() {
        self.popUpView.alpha = 0
        viewModel.delegate = self
        saveButton.isHidden = !isEdit
        threeDotButton.isHidden = !isEdit
        sectionArray = [.images, .description]
        setupTableView()
        navTitleLabel.text = model?.jobName ?? loggedInBuilderPortfolio?.jobName ?? ""
    }
    
    private func setupTableView() {
        tableViewOutlet.registerCell(with: DescriptionTableCell.self)
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: PortfolioCollectionViewTableCell.self)        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func gotoAddPortfolioVC(_ index: Int? = nil) {
        let vc = AddPortfolioBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        vc.delegate = self
        ///
        var addModel = AddPortfolioBuilderModel()
        if kUserDefaults.isTradie() {
            addModel.id =  model?.portfolioId ?? ""
            addModel.jobName = model?.jobName ?? ""
            addModel.jobDescription = model?.jobDescription ?? ""
            addModel.images = model?.portfolioImage.map({ eachModel -> (String?, UIImage?) in
                return (eachModel, nil)
            }) ?? []
        } else {
            addModel.id =  loggedInBuilderPortfolio?.portfolioId ?? ""
            addModel.jobName = loggedInBuilderPortfolio?.jobName ?? ""
            addModel.jobDescription = loggedInBuilderPortfolio?.jobDescription ?? ""
            addModel.images = loggedInBuilderPortfolio?.portfolioImage?.map({ eachModel -> (String?, UIImage?) in
                return (eachModel, nil)
            }) ?? []
        }
        vc.model = addModel
        push(vc: vc)
    }
}
