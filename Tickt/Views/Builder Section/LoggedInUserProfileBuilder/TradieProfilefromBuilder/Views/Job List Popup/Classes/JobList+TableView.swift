//
//  JobList+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 16/08/21.
//

extension JobListPopup: TableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jobModel?.result.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: JobListPopupCell.self)
        cell.jobDetail = viewModel.jobModel?.result.data[indexPath.row].jobData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let jobData = viewModel.jobModel?.result.data[indexPath.row] {
            delegate?.didJobSelected(jobDetail: jobData)
            popOut()
        }
    }
}

extension JobListPopup: JobListDelegate {
    func didGetJobList() {
        watermarkLabel.isHidden = !(viewModel.jobModel?.result.data.count ?? 0 == 0)
        jobTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func failure(error: String) {
        
    }
}
