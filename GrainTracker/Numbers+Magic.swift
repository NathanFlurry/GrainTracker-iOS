//
//  Numbers+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import Foundation

extension Float {
    static func random() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }
}

extension Double {
    static func random() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
}

extension Int {
    func abbreviateNumber() -> String {
        func floatToString(val: Float) -> String {
            var ret: NSString = NSString(format: "%.1f", val)
            
            let c = ret.characterAtIndex(ret.length - 1)
            
            if c == 46 {
                ret = ret.substringToIndex(ret.length - 1)
            }
            
            return ret as String
        }
        
        var abbrevNum = ""
        var num: Float = Float(self)
        
        if num >= 1000 {
            var abbrev = ["K","M","B"]
            
            for var i = abbrev.count-1; i >= 0; i-- {
                let sizeInt = Int(pow(Double(10), Double((i + 1) * 3)))
                let size = Float(sizeInt)
                
                if size <= num {
                    num = num/size
                    var numStr: String = floatToString(num)
                    if numStr.hasSuffix(".0") {
                        numStr = numStr.substringToIndex(advance(numStr.startIndex,numStr.characters.count-2))
                    }
                    
                    let suffix = abbrev[i]
                    abbrevNum = numStr+suffix
                }
            }
        } else {
            abbrevNum = "\(num)"
            if abbrevNum.hasSuffix(".0") {
                abbrevNum = abbrevNum.substringToIndex(advance(abbrevNum.startIndex, abbrevNum.characters.count-2))
            }
        }
        
        return abbrevNum
    }
    
    func inRange(min: Int,_ max: Int) -> Bool {
        return (self >= min && self <= max)
    }
    
    static func random() -> Int {
        return Int(arc4random())
    }
}

// MARK: Doesn't work
/*extension Comparable {
    func inRange<T>(min: T, max: T) -> Bool {
        return (self >= min && self <= max)
    }
}*/