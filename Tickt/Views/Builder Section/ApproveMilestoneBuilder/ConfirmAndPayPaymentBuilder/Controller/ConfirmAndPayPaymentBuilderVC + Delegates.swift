//
//  ConfirmAndPayPaymentBuilderVC + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 11/07/21.
//

import Foundation

//MARK:- ConfirmAndPayPaymentBuilderVM: Delegate
//==============================================
extension ConfirmAndPayPaymentBuilderVC: ConfirmAndPayPaymentBuilderVMDelegate {
    
    func cardDeleteSuccess(index: IndexPath) {
        let deletedCard = viewModel.model?.remove(at: index.row)
        delegate?.getDeletedCard(cardId: deletedCard?.cardId ?? "")
        tableViewOutlet.reloadWithAnimation()
    }
    
    func successGetCardList() {
        setupRecentCard()
        tableViewOutlet.reloadData()
    }
    
    func successApprove() {
        if let remainingNonApprovedCount = kAppDelegate.totalMilestonesNonApproved, remainingNonApprovedCount > 1  {
            NotificationCenter.default.post(name: NotificationName.milestoneAcceptDecline, object: nil, userInfo: [ApiKeys.milestoneId: paymentDetailModel.milestoneData.milestoneId, ApiKeys.status: 2])
        }
        goToSuccessVC(.milestonePaymentSuccess)
    }
    
    func paymentFailed(message: String) {
        goToSuccessVC(.milestonePaymentFailed)
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}

//MARK:- AddPaymentDetailsBuilderVC: Delegate
//===========================================
extension ConfirmAndPayPaymentBuilderVC: AddPaymentDetailsBuilderVCDelegate {
    
    func getNewlyAddedCard(model: CardListResultModel) {
        if let index = self.viewModel.model?.firstIndex(where: {$0.cardId == model.cardId}) {
            self.viewModel.model?[index].name = model.name
            self.viewModel.model?[index].expMonth = model.expMonth
            self.viewModel.model?[index].expYear = model.expYear
        }else {
            self.viewModel.model?.insert(model, at: 0)
        }
        tableViewOutlet.reloadData()
    }
}
