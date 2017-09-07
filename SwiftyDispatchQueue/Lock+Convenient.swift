//
//  Lock+Convenient.swift
//  SwiftyDispatchQueue
//
//  Created by kemchenj on 08/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

extension Lock {
    
    @inline(__always)
    func excuteWithLock(_ block: DispatchBlock) {
        lock()
        
        block()
        
        unlock()
    }
}

extension Condition {
    
    @inline(__always)
    func wait(until condition: @autoclosure () -> Bool, locked: Bool = false) {
        if locked { lock() }
        
        while !condition() {
            wait()
        }
        
        if locked { unlock() }
    }
    
    @inline(__always)
    func excuteWithLock(needSignal: Bool = false, _ block: DispatchBlock) {
        lock()
        
        block()
        
        if needSignal { signal() }
        unlock()
    }
}
