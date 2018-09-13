//
//  CFAlertActionSheetTransitionGestureRecognizer.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 05/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class CFAlertActionSheetTransitionGestureRecognizer: CFAlertBaseTransitionGestureRecognizer {

    // Override Touches Moved Method
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
        
        if ((abs(velocity.x) < abs(velocity.y)) &&
            (nowPoint.y > prevPoint.y) &&
            (scrollView.contentOffset.y <= 0))
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
