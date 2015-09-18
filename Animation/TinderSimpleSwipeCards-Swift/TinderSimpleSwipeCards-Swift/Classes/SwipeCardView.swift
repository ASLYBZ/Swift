//
//  DraggableView.swift
//  TinderSimpleSwipeCards-Swift
//
//  Created by iosdev on 15/9/16.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

struct Measure {
    static let ActionMargin: CGFloat        = 120       // distance from center where the action applies. Higher = swipe further in order for the action to be called
    static let ScaleStrength: CGFloat       = 4         // how quickly the card shrinks. Higher = slower shrinking
    static let ScaleMax: CGFloat            = 0.93      // upper bar for how much the card shrinks. Higher = shrinks less
    static let RotationMax: CGFloat         = 1.0       // the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    static let RotationStrength: CGFloat    = 320       // strength of rotation. Higher = weaker rotation
    static let RotationAngle: CGFloat       = CGFloat(M_PI / 8)  // Higher = stronger rotation angle
}

protocol SwipeCardViewDelegate: NSObjectProtocol {
    
    func cardSwipeLeft(card: UIView)
    func cardSwipeRight(card: UIView)
}

class SwipeCardView: UIView {

    weak var delegate: SwipeCardViewDelegate?

    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPoint: CGPoint
    var overlayView: OverlayView
    var information: UILabel        // a placeholder for any card-specific information
    
    private var xFromCenter: CGFloat = 0
    private var yFromCenter: CGFloat = 0
    
    override init(frame: CGRect) {
        
        information = UILabel(frame: CGRect(x: 0, y: 50, width: frame.size.width, height: 100))
        information.text = "No info given"
        information.textAlignment = .Center
        information.textColor = UIColor.blackColor()
    
        overlayView = OverlayView(frame: CGRect(x: frame.size.width / 2 - 100, y: 0, width: 100, height: 100))
        overlayView.alpha = 0
    
        originalPoint = CGPointZero
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beginDragged:")
    
        addGestureRecognizer(panGestureRecognizer!)
        addSubview(information)
        addSubview(overlayView)
    
        __setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func rightClickAction() {
        
        let finishPoint: CGPoint = CGPoint(x: 600, y: center.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        
        delegate?.cardSwipeRight(self)
    }
    
    func leftClickAction() {
        
        let finishPoint: CGPoint = CGPoint(x: -600, y: center.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(-1)
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        
        delegate?.cardSwipeLeft(self)
    }
    
    /*
    * called when you move your finger across the screen.
    *
    * called many times a second
    */
    @objc private func beginDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        // this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
        xFromCenter = gestureRecognizer.translationInView(self).x   // positive for right swipe, negative for left
        yFromCenter = gestureRecognizer.translationInView(self).y   // positive for up, negative for down
        
        // checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
        switch gestureRecognizer.state {
        case .Began:                            // just started swiping
            self.originalPoint = self.center
            
        case .Changed:                          // in the middle of a swipe
            // dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            let rotationStrength: CGFloat = min(xFromCenter / Measure.RotationStrength, Measure.RotationMax)
            
            // degree change in radians
            let rotationAngle: CGFloat = Measure.RotationAngle * rotationStrength
            
            // amount the height changes when you move the card up to a certain point
            let scale: CGFloat = max(1 - fabs(rotationStrength) / Measure.ScaleStrength, Measure.ScaleMax)
            
            // move the object's center by center + gesture coordinate
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            
            // rotate by certain amount
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            
            // scale by certain amount
            let scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            
            // apply transformations
            self.transform = scaleTransform
            __updateOverlay(xFromCenter)
            
        case .Ended:
            __afterSwipeAction()
            
        case .Possible, .Cancelled, .Failed:
            break
        }
    }
    
    // MARK: Private Methods
    private func __setupView() {
        
        layer.cornerRadius = 4
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    /*
     * checks to see if you are moving right or left and applies the correct overlay image
     */
    private func __updateOverlay(distance: CGFloat) {
        
        overlayView.mode = distance > 0 ? .Right : .Left
        
        overlayView.alpha = min(fabs(distance) / 100, 0.4)
    }
    
    private func __afterSwipeAction() {
        if xFromCenter > Measure.ActionMargin {
            __rightAction()
        } else if xFromCenter < -Measure.ActionMargin {
            __leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    /*
     * called when a swipe exceeds the ACTION_MARGIN to the right
     */
    private func __rightAction() {
        
        let finishPoint: CGPoint = CGPoint(x: 500, y: 2 * yFromCenter + self.originalPoint.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        
        delegate?.cardSwipeRight(self)
    }
    
    /*
     * called when a swip exceeds the ACTION_MARGIN to the left
     */
    private func __leftAction() {
        
        let finishPoint: CGPoint = CGPoint(x: -500, y: 2 * yFromCenter + self.originalPoint.y)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        
        delegate?.cardSwipeLeft(self)
    }
}
