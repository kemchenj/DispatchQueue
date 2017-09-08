//
//  Counter.swift
//  SwiftyDispatchQueue
//
//  Created by kemchenj on 09/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

import Foundation

class Counter {
    private var queue = Foundation.DispatchQueue(label: "DispatchQueue")
    private(set) var value = 0
    
    func increment() {
        queue.sync {
            value += 1
        }
    }
    
    func decrement() {
        queue.sync {
            value -= 1
        }
    }
    
    func reset() {
        queue.sync {
            value = 0
        }
    }
}
