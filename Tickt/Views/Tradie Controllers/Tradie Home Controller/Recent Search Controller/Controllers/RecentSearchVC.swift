//
//  RecentSearchVC.swift
//  Tickt
//
//  Created by Admin on 25/03/21.
//

import UIKit

class RecentSearchVC: BaseVC {
        
    var isSearchEnabled = false
    var viewModel = RecentSearchVM()
    var searchModel: SearchedResultModel?
    var recentSearchModel: RecentSearchModel?        
         
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchField: CustomMediumField!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isSearchEnabled {
            viewModel.delegate = self
            viewModel.getRecentJobs(showLoader: true)
        }
        kAppDelegate.searchModel.specializationId.removeAll()
    }
    
    private func initialSetup() {
        searchField.setAttributedPlaceholder(placeholderText: "What jobs are you after?", font: UIFont.kAppDefaultFontMedium(ofSize: CGFloat(searchField.tag)), color: UIColor(hex: "#313D48"))
        searchTableView.register(UINib(nibName: SearchHeaderView.defaultReuseIdentifier, bundle: .main), forHeaderFooterViewReuseIdentifier: SearchHeaderView.defaultReuseIdentifier)
        searchTableView.register(UINib(nibName: RecentSearchCell.defaultReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: RecentSearchCell.defaultReuseIdentifier)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case cancelSearchButton:
            searchField.text = ""
            isSearchEnabled = false
            searchField.becomeFirstResponder()
            searchImage.isHidden = false
            widthConstraint.constant = 30
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
            mainQueue { [weak self] in
                self?.searchTableView.reloadData()
            }
        default:
            print("")
        }
        disableButton(sender)
    }    
}
