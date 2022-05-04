//
//  MiscModels.swift
//  Tickt
//
//  Created by Appinventiv on 12/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation


/*
 If user has blocked someone or,
 user is blocked by someone
 */
struct BlockStatus {
    
    var hasBlockedSomeOne: Bool = false
    var someoneBlockedMe: Bool = false
}

/*
 If user has reported someone or,
 user is reported by someone
 */

struct ReportStatus {
    
    var isReported: Bool = false
    var hasReported: Bool = false
}

/*
 
 Read receipt
 
 */
struct ReadReceipt {
    
    var timeStamp: Double = 0.0
    var enable: Bool = false
}
