//
//  UIView+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import UIKit

extension UIView {
    func forceLayout() {
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func snapshotView() -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        layer.renderInContext(context)
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return capture
    }
    
    func addQuickConstraints(constraints: [(String, NSLayoutFormatOptions?)], views: [String: UIView], metrics: [String: CGFloat]? = nil) {
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var combinedConstraints = [NSLayoutConstraint]()
        for (format, options) in constraints {
            combinedConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
                    format,
                    options: options != nil ? options! : [],
                    metrics: metrics,
                    views: views
                )
        }
        
        addConstraints(combinedConstraints)
    }
}

extension UITabBar {
    class func defaultHeight() -> CGFloat {
        return 49
    }
}