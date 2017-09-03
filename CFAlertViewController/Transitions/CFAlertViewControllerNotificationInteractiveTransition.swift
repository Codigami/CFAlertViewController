//
//  CFAlertViewControllerNotificationInteractiveTransition.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 02/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class CFAlertViewControllerNotificationInteractiveTransition: CFAlertViewControllerBaseTransition {

    // MARK: - Initialisation Methods
    public override init(modalViewController: UIViewController,
                         swipeGestureView: UIView?,
                         contentScrollView: UIScrollView?)
    {
        super.init(modalViewController: modalViewController,
                   swipeGestureView: swipeGestureView,
                   contentScrollView: contentScrollView)
        
        // Enable Interactive Transition
        enableInteractiveTransition = true
    }
    
    public override func updateUIState(transitionContext: UIViewControllerContextTransitioning,
                                       percentComplete: CGFloat,
                                       transitionMode: CFAlertViewControllerTransitionMode)
    {
        // Call Super Methods
        super.updateUIState(transitionContext: transitionContext,
                            percentComplete: percentComplete,
                            transitionMode: transitionMode)
        
        // Validation
        var currentPercentage = percentComplete
        if currentPercentage < 0.0 {
            currentPercentage = 0.0
        }
        else if currentPercentage > 1.0  {
            currentPercentage = 1.0
        }
        
        // Grab the from and to view controllers from the context
//        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        // Slide View
        let topMargin : CGFloat = 0.0
        let currentTopOffset = CFAlertViewControllerBaseTransition.valueBetween(start: containerView.frame.size.height,
                                                                                andEnd: topMargin,
                                                                                forProgress: currentPercentage)
        if transitionMode == .present {
            toViewController?.view.frame = CGRect(x: 0.0,
                                                  y: currentTopOffset,
                                                  width: containerView.frame.size.width,
                                                  height: containerView.frame.size.height-topMargin)
        }
        else    {
            fromViewController?.view.frame = CGRect(x: 0.0,
                                                    y: currentTopOffset,
                                                    width: containerView.frame.size.width,
                                                    height: containerView.frame.size.height-topMargin);
        }
    }
}

