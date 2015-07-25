//
//  ManualItemViewController.swift
//  GrainTracker
//
//  Created by Nathan Flurry on 7/25/15.
//  Copyright © 2015 AzBrainFood. All rights reserved.
//

import UIKit

let ItemCellIdentifier = "InputCell"

class ManualItemViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Views
    @IBOutlet var doneButton: UINavigationItem!
    
    // Data
    var fields = [ "Title", "Package count", "Quantity", "Calories", "Fat", "Cholesterol", "Sodium", "Carbohydrates", "Protein" ]
    var fieldsAreInts = [ false, true, true, false, false, false, false, false, false]
    var fieldsAreFloats = [ false, false, false, true, true, true, true, true, true]
    var textFields: [UITextField] = []
    
    // Callbacks
    var callback: () -> Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0.17, alpha: 1.0)
        tableView.separatorColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ItemCellIdentifier, forIndexPath: indexPath)
        
        let labelView = cell.viewWithTag(10) as! UILabel
        let textField = cell.viewWithTag(20) as! UITextField
        
        labelView.text = "\(fields[indexPath.row]):"
        textField.placeholder = fields[indexPath.row]
        textField.delegate = self
        
        textFields += [ textField ]
        
        return cell
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    

    @IBAction func cancelItem(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitItem(sender: AnyObject) {
        // Present loading screen
        let alertController = UIAlertController(title: "Posting", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alertController, animated: true, completion: nil)
        
        // Fetch the values
        var values: [String] = []
        for (i, textField) in textFields.enumerate() {
            if let text = textField.text {
                // Save teh value
                values += [ text ]
                
                // Check that values are valid
                if !((Int(text) != nil && fieldsAreInts[i]) || (Float(text) != nil && fieldsAreFloats[i]) || (!fieldsAreInts[i] && !fieldsAreFloats[i])) {
                    print("Invalid type at index \(i).")
                    return
                }
            }
        }
        
        // Check the right count of values
        guard values.count == fields.count else {
            print("Non-mating values and fields.")
            return
        }
        
        // Start request
        _ = Item(
            quantity: Int(values[2])!,
            barcode: nil,
            title: values[0],
            packCount: Int(values[1])!,
            nutritionInfo: NutritionInfo(
                calories: Float(values[3])!,
                fat: Float(values[4])!,
                cholesterol: Float(values[5])!,
                sodium: Float(values[6])!,
                carbohydrates: Float(values[7])!,
                protein: Float(values[8])!
            )
        ).commit {
            error in
            alertController.dismissViewControllerAnimated(
                true,
                completion: {
                    completed in
                    guard error == nil else {
                        self.presentViewController(
                            HTTPErrorAlertController(error: error!),
                            animated: true,
                            completion: nil
                        )
                        return
                    }
                    
                    self.callback()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
        }
    }
}
