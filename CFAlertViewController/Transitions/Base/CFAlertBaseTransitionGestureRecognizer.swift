//
//  CFAlertBaseTransitionGestureRecognizer.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 04/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class CFAlertBaseTransitionGestureRecognizer: UIPanGestureRecognizer {
    
    // MARK: - Variables
    // MARK: Public
    public weak var scrollView : UIScrollView?
    
    // MARK: Private
    private var isFail : NSNumber?
    
    
    // MARK: - Override Methods
    override public func reset()    {
        super.reset()
        isFail = nil
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        
        super.touchesMoved(touches, with: event)
        
        // Validations
        guard let scrollView = scrollView else  {
            return
        }
        
        if self.state == .failed    {
            return
        }
        
        if let isFail = isFail {
            if isFail.boolValue {
                state = .failed
            }
            return
        }
        
        let velocity = self.velocity(in: view)
        let nowPoint = touches.first?.location(in: view) ?? CGPoint.zero
        let prevPoint = touches.first?.previousLocation(in: view) ?? CGPoint.zero
        
        if ((fabs(velocity.x) < fabs(velocity.y)) &&
            (nowPoint.y < prevPoint.y) &&
            (scrollView.contentOffset.y >= (scrollView.contentSize.height-scrollView.frame.size.height)))
        {
            // Apply Gesture
            isFail = NSNumber.init(value: false)
        }
        else {
            // Allow Scroll View To Scroll
            state = .failed
            isFail = NSNumber.init(value: true)
        }
    }
}



