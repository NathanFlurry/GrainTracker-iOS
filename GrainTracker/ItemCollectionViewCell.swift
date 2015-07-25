//
//  ItemCollectionViewCell.swift
//  GrainTracker
//
//  Created by Nathan Flurry on 7/24/15.
//  Copyright © 2015 AzBrainFood. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    // Views
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var sliderView: UIView!
    @IBOutlet var sliderCountLabel: UILabel!
    
    // State
    private var previousPosition: CGPoint?
    
    // Callbacks
    var deltaChangeCallback: (change: Int) -> Void = { change in }
    var commitChanges: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style the views
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        // Add gesture recognizers
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("sliderTapped:"))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("sliderPanned:"))
        sliderView.addGestureRecognizer(tapGestureRecognizer)
        sliderView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // UI events
    func sliderTapped(tap: UITapGestureRecognizer) {
        // Get the position of the touch
        let locationInView = tap.locationInView(sliderView)
        
        // Test if to increment more or less
        if locationInView.x > sliderView.frame.midX {
            deltaChangeCallback(change: 1)
        } else {
            deltaChangeCallback(change: -1)
        }
    }
    
    func sliderPanned(pan: UIPanGestureRecognizer) {
        // Get the position of the touch
        let locationInView = pan.locationInView(sliderView)
        
        switch pan.state {
        case .Began:
            // Set the initial position
            previousPosition = locationInView
        case .Changed:
            // Get the delta
            if let prevPos = previousPosition {
                let delta = locationInView.x - prevPos.x
                deltaChangeCallback(change: Int(delta))
            }
            
            // Update the position
            previousPosition = locationInView
        case .Ended, .Cancelled:
            // Clear the previous position
            previousPosition = nil
            
            // Commit the change to the value
            commitChanges()
        default:
            break
        }
    }
}
