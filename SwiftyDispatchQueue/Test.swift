//
//  Test.swift
//  SwiftyDispatchQueue
//
//  Created by kemchenj on 09/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

var totalFailures = 0
let failuresCounter = Counter()

func assert(_ expr: @autoclosure () -> Bool) {
    if !expr() {
        failuresCounter.increment()
        print("Assertion Failed")
    }
}

func test(name: String, block: () -> Void) {
    print("Running test <\(name)>")
    
    failuresCounter.reset()
    
    block()
    
    var message = "<\(name)> Done running test "
    message += (failuresCounter.value > 0) ? "Failure" : "Success"
    message += ", \(failuresCounter.value) failures\n"
    
    print(message)
}

func test() {
    
    test(name: "async") {
        let queue = DispatchQueue(serial: true)
        let conditionLock = ConditionLock(condition: 0)
        queue.async {
            conditionLock.lock()
            conditionLock.unlock(withCondition: 1)
        }
        
        let success = conditionLock.lock(
            whenCondition: 1,
            before       : Date(timeIntervalSinceNow: 10))
        
        if success {
           conditionLock.unlock()
        }
        
        assert(success)
    }
    
    test(name: "sync") { 
        let queue = DispatchQueue(serial: true)
        var done = false
        queue.sync {
            sleep(0.5)
            done = true
        }
        assert(done)
    }
    
    test(name: "serial") {
        let queue = DispatchQueue(serial: false)
        
        queue.async {
            sleep(0.5)
        }
        
        let activeCounter = Counter()
        let totalRunCounter = Counter()
        var maxActiveCount = 0
        
        for i in (1...10000) {
            queue.sync {
                activeCounter.increment()
                
                maxActiveCount = max(activeCounter.value, maxActiveCount)
                
                sleep(0.00001)
                
                activeCounter.decrement()
                
                totalRunCounter.increment()
                
                assert(totalRunCounter.value == i)
            }
        }
        
        queue.sync {}
        
        assert(maxActiveCount == 1)
        assert(totalRunCounter.value == 10000)
    }
    
    test(name: "concurrent") { 
        let queue = DispatchQueue(serial: false)
        
        queue.async {
            sleep(0.5)
        }
        
        let activeCounter = Counter()
        let totalRunCounter = Counter()
        var maxActiveCount = 0
        
        for _ in (1...10000) {
            queue.async {
                activeCounter.increment()
                
                maxActiveCount = max(activeCounter.value, maxActiveCount)
                
                sleep(0.0001)
                
                activeCounter.decrement()
                
                totalRunCounter.increment()
            }
        }
        
        while totalRunCounter.value < 10000 {
            sleep(0.001)
        }
        
        assert(maxActiveCount > 1)
        assert(totalRunCounter.value == 10000)
    }
    
    test(name: "global") { 
        let totalRunCounter = Counter()
        
        for _ in (1...10000) {
            DispatchQueue.global.async {
                totalRunCounter.increment()
            }
        }
        
        while totalRunCounter.value < 10000 {
            sleep(0.0001)
        }
    }

    if totalFailures > 0 {
        print("TESTS FAILED. \(totalFailures) total failed assertion")
    } else {
        print("Tests passed!")
    }
}
