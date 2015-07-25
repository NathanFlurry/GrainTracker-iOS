//
//  Server.swift
//  GrainTracker
//
//  Created by Nathan Flurry on 7/24/15.
//  Copyright © 2015 AzBrainFood. All rights reserved.
//

import UIKit
import Alamofire

// MARK: Server
typealias ServerItemCallback = (data: [Item]?, error: NSError?) -> Void

class Server {
    static var development: Bool = false
    static var baseURL: String = development ? "http://localhost:3000/api" : "http://graintracker.herokuapp.com/api"
    
    class func parseItemJSON(item: [String: AnyObject]) -> Item {
        let itemObject = Item(
            quantity: item["quantity"] as! Int,
            barcode: item["barcode"] as? String,
            title: item["title"] as! String,
            packCount: item["pack-count"] as! Int,
            nutritionInfo: nil
        )
        itemObject.id = item["_id"] as? String
        itemObject.new = false
        
        if let nutrition = item["nutrition"] as? [String: Float] {
            itemObject.nutritionInfo = NutritionInfo(
                calories: nutrition["calories"]!,
                fat: nutrition["fat"]!,
                cholesterol: nutrition["cholesterol"]!,
                sodium: nutrition["sodium"]!,
                carbohydrates: nutrition["carbohydrates"]!,
                protein: nutrition["protein"]!
            )
        }
        
        return itemObject
    }
    
    class func allItems(offset: Int, count: Int, callback: ServerItemCallback) {
        Alamofire.request(.GET, URLString: "\(baseURL)/items/\(offset)/\(count)")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, JSON, error) in
                // Catch an error
                guard error == nil else {
                    callback(data: nil, error: error)
                    return
                }
                
                // Get the real data
                var items: [Item] = []
                if let json = JSON as? [[String: AnyObject]] {
                    for itemJSON in json {
                        items += [ parseItemJSON(itemJSON) ]
                    }
                } else {
                    print("Could not cast data.")
                }
                
                // Do the callback
                callback(data: items, error: nil)
        }
    }
    
    class func itemSearch(query: String, offset: Int, count: Int, callback: ServerItemCallback) {
        Alamofire.request(.GET, URLString: "\(baseURL)/items/\(offset)/\(count)")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, JSON, error) in
                // Catch an error
                guard error == nil else {
                    callback(data: nil, error: error)
                    return
                }
                
                // Get the real data
                var items: [Item] = []
                if let json = JSON as? [[String: AnyObject]] {
                    for itemJSON in json {
                        items += [ parseItemJSON(itemJSON) ]
                    }
                } else {
                    print("Could not cast data.")
                }
                
                // Do the callback
                callback(data: items, error: nil)
            }
    }
    
    class func itemFromBarcode(barcode: String, callback: (error: NSError?) -> Void) {
        Alamofire.request(.POST, URLString: "\(Server.baseURL)/item/barcode/\(barcode)")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, JSON, error) in
                // Catch an error
                guard error == nil else {
                    callback(error: error)
                    return
                }
                
                // Do the callback
                callback(error: nil)
        }
    }
    
    class func imageForKey(key: String, callback: (image: UIImage?, error: NSError?) -> Void) {
        Alamofire.request(
            .GET,
            URLString: "https://ajax.googleapis.com/ajax/services/search/images",
            parameters: [ "v": "1.0", "q": key ]
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, JSON, error) in
                // Catch an error
                guard error == nil || error?.code == -1 else {
                    callback(image: nil, error: error)
                    return
                }
                
                // Get the actual image
                if let url = (JSON?.valueForKeyPath("responseData.results") as! NSArray)[1].valueForKey("url") as? String {
                    Alamofire.request(.GET, URLString: normalizeURL(url))
                        .validate(statusCode: 200..<300)
                        .responseImage { (_, _, image, error) in
                            // Catch an error
                            guard error == nil || error?.code == -1 else {
                                callback(image: nil, error: error)
                                return
                            }
                            
                            // Deal with the imge
                            callback(image: image, error: error)
                    }
                } else {
                    print("Could not get URL.")
                }
        }
    }
    
    class func normalizeURL(url: String) -> String {
        return url
            .stringByReplacingOccurrencesOfString("%20", withString: " ")
            .stringByReplacingOccurrencesOfString("%21", withString: "!")
            .stringByReplacingOccurrencesOfString("%22", withString: "\"")
            .stringByReplacingOccurrencesOfString("%23", withString: "#")
            .stringByReplacingOccurrencesOfString("%24", withString: "$")
            .stringByReplacingOccurrencesOfString("%25", withString: "%")
            .stringByReplacingOccurrencesOfString("%26", withString: "&")
            .stringByReplacingOccurrencesOfString("%27", withString: "'")
            .stringByReplacingOccurrencesOfString("%28", withString: "(")
            .stringByReplacingOccurrencesOfString("%29", withString: ")")
            .stringByReplacingOccurrencesOfString("%2A", withString: "*")
            .stringByReplacingOccurrencesOfString("%2B", withString: "+")
            .stringByReplacingOccurrencesOfString("%2C", withString: ",")
            .stringByReplacingOccurrencesOfString("%2D", withString: "-")
            .stringByReplacingOccurrencesOfString("%2E", withString: ".")
            .stringByReplacingOccurrencesOfString("%2F", withString: "/")
            .stringByReplacingOccurrencesOfString("%3A", withString: ":")
            .stringByReplacingOccurrencesOfString("%3B", withString: ";")
            .stringByReplacingOccurrencesOfString("%3C", withString: "<")
            .stringByReplacingOccurrencesOfString("%3D", withString: "=")
            .stringByReplacingOccurrencesOfString("%3E", withString: ">")
            .stringByReplacingOccurrencesOfString("%3F", withString: "?")
            .stringByReplacingOccurrencesOfString("%40", withString: "@")
            .stringByReplacingOccurrencesOfString("%5B", withString: "[")
            .stringByReplacingOccurrencesOfString("%5C", withString: "\\")
            .stringByReplacingOccurrencesOfString("%5D", withString: "]")
            .stringByReplacingOccurrencesOfString("%5E", withString: "^")
            .stringByReplacingOccurrencesOfString("%5F", withString: "_")
            .stringByReplacingOccurrencesOfString("%60", withString: "`")
            .stringByReplacingOccurrencesOfString("%7B", withString: "{")
            .stringByReplacingOccurrencesOfString("%7C", withString: "|")
            .stringByReplacingOccurrencesOfString("%7D", withString: "}")
            .stringByReplacingOccurrencesOfString("%7E", withString: "~")
    }
}

