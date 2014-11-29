//
//  VideBounceButtonView.swift
//  VideBounceButtonViewExample
//
//  Created by Oreki Houtarou on 11/29/14.
//  Copyright (c) 2014 Videgame. All rights reserved.
//

import UIKit

class VideBounceButtonView: UIView {
    var exclusiveButtons: [UIButton]?
    var currentSelectedButton: UIButton?
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitTestView = super.hitTest(point, withEvent: event)
        if (hitTestView is UIButton) && (exclusiveButtons == nil || !contains(exclusiveButtons!, hitTestView as UIButton)) {
            return self
        }
        return hitTestView
    }
    
    // MARK: Touch-Event Handling Methods
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        if touch.view != self {
            super.touchesBegan(touches, withEvent: event)
            return
        }
        let button = buttonForTouch(touch)
        if button != nil {
            currentSelectedButton = button
            bounceInButton(button!)
        } else {
            currentSelectedButton = nil
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        if touch.view != self {
            super.touchesMoved(touches, withEvent: event)
            return
        }
        let button = buttonForTouch(touch)
        if button != nil && button != currentSelectedButton {
            if currentSelectedButton != nil {
                bounceOutButton(currentSelectedButton!)
            }
            currentSelectedButton = button
            bounceInButton(button!)
            return
        }
        
        if button == nil && currentSelectedButton != nil {
            bounceOutButton(currentSelectedButton!)
            currentSelectedButton = nil
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        if touch.view != self {
            super.touchesEnded(touches, withEvent: event)
            return
        }
        let button = buttonForTouch(touch)
        if button != nil {
            bounceOutButton(button!)
            button!.sendActionsForControlEvents(.TouchUpInside)
        } else {
            startBlackAtPoint(touch.locationInView(self))
        }
        if currentSelectedButton != nil {
            bounceOutButton(currentSelectedButton!)
            currentSelectedButton = nil
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        startBlackAtPoint((touches.anyObject() as UITouch).locationInView(self))
        if currentSelectedButton != nil {
            bounceOutButton(currentSelectedButton!)
            currentSelectedButton = nil
        }
    }
    
    // MARK: Private Methods
    private func buttonForTouch(touch: UITouch) -> UIButton? {
        let location = touch.locationInView(self)
        
        for subView in self.subviews.reverse() {
            if let button = subView as? UIButton {
                if (exclusiveButtons == nil || !contains(exclusiveButtons!, button)) && button.frame.contains(location) {
                    return button;
                }
            }
        }
        return nil
    }
    
    private func bounceInButton(button: UIButton) {
        if button.transform.a < CGAffineTransformIdentity.a && button.transform.d < CGAffineTransformIdentity.d {
            return
        }
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            button.transform = CGAffineTransformMakeScale(0.85, 0.85)
            }) { (finished) -> Void in
                if finished {
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        button.transform = CGAffineTransformMakeScale(0.90, 0.90)
                        }, completion: nil)
                }
        }
    }
    
    private func bounceOutButton(button: UIButton) {
        if button.transform.a >= CGAffineTransformIdentity.a && button.transform.d >= CGAffineTransformIdentity.d {
            return
        }
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            button.transform = CGAffineTransformMakeScale(1.10, 1.10)
            }) { (finished) -> Void in
                if finished {
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        button.transform = CGAffineTransformIdentity
                        }, completion: nil)
                }
                
        }
    }
    
    private func startBlackAtPoint(point: CGPoint) {
        let sideLength: CGFloat = 10
        let snapView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: sideLength, height: sideLength)))
        snapView.center = point
        snapView.layer.cornerRadius = sideLength / 2.0
        snapView.backgroundColor = UIColor.blackColor()
        self.insertSubview(snapView, atIndex: 0)
        let maxScale = max(self.frame.width / snapView.frame.width * 2.0, self.frame.height / snapView.frame.height * 2.0)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            snapView.transform = CGAffineTransformMakeScale(maxScale, maxScale)
            }) { (finished) -> Void in
                if finished {
                    self.backgroundColor = UIColor.blackColor()
                    snapView.removeFromSuperview()
                }
        }
    }
}
