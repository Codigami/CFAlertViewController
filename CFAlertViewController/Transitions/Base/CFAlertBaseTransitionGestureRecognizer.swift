//
//  CFAlertBaseTransitionGestureRecognizer.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 04/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

open class CFAlertBaseTransitionGestureRecognizer: UIPanGestureRecognizer {
    
    // MARK: - Variables
    public weak var scrollView : UIScrollView?
    public var isFail : NSNumber?
    
    
    // MARK: - Initialisation Method
    required override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        // Default Cancel Touches In View
        cancelsTouchesInView = false
    }
    
    
    // MARK: - Override Methods
    override open func reset()    {
        super.reset()
        isFail = nil
    }
}



