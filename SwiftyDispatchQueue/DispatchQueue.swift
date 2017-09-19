//
//  DispatchQueue.swift
//
//  Created by kemchenj on 07/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

protocol DispatchQueueType {
    
    static var global: DispatchQueueType { get }
    
    init(serial: Bool)
    
    func async(execute block: @escaping DispatchBlock)
    func sync(execute block: @escaping DispatchBlock)
}


class DispatchQueue: DispatchQueueType {
    
    let locker = Lock()
    
    let threadPool = ThreadPool()
    
    var serialRunning = false
    let serial: Bool
    
    var pendingBlocks = [DispatchBlock]()
    
    static let global: DispatchQueueType = DispatchQueue(serial: false)
    
    required init(serial: Bool) {
        self.serial = serial
    }
    
    func async(execute block: @escaping DispatchBlock) {
        locker.executeWithLock {
            pendingBlocks.append(block)
            
            if serial && !serialRunning {
                serialRunning = true
                dispatchOneBlock()
            } else if !serial {
                dispatchOneBlock()
            }
        }
    }
    
    func sync(execute block: @escaping DispatchBlock) {
        let condition = Condition()
        
        var done = false
        
        async {
            block()
            
            condition.executeWithLock(needSignal: true) {
                done = true
            }
        }
        
        condition.wait(until: done, locked: true)
    }
    
    func dispatchOneBlock() {
        threadPool.addBlock {
            var block: DispatchBlock!
            
            self.locker.executeWithLock {
                block = self.pendingBlocks.removeFirst()
            }
            
            block()
            
            if self.serial {
                self.locker.executeWithLock {
                    if self.pendingBlocks.count > 0 {
                        self.dispatchOneBlock()
                    } else {
                        self.serialRunning = true
                    }
                }
            }
        }
    }
}
