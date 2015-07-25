//
//  Dictionary+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import Foundation

extension Dictionary {
    func arrayOfKeys() -> [Any] {
        var array: [Any] = []
        for (key, _) in self {
            array.insert(key, atIndex: array.count)
        }
        return array
    }
    func arrayOfValues() -> [Any] {
        var array: [Any] = []
        for (_, value) in self {
            array.insert(value, atIndex: array.count)
        }
        return array
    }
}