// MARK: Data holders
struct NutritionInfo { // In grams
    var calories: Float
    var fat: Float
    var cholesterol: Float
    var sodium: Float
    var carbohydrates: Float
    var protein: Float
    
    func renderText() -> String {
        return "Calories: \(calories)\n" +
        "Fat: \(fat) g\n" +
        "Cholesterol: \(cholesterol) g\n" +
        "Sodium: \(sodium) g\n" +
        "Carbohydrates: \(carbohydrates) g\n" +
        "Protein: \(protein) g"
    }
}

class Item {
    var id: String?
    var quantity: Int
    var barcode: String?
    var title: String
    var packCount: Int
    var nutritionInfo: NutritionInfo?
    
    var new: Bool = true
    
    init(quantity: Int, barcode: String?, title: String, packCount: Int, nutritionInfo: NutritionInfo?) {
        self.quantity = quantity
        self.barcode = barcode
        self.title = title
        self.packCount = packCount
        self.nutritionInfo = nutritionInfo
    }
    
    // Methods
    func commit(callback: (error: NSError?) -> Void) {
        // Commit it
        if new {
            // Make the request
            var rawJSON = [
                "quantity": quantity,
                "title": title,
                "pack-count": packCount
            ] as [String: AnyObject]
            
            if let barcode = barcode {
                rawJSON["barcode"] = barcode
            }
            
            if let nutrition = nutritionInfo {
                rawJSON["nutrition"] = [
                    "calories": nutrition.calories,
                    "fat": nutrition.fat,
                    "cholesterol": nutrition.cholesterol,
                    "sodium": nutrition.sodium,
                    "carbohydrates": nutrition.carbohydrates,
                    "protein": nutrition.protein
                ]
            }
            
            Alamofire.request(.POST, URLString: "\(Server.baseURL)/item", parameters: rawJSON)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (_, _, JSON, error) in
                    // Catch an error
                    guard error == nil else {
                        callback(error: error)
                        return
                    }
                    
                    // Do the callback
                    callback(error: nil)
            }
            
            new = false
        } else {
            var rawJSON = [
                "quantity": quantity,
                "title": title,
                "pack-count": packCount
            ] as [String: AnyObject]
            
            if let barcode = barcode {
                rawJSON["barcode"] = barcode
            }
            
            if let nutrition = nutritionInfo {
                rawJSON["nutrition"] = [
                    "calories": nutrition.calories,
                    "fat": nutrition.fat,
                    "cholesterol": nutrition.cholesterol,
                    "sodium": nutrition.sodium,
                    "carbohydrates": nutrition.carbohydrates,
                    "protein": nutrition.protein
                ]
            }
            
            Alamofire.request(.POST, URLString: "\(Server.baseURL)/item/\(id!)/update", parameters: rawJSON, encoding: .JSON)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (_, _, JSON, error) in
                    // Catch an error
                    guard error == nil else {
                        callback(error: error)
                        return
                    }
                    
                    // Do the callback
                    callback(error: nil)
            }
        }
    }
}

// MARK: Error controller
class HTTPErrorAlertController: UIAlertController {
    init(error: NSError) {
        super.init(nibName: nil, bundle: nil)
        
        title = "Request Error: \(error.domain) #\(error.code)"
        message = "\(error.localizedDescription)"
        
        addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}