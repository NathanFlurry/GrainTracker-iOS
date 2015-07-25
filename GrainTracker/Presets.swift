//
//  Presets.swift
//  GrainTracker
//
//  Created by Nathan Flurry on 7/25/15.
//  Copyright © 2015 AzBrainFood. All rights reserved.
//

import UIKit
import Alamofire

let ThemeColor: UIColor = UIColor(red: 0.18, green: 1.0, blue: 0.55, alpha: 1.0)

extension Alamofire.Request {
    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request!, response, image as? UIImage, error)
        })
    }
}