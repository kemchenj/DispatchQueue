//
//  ThreadPool.swift
//
//  Created by kemchenj on 07/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

protocol ThreadPoolType {
    func addBlock(_ block: @escaping DispatchBlock)
}


class ThreadPool: ThreadPoolType {
    
    let locker = Condition()
    
    let threadCountLimit  = 100
    var threadCount       = 0
    var activeThreadCount = 0
    
    var blocks = [DispatchBlock]()
    
    func addBlock(_ block: @escaping DispatchBlock) {
        locker.excuteWithLock(needSignal: true) {
            blocks.append(block)
            
            let idleThreadCount = threadCount - activeThreadCount
            if blocks.count > idleThreadCount && threadCount < threadCountLimit {
                Thread.detachNewThread(workerThreadLoop)
                threadCount += 1
            }
        }
    }
    
    func workerThreadLoop() {
        locker.lock()
        
        while true {
            locker.wait(until: !blocks.isEmpty)
            
            let block = blocks.removeFirst()
            
            activeThreadCount += 1
            locker.unlock()
            
            block()
            
            locker.lock()
            activeThreadCount -= 1
        }
    }
}
