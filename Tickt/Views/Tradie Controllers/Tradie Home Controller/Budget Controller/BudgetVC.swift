//
//  BudgetVC.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit

enum PayType: String {
    case perHour = "Per hour"
    case fixedPrice = "Fixed price"
}

class BudgetVC: BaseVC {
    
    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var perHourButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var fixedPriceButton: UIButton!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var bottomListViewContainer: UIView!    
    @IBOutlet weak var categoryLabel: CustomMediumLabel!
    @IBOutlet weak var subCategoryLabel: CustomRegularLabel!
    
    var price = ""
    var category: SearchedResultData?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case skipButton:
            kAppDelegate.searchModel.payType = ""
            kAppDelegate.searchModel.maxBudget = 0
            goToLocationVC()
        case backButton:
            pop()
        case continueButton:
            if detailTextField.text!.isEmpty {
                CommonFunctions.showToastWithMessage(Validation.errorEmptyMaximumBudget)
            } else {
                kAppDelegate.searchModel.payType = dropDownTextField.text!
                kAppDelegate.searchModel.maxBudget = Double.getDouble(price.byRemovingLeadingTrailingWhiteSpaces)
                goToLocationVC()
            }
        case perHourButton:
            bottomListViewContainer.popOut(completion: { [weak self] bool in
                self?.dropDownTextField.text = PayType.perHour.rawValue
                self?.arrowImage.image = self?.arrowImage.image?.rotate(radians: Float.pi)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.arrowImage.layoutIfNeeded()
                }
            })
        case fixedPriceButton:
            bottomListViewContainer.popOut(completion: { [weak self] status in
                self?.dropDownTextField.text = PayType.fixedPrice.rawValue
                self?.arrowImage.image = self?.arrowImage.image?.rotate(radians: Float.pi)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.arrowImage.layoutIfNeeded()
                }
            })
        case selectionButton:
            detailTextField.resignFirstResponder()
            let _ = bottomListViewContainer.alpha != 0 ? bottomListViewContainer.popOut() : bottomListViewContainer.popIn()
            arrowImage.image = arrowImage.image?.rotate(radians: Float.pi)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.arrowImage.layoutIfNeeded()
            }
        default:
            break
        }
        disableButton(sender)
    }
    
    private func goToLocationVC() {
        let locationVC = TLocationVC.instantiate(fromAppStoryboard: .search)
        locationVC.category = category
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bottomListViewContainer.popOut()
    }
    
    func initialSetup() {
        bottomListViewContainer.addShadow(cornerRadius: 1, color: .darkGray, offset: CGSize(width: 2, height: 2), opacity: 0.4, shadowRadius: 2)
        categoryImageView.sd_setImage(with: URL(string: category?.image ?? ""), placeholderImage: nil, options: .highPriority) { [weak self] (image, error, _ , _) in
            let resizedImage = image?.resized(toWidth: kScreenWidth * 0.5, isOpaque: false)
            self?.categoryImageView.backgroundColor = UIColor(hex: "#0B41A8")
            self?.categoryImageView.image = resizedImage
        }
        categoryLabel.text = category?.name
        subCategoryLabel.text = category?.tradeName
        bottomListViewContainer.alpha = 0
        detailTextField.delegate = self
        dropDownTextField.delegate = self
        detailTextField.addTarget(self, action: #selector(textFieldDidChange) , for: .editingChanged)
    }

}
