//
//  Type.swift
//  SwiftyDispatchQueue
//
//  Created by kemchenj on 08/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

import Foundation

typealias Lock          = Foundation.NSLock
typealias Condition     = Foundation.NSCondition
typealias ConditionLock = Foundation.NSConditionLock
typealias Thread        = Foundation.Thread
typealias Date          = Foundation.Date

typealias DispatchBlock = () -> Void

func sleep(_ seconds: Double) {
    _ = Foundation.usleep(useconds_t(seconds * 1000000))
}
