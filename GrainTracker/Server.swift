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
            id: item["_id"] as! String,
            quantity: item["quantity"] as! Int,
            barcode: item["barcode"] as? Int,
            title: item["title"] as! String,
            packCount: item["pack-count"] as! Int,
            nutritionInfo: nil
        )
        
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
        "Fat: \(fat)\n" +
        "Cholesterol: \(cholesterol)\n" +
        "Sodium: \(sodium)\n" +
        "Carbohydrates: \(carbohydrates)\n" +
        "Protein: \(protein)"
    }
}

class Item {
    var id: String
    var quantity: Int
    var barcode: Int?
    var title: String
    var packCount: Int
    var nutritionInfo: NutritionInfo?
    
    init(id: String, quantity: Int, barcode: Int?, title: String, packCount: Int, nutritionInfo: NutritionInfo?) {
        self.id = id
        self.quantity = quantity
        self.barcode = barcode
        self.title = title
        self.packCount = packCount
        self.nutritionInfo = nutritionInfo
    }
    
    // Methods
    func commit() {
        
    }
}

class User {
    var id: String
    var username: String
    var displayName: String
    
    init(id: String, username: String, displayName: String) {
        self.id = id
        self.username = username
        self.displayName = displayName
    }
}

// MARK: Error controller
class HTTPErrorAlertController: UIAlertController {
    init(error: NSError) {
        // self.init(title: "Request Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        super.init(nibName: nil, bundle: nil)
        
        title = "Request Error: \(error.domain) #\(error.code)"
        message = error.localizedDescription
        preferredStyle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}