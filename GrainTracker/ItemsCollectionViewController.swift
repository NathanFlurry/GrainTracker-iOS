//
//  ItemsCollectionViewController.swift
//  GrainTracker
//
//  Created by Adi Sidapara on 7/24/15.
//  Copyright (c) 2015 AzBrainFood. All rights reserved.
//

import UIKit

let reuseIdentifier = "ItemCell"

class ItemsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the delgate to self, redundant to enable UICollectionViewDelegateFlowLayout
        collectionView?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemCollectionViewCell
        
        // Configure the cell
        cell.titleLabel.text = "Some Item"
        cell.detailsLabel.text = "A • B"
        cell.sliderCountLabel.text = "0"
        
        var count = 0
        cell.deltaChangeCallback = {
            change in
            count += change
            cell.sliderCountLabel.text = String(count)
        }
        
        cell.commitChanges = {
            print("commit")
        }
    
        return cell
    }
    
    // MARK: UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / round(view.bounds.width / 160), height: 103)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    // MARK: UI actions
    @IBAction func addItemBarButtonItemTapped(button: UIBarButtonItem) {
        // Make the alert view
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        alertController.addAction(
            UIAlertAction(
                title: "Barcode",
                style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    print("Barcode")
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Manual",
                style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    self.performSegueWithIdentifier("manual", sender: button)
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Camera",
                style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    self.performSegueWithIdentifier("camera", sender: button)
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler: nil
            )
        )
        
        // Present it
        presentViewController(
            alertController,
            animated: true,
            completion: nil
        )
    }

}
