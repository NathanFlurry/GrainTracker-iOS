//
//  String+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import Foundation

extension String {
    subscript(integerIndex: Int) -> Character {
        let index = advance(startIndex, integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = advance(startIndex, integerRange.startIndex)
        let end = advance(startIndex, integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
    
    static func randomString(length: Int) -> String {
        var letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var str = ""
        for _ in 1...length {
            str.append(letters[random() % letters.characters.count])
        }
        return str
    }
}