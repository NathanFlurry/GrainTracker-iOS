//
//  Array+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/19/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import Foundation

extension Array {
    func random() -> Element {
        return self[ Int.random() % self.count ]
    }
}