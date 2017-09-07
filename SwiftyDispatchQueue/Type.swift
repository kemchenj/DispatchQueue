//
//  Type.swift
//  SwiftyDispatchQueue
//
//  Created by kemchenj on 08/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

import Foundation

typealias Lock      = Foundation.NSLock
typealias Condition = Foundation.NSCondition
typealias Thread    = Foundation.Thread

typealias DispatchBlock = () -> Void
