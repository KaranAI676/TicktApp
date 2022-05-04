//
//  ReviewBuilder+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 18/06/21.
//

extension ReviewBuilderVC: ReviewBuilderDelegate {
    func didReviewBuilder() {
        let successVC = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        successVC.screenType = .reviewPosted
        push(vc: successVC)
        NotificationCenter.default.post(name: NotificationName.refreshReviewStatus, object: nil, userInfo: nil)
    }
}
