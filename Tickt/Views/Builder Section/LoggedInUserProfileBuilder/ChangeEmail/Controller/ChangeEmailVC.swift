//
//  ChangeEmailVC.swift
//  Tickt
//
//  Created by S H U B H A M on 06/07/21.
//

import UIKit

class ChangeEmailVC: BaseVC {

    enum SectionArray: String {
        
        case email = "New Email"
        case password = "Current Password"
        
        var height: CGFloat {
            return 30
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    ///
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    //MARK:- Variables
    var viewModel = ChangeEmailVM()
    var model = ChangeEmailModel()
    var sectionArray: [SectionArray] = [.email, .password]
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case bottomButton:
            if validate() {
                viewModel.changeEmail(model: model)
            }
        default:
            break
        }
    }
}

extension ChangeEmailVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.layoutIfNeeded()
    }
    
    private func goToVerifyEmailVC() {
        let vc = VerifyPhoneNumberVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .changeEmail
        vc.model = model
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ChangeEmailVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
        cell.tableView = tableView
        cell.topConstraint.constant = 2
        cell.commonTextFiled.placeholder = sectionArray[indexPath.section].rawValue
        if sectionArray[indexPath.section] == .password {
            cell.commonTextFiled.isSecureText = true
            cell.commonTextFiled.setupPasswordTextField()
            cell.commonTextFiled.text = self.model.password
        }else {
            cell.commonTextFiled.setupNormalTextField()
            cell.commonTextFiled.text = self.model.newEmail
        }
        ///
        cell.updateTextWithIndexClosure = { [weak self] (text, index) in
            guard let self = self else { return }
            switch self.sectionArray[index.section] {
            case .email:
                self.model.newEmail = text
            case .password:
                self.model.password = text
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = UIFont.systemFont(ofSize: 14)
        header.headerLabel.text = sectionArray[section].rawValue
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}

extension ChangeEmailVC {
    
    private func validate() -> Bool {
        
        if model.newEmail.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter email address")
            return false
        }
        
        if !model.newEmail.isValidEmail() {
            CommonFunctions.showToastWithMessage(Validation.errorEmailInvalid)
            return false
        }
        
        if model.password.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter the password")
            return false
        }
        
        return true
    }
}

extension ChangeEmailVC: ChangeEmailVMDelegate {
    
    func success() {
        goToVerifyEmailVC()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
