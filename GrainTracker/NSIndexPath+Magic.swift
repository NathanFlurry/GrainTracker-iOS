//
//  NSIndexPath+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 7/3/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import UIKit

extension NSIndexPath {
    class func indexPathsInRange(range: Range<Int>, section: Int = 0, isCollectionView: Bool = false) -> [NSIndexPath] {
        var indexPaths: [NSIndexPath] = []
        for index in range {
            if isCollectionView {
                indexPaths += [ NSIndexPath(forItem: index, inSection: section)]
            } else {
                indexPaths += [ NSIndexPath(forRow: index, inSection: section)]
            }
        }
        return indexPaths
    }
}