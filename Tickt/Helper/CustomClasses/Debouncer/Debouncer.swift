//
//  Debouncer.swift
//  Tickt
//
//  Created by Tickt on 09/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import Foundation

class Debouncer {
    
    //MARK: - Variables
    //=================
    private let timeInterval: TimeInterval
    private var timer: Timer?
    var completion: (() -> Void)? = nil
    
    //MARK: - Functions
    //=================
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    /// Method to start the time
    func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: false, block: { [weak self] (_timer) in
            self?.timeIntervalDidFinish(for: _timer)
        })
    }
    
    //MARK: - Actions
    //=================
    @objc private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }
        self.completion?()
        self.completion = nil
    }
    
}
