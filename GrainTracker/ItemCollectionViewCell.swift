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
    @IBOutlet var nutritionButton: UIButton!
    @IBOutlet var leftSliderButton: UIImageView!
    @IBOutlet var rightSliderButton: UIImageView!
    
    // State
    private var previousPosition: CGPoint?
    
    // Style
    private let idleColor = UIColor.whiteColor()
    private let activeColor = ThemeColor
    
    // Callbacks
    var deltaChangeCallback: (change: Int) -> Void = { change in }
    var commitChanges: () -> Void = {}
    var showNutrition: () -> Void = {}
    var addToBag: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style the views
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        // Set slider state
        setSliderState(.None)
        
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
            // Callback
            deltaChangeCallback(change: 1)
            
            // Slider animation
            setSliderState(.Right, quickAnimation: true)
        } else {
            // Callback
            deltaChangeCallback(change: -1)
            
            // Slider animation
            setSliderState(.Left, quickAnimation: true)
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
                // Callback
                let delta = locationInView.x - prevPos.x
                deltaChangeCallback(change: Int(delta))
                
                // Update slider look
                if delta < 0 {
                    setSliderState(.Left)
                } else {
                    setSliderState(.Right)
                }
            }
            
            // Update the position
            previousPosition = locationInView
        case .Ended, .Cancelled:
            // Clear the previous position
            previousPosition = nil
            
            // Commit the change to the value
            commitChanges()
            
            // Reset the slider state
            setSliderState(.None)
        default:
            break
        }
    }
    
    private enum SliderState {
        case None, Right, Left
    }
    
    private func setSliderState(state: SliderState, quickAnimation: Bool = false) {
        UIView.animateWithDuration(
            quickAnimation ? 0.0 : 0.4,
            animations: {
                switch state {
                case .None:
                    self.leftSliderButton.tintColor = self.idleColor
                    self.rightSliderButton.tintColor = self.idleColor
                    self.sliderCountLabel.textColor = self.idleColor
                case .Right:
                    self.leftSliderButton.tintColor = self.idleColor
                    self.rightSliderButton.tintColor = self.activeColor
                    self.sliderCountLabel.textColor = self.activeColor
                case .Left:
                    self.leftSliderButton.tintColor = self.activeColor
                    self.rightSliderButton.tintColor = self.idleColor
                    self.sliderCountLabel.textColor = self.activeColor
                }
            },
            completion: {
                completed in
                if quickAnimation {
                    self.setSliderState(.None)
                }
            }
        )
    }
    
    func updateSubtitle(packCount: Int, totalItems: Int) {
        detailsLabel.text = "\(packCount)-pack • \(totalItems * packCount) total"
    }
    
    @IBAction func showNutrition(sender: UIButton) {
        // Call the callback
        showNutrition()
    }
    
    @IBAction func addToBag(sender: UIButton) {
        // Call the callback
        addToBag()
    }
}
