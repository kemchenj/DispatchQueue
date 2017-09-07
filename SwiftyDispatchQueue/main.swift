//
//  main.swift
//  SwiftyDispatchQueue
//
//  Created by kemchenj on 08/09/2017.
//  Copyright © 2017 kemchenj. All rights reserved.
//

for i in (0...100000) {
    DispatchQueue.global.sync {
        print("\(i)")
    }
}
