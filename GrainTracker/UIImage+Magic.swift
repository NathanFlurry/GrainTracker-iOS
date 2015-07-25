//
//  UIImage+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 7/2/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import UIKit

extension UIImage {
    func unrotatedImage() -> UIImage {
        UIGraphicsBeginImageContext(size)
        drawInRect(CGRect(origin: CGPointZero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func cropToSquare() -> UIImage {
        // Get destination crop size
        var cropRect = CGRect(origin: CGPointZero, size: size)
        if size.width > size.height {
            cropRect.size.width = size.height
        } else {
            cropRect.size.height = size.width
        }
        
        // Get origin for the crop frame
        cropRect.origin = CGPoint(
            x: (size.width - cropRect.size.width) / 2,
            y: (size.height - cropRect.size.height) / 2
        )
        
        // Crop the image
        let croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect)
        
        return UIImage(CGImage: croppedImageRef!)
    }
    
    func colorAtPoint(point: CGPoint) -> UIColor? {
        if point.x > 0 && point.x < size.width && point.y > 0 && point.y < size.height {
            let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
            var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            
            let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
            
            return UIColor(
                red: CGFloat(data[pixelInfo]) / CGFloat(255.0),
                green: CGFloat(data[pixelInfo+1]) / CGFloat(255.0),
                blue: CGFloat(data[pixelInfo+2]) / CGFloat(255.0),
                alpha: CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
            )
        } else {
            return nil
        }
    }
    
    func averageColor() -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(1)
        
        let context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), CGImage)
        
        return UIColor(
            red: CGFloat(rgba[0]) / 255,
            green: CGFloat(rgba[1]) / 255,
            blue: CGFloat(rgba[2]) / 255,
            alpha: CGFloat(rgba[3]) / 255
        )
    }
}
