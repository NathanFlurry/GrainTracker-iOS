//
//  ScannerViewController.swift
//  GrainTracker
//
//  Created by Nathan Flurry on 7/25/15.
//  Copyright © 2015 AzBrainFood. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {
    @IBOutlet var scannerView: UIView!
    
    //var barcodeScanner: MTBBarcodeScanner!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make barcode scanner
        //barcodeScanner = MTBBarcodeScanner(previewView: scannerView)
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

}
