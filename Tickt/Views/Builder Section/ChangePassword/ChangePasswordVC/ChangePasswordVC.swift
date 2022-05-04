//
//  ChangePasswordVC.swift
//  Tickt
//
//  Created by S H U B H A M on 24/06/21.
//

import UIKit

class ChangePasswordVC: BaseVC {

    enum SectionType: String {
        
        case oldPassword = "Old password"
        case newPassword = "New password"
        case confirmPassword = "Confirm new password"
        case description = ""
        
        var titleSize: CGFloat {
            switch self {
            default:
                return 30
            }
        }
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    //MARK:- Variables
    var model = PasswordModel()
    var viewModel = ChangePasswordVM()
    var sectionArray: [SectionType] = [.oldPassword, .newPassword, .confirmPassword, .description]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
            disableButton(sender)
        case bottomButton:
            if validate() {
                viewModel.changePassword(model: model)
            }
        default:
            break
        }
    }
}

extension ChangePasswordVC {
    
    private func initalSetup() {
        viewModel.delegate = self
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: DescriptionTableCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    private func goToNextVC() {
        CommonFunctions.removeUserDefaults()
        ///
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .passwordChanged
        push(vc: vc)
    }
}

extension ChangePasswordVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .description:
            let cell = tableView.dequeueCell(with: DescriptionTableCell.self)
            cell.descriptionLabel.textColor = AppColors.themeGrey
            cell.descriptionLabel.font = UIFont.systemFont(ofSize: 15)
            cell.descriptionText = "Please ensure your password is at least 8 characters long and contains a special character & an uppercase letter or number."
            return cell
        default:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.tableView = tableView
            cell.topConstraint.constant = 2
            cell.commonTextFiled.placeholder = sectionArray[indexPath.section].rawValue
            cell.commonTextFiled.isSecureText = true
            cell.commonTextFiled.setupPasswordTextField()
            ///
            cell.updateTextWithIndexClosure = { [weak self] text, index in
                guard let self = self else { return }
                switch self.sectionArray[index.section] {
                case .oldPassword:
                    self.model.oldPassword = text
                case .newPassword:
                    self.model.newPassword = text
                case .confirmPassword:
                    self.model.confirmPassword = text
                default:
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = UIFont.systemFont(ofSize: 15)
        header.headerLabel.textColor = AppColors.themeGrey
        header.headerLabel.text = sectionArray[section].rawValue
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].titleSize
    }
}

//MARK:- ChangePasswordVM: Delegate
//=================================
extension ChangePasswordVC: ChangePasswordVMDelegate {
    
    func success() {
        goToNextVC()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}


extension ChangePasswordVC {
    
    private func validate() -> Bool {
        
        if model.oldPassword.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter old password")
            return false
        }
        
        if model.newPassword.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter new password")
            return false
        }
        
        if model.confirmPassword.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter confirm password")
            return false
        }
        
        if !model.newPassword.checkIfValid(.password) {
            CommonFunctions.showToastWithMessage("Please enter a valid password (must be at least 8 characters long & contain a special character or number)")
            return false
        }
        
        if model.newPassword != model.confirmPassword {
            CommonFunctions.showToastWithMessage("The New password and confirm new password doesn’t match")
            return false
        }
        
        return true
    }
}
