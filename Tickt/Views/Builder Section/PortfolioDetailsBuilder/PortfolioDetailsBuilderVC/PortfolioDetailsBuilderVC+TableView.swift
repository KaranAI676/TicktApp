//
//  PortfolioDetailsBuilderVC+TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 13/06/21.
//

import Foundation

extension PortfolioDetailsBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .images:
            let cell = tableView.dequeueCell(with: PortfolioCollectionViewTableCell.self)
            cell.portfolioImagesUrlModel = portfolioImageUrls
            return cell
        case .description:
            let cell = tableView.dequeueCell(with: DescriptionTableCell.self)
            if kUserDefaults.isTradie() {
                cell.descriptionText = model?.jobDescription ?? ""
            } else {
                cell.descriptionText = isEdit ? (loggedInBuilderPortfolio?.jobDescription ?? "") : (model?.jobDescription ?? "")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = sectionArray[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}
