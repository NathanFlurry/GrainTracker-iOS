//
//  Timer.swift
//  Jubel
//
//  Created by Nathan Flurry on 5/24/15.
//  Copyright (c) 2015 Jubel, LLC. All rights reserved.
//

import Foundation

typealias TimerCallback = (timer: Timer) -> Void

class Timer: NSObject { // Uses NSObject to allow selectors
    var timer: NSTimer = NSTimer()
    var callback: TimerCallback
    
    init(interval: NSTimeInterval, repeats: Bool, callback: TimerCallback) { // Interval is in seconds
        self.callback = callback
        
        super.init()
        
        timer = NSTimer(timeInterval: interval, target: self, selector: Selector("fire:"), userInfo: nil, repeats: repeats)
        
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    convenience init(interval: NSTimeInterval, callback: TimerCallback) {
        self.init(interval: interval, repeats: false, callback: callback)
    }
    
    func fire(timer: NSTimer) {
        callback(timer: self)
    }
    
    func invalidate() {
        timer.invalidate()
    }
}