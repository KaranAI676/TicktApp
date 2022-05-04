//
//  AddBankVC.swift
//  Tickt
//
//  Created by Appinventiv on 03/01/22.
//

import UIKit
import Stripe

class AddBankVC: BaseVC {
    
    
    //MARK:-IBOutlets.
    @IBOutlet weak var backGroundView: UIView!
    
    
    //MARK:-Properties.
    var viewModel : AddBankVM = AddBankVM()
    var paymentDetailModel = ApproveDeclineMilestoneModel()
    var amount:Int = 0
    private var becsFormView = STPAUBECSDebitFormView(companyName: "Example Company Inc.")
    private let payButton = UIButton()
    private var paymentIntentClientSecret: String?
    
    
    //MARK:-ViewLife Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.viewModel.getPaymentCreateClientSecretKey(data: paymentDetailModel)
        backGroundView.backgroundColor = .secondarySystemBackground
        payButton.layer.cornerRadius = 5
        payButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        payButton.backgroundColor = .systemGray3
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        payButton.setTitle("Accept Mandate and Pay", for: .normal)
        payButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
        payButton.isEnabled = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.addSubview(payButton)
        becsFormView.becsDebitFormDelegate = self
        becsFormView.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.addSubview(becsFormView)
        
        NSLayoutConstraint.activate([
            becsFormView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: becsFormView.trailingAnchor),
            
            becsFormView.topAnchor.constraint(equalToSystemSpacingBelow: backGroundView.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            
            payButton.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            payButton.topAnchor.constraint(equalToSystemSpacingBelow: becsFormView.bottomAnchor, multiplier: 2),
        ])
    }
    
    private func getParams(_ model: ApproveDeclineMilestoneModel) -> [String: Any] {
        let params: [String: Any] = [ApiKeys.jobId: model.jobId,
                                     ApiKeys.milestoneAmount: model.milestoneData.milestoneAmount.decimalValue,
                                     ApiKeys.paymentMethodId: "Bank Account",
                                     ApiKeys.milestoneId: model.milestoneData.milestoneId]
        return params
    }
    
    @objc
    func pay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret,
              let paymentMethodParams = becsFormView.paymentMethodParams else {
            return;
        }
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        paymentIntentParams.sourceParams?.amount = NSNumber(value: Int(paymentDetailModel.milestoneData.milestoneAmount.replace(string: "$", withString: "")) ?? 0)
        CommonFunctions.showActivityLoader()
        STPPaymentHandler.shared().confirmPayment(paymentIntentParams,
                                                  with: self)
        { (handlerStatus, paymentIntent, error) in
            switch handlerStatus {
            case .succeeded:
                var parameters = self.getParams(self.paymentDetailModel)
                parameters[ApiKeys.amount] = paymentIntent?.amount
                parameters[ApiKeys.status] = 1
                ApiManager.request(methodName: EndPoint.jobBuilderMilestoneApproveDecline.path, parameters: parameters , methodType: .put) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success( _):
                        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
                        vc.screenType = .milestonePaymentSuccess
                       self.push(vc: vc)
                    case .failure(let error):
                        CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "Unknown")
                    default:
                        Console.log("Do Nothing")
                    }
                }
                
                break
            //                Optional(<Stripe.STPPaymentIntent: 0x600002657200; stripeId = pi_3KK1DwKjjnW7jXnV1VtDw8hw; amount = 210000; canceledAt = nil; captureMethod = Optional("automatic"); clientSecret = <redacted>; confirmationMethod = Optional("automatic"); created = 2022-01-20 14:02:48 +0000; currency = aud; description = nil; lastPaymentError = nil; livemode = false; nextAction = nil; paymentMethodId = Optional("pm_1KK1EWKjjnW7jXnVT4DdH62M"); paymentMethod = Optional(<Stripe.STPPaymentMethod: 0x7f93aa774a10; stripeId = pm_1KK1EWKjjnW7jXnVT4DdH62M; alipay = nil; auBECSDebit = Optional(<Stripe.STPPaymentMethodAUBECSDebit: 0x60000004fec0; bsbNumber = 000000; fingerprint = vHVcPglBxxs8hTbG; last4 = 3456>); bacsDebit = nil; bancontact = nil; billingDetails = Optional(<Stripe.STPPaymentMethodBillingDetails: 0x6000039db430; name = Harpreet; phone = ; email = Harpreet@yopmail.com; address = Optional(<Stripe.STPPaymentMethodAddress: 0x600003411a80; line1 = ; line2 = ; city = ; state = ; postalCode = ; country = >)>); card = nil; cardPresent = nil; created = Optional(2022-01-20 14:03:24 +0000); customerId = cus_KtXLVn3pqRKCek; ideal = nil; eps = nil; fpx = nil; giropay = nil; netBanking = nil; oxxo = nil; grabPay = nil; payPal = nil; przelewy24 = nil; sepaDebit = nil; sofort = nil; upi = nil; afterpay_clearpay = nil; blik = nil; weChatPay = nil; boleto = nil; liveMode = NO; type = au_becs_debit>); paymentMethodTypes = Optional(["au_becs_debit"]); receiptEmail = nil; setupFutureUsage = Optional("off_session"); shipping = nil; sourceId = nil; status = Optional("processing"); unactivatedPaymentMethodTypes = []>)
            //                0 elements
            case .canceled,.failed:
                CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "")
                
            @unknown default:
                fatalError()
            }
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.pop()
    }
    
}

extension AddBankVC: STPAUBECSDebitFormViewDelegate {
    func auBECSDebitForm(_ form: STPAUBECSDebitFormView, didChangeToStateComplete complete: Bool) {
        payButton.isEnabled = complete
        payButton.backgroundColor = complete ? .systemBlue : .systemGray3
    }
}


extension AddBankVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension AddBankVC : AddBankVMDelegate {
    func success(key: String) {
        self.paymentIntentClientSecret = key
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
    
    
}
