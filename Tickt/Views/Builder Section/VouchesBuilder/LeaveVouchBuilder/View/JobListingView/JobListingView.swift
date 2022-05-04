//
//  JobListingView.swift
//  Tickt
//
//  Created by S H U B H A M on 08/07/21.
//

import UIKit

class JobListingView: UIView {

    //MARK:- IB Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var containerViewHeight: CGFloat = 0
    var jobModel: [JobListingBuilderResult]? = nil {
        didSet {
            tableViewOutlet.reloadData {
                if self.tableViewOutlet.contentSize.height < self.containerViewHeight {
                    self.containerViewHeightConstraint.constant = self.tableViewOutlet.contentSize.height
                }else {
                    self.containerViewHeightConstraint.constant = self.containerViewHeight
                }
            }
        }
    }
    var jobDidSelectClosure: ((IndexPath)-> Void)? = nil
    var dismissClosure: (()-> Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            UIViewController().disableButton(sender)
            dismissClosure?()
            containerView.popOut(completion: { bool in
                self.removeFromSuperview()
            })
        default:
            break
        }
    }
}

extension JobListingView {
    
    func initialSetup() {
        setupTableView()
        dropShadow()
    }
    
    func setupTableView() {
        tableViewOutlet.registerCell(with: TitleLabelForNamesTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func dropShadow() {
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.8274509804, alpha: 1)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 5
        containerView.layer.shouldRasterize = true
    }
}

extension JobListingView: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: TitleLabelForNamesTableCell.self)
        cell.titleNameLabel.text = jobModel?[indexPath.row].jobName ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jobDidSelectClosure?(indexPath)
        buttonTapped(dismissButton)
    }
}
