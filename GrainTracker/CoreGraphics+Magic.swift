//
//  CoreGraphics+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
}