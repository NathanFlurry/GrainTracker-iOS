//
//  UINavigationBar+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 7/17/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setTransparent(transparent: Bool) {
        if transparent {
            setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
            translucent = true
            shadowImage = UIImage()
        } else {
            setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
            translucent = UINavigationBar.appearance().translucent
            shadowImage = UINavigationBar.appearance().shadowImage
        }
    }
}
