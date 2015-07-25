//
//  ItemsCollectionViewController.swift
//  GrainTracker
//
//  Created by Adi Sidapara on 7/24/15.
//  Copyright (c) 2015 AzBrainFood. All rights reserved.
//

import UIKit
import Alamofire

let reuseIdentifier = "ItemCell"

class ItemsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: Data
    var contentData: [Item] = []
    
    // MARK: Loading metrics
    private let loadCount: Int = 10
    private let preloadOffset: Int = 2
    private var reachedEnd: Bool = false
    
    func loadItems() {
        Server.allItems(
            contentData.count,
            count: loadCount,
            callback: {
                items, error in
                
                if let error = error {
                    self.presentViewController(
                        HTTPErrorAlertController(error: error),
                        animated: true,
                        completion: nil
                    )
                } else if let items = items {
                    // Test if at end
                    if items.count < self.loadCount {
                        self.reachedEnd = true
                    }
                    
                    // Add the items
                    self.contentData += items
                    
                    // Reload the colleciton view
                    self.collectionView?.reloadData()
                }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the delgate to self, redundant to enable UICollectionViewDelegateFlowLayout
        collectionView?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load the first items
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemCollectionViewCell
        
        // Get the data
        let data = contentData[indexPath.item]
        
        // Configure the cell
        cell.titleLabel.text = data.title
        cell.sliderCountLabel.text = String(data.quantity)
        cell.updateSubtitle(data.packCount, totalItems: data.quantity)
        
        // Hide nutrition button if needed
        if data.nutritionInfo == nil {
            cell.nutritionButton.hidden = true
        }
        
        // Callbacks
        cell.deltaChangeCallback = {
            change in
            // Change the count
            data.quantity += change
            if data.quantity < 0 {
                data.quantity = 0
            }
            cell.sliderCountLabel.text = String(data.quantity)
            
            // Update the subtitle
            cell.updateSubtitle(data.packCount, totalItems: data.quantity)
        }
        
        cell.commitChanges = {
            // Commit the changes to the server
            data.commit {
                error in
                if let error = error {
                    self.presentViewController(HTTPErrorAlertController(error: error), animated: true, completion: nil)
                }
            }
            
            // Update the subtitle
            cell.updateSubtitle(data.packCount, totalItems: data.quantity)
        }
        
        cell.showNutrition = {
            // Create the alert controller
            let alertController = UIAlertController(title: "'\(data.title)' Nutrition Information", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.message = data.nutritionInfo!.renderText()
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(
                alertController,
                animated: true,
                completion: nil
            )
        }
        
        cell.addToBag = {
            // Add to bag
            print("add to bag")
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // Load more, if needed
        if indexPath.item >= contentData.count - preloadOffset && !reachedEnd {
            loadItems()
        }
    }
    
    // MARK: UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / round(view.bounds.width / 300) - 1, height: 208)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ManualItemViewController {
            vc.callback = {
                // Clear out the data
                self.contentData = []
                
                // Load more data
                self.loadItems()
                
                // Reload the data
                self.collectionView?.reloadData()
            }
        }
    }

}
