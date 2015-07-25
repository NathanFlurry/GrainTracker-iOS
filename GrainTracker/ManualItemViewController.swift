//
//  ManualItemViewController.swift
//  GrainTracker
//
//  Created by Nathan Flurry on 7/25/15.
//  Copyright © 2015 AzBrainFood. All rights reserved.
//

import UIKit

class ManualItemViewController: UITableViewController {
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var packageCountTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelItem(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitItem(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
