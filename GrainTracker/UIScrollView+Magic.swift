//
//  UIScrollView+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 7/4/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        setContentOffset(CGPoint(x: -contentInset.left, y: -contentInset.top), animated: true)
    }
}
