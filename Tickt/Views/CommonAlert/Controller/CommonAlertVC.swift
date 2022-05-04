//
//  CommonAlertVC.swift
//  Tickt
//
//  Created by S H U B H A M on 27/09/21.
//

import UIKit

class CommonAlertVC: BaseVC {

    enum AlertAction {
        case acceptButton
        case declineButton
    }
        
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertSubTitleLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
        
    var model: CommonAlertModel?
    var btnActionClosure: ((AlertAction) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        switch sender {
        case acceptButton:
            view.fadeOut() {
                self.dismiss(animated: false) {
                    self.btnActionClosure?(.acceptButton)
                }
            }
        case declineButton:
            view.fadeOut() {
                self.dismiss(animated: false) {
                    self.btnActionClosure?(.declineButton)
                }
            }
        default:
            break
        }
    }
}

extension CommonAlertVC {
    
    private func initialSetup() {
        setPopupData()
        setupPopView()
    }
    
    private func setupPopView() {
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        
        alertTitleLabel.font = UIFont.kAppDefaultFontBold(ofSize: 18)
        alertTitleLabel.textColor = AppColors.themeBlue
        
        alertSubTitleLabel.font = UIFont.kAppDefaultFontRegular(ofSize: 14)
        alertSubTitleLabel.textColor = AppColors.themeBlue
        
        backgroundView.makeRoundToCorner(cornerRadius: 6.0)
        
        acceptButton.makeRoundToCorner(cornerRadius: 6.0)
        acceptButton.backgroundColor = AppColors.themeYellow
        acceptButton.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 14)
        acceptButton.setTitleColorForAllMode(color: AppColors.themeBlue)
        
        declineButton.makeRoundToCorner(cornerRadius: 6.0)
        declineButton.backgroundColor = AppColors.backViewGrey
        declineButton.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 14)
        declineButton.setTitleColorForAllMode(color: AppColors.themeBlue)
    }
    
    private func setPopupData() {
        guard let model = model else { return }
        alertTitleLabel.text = model.alertTitle
        alertSubTitleLabel.text = model.alertSubTitle
        acceptButton.setTitleForAllMode(title: model.acceptButtonTitle)
        declineButton.setTitleForAllMode(title: model.declineButtonTitle)
        declineButton.isHidden = model.alertType == .singleButton
    }
}
