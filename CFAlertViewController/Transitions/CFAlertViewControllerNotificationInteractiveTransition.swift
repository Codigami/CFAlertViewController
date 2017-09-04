//
//  CFAlertViewControllerNotificationInteractiveTransition.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 02/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class CFAlertViewControllerNotificationInteractiveTransition: CFAlertBaseInteractiveTransition {

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
                                       transitionType: CFAlertViewControllerTransitionType)
    {
        // Call Super Methods
        super.updateUIState(transitionContext: transitionContext,
                            percentComplete: percentComplete,
                            transitionType: transitionType)
        
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
//        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        var viewController : UIViewController?
        if transitionType == .present {
            viewController = toViewController
        }
        else    {
            viewController = fromViewController
        }
        
        if let alertViewController = viewController as? CFAlertViewController {
            
            if let alertContainerView = alertViewController.containerView   {
                
                // Slide Container View
                let currentTopOffset = CFAlertBaseInteractiveTransition.valueBetween(start: -alertContainerView.frame.size.height,
                                                                                     andEnd: 0.0,
                                                                                     forProgress: currentPercentage)
                alertContainerView.frame = CGRect(x: alertContainerView.frame.origin.x,
                                                  y: currentTopOffset,
                                                  width: alertContainerView.frame.size.width,
                                                  height: alertContainerView.frame.size.height)
                
                // Fade background View
                if alertViewController.backgroundStyle == .blur    {
                    alertViewController.backgroundBlurView?.alpha = currentPercentage
                }
                alertViewController.backgroundColorView?.alpha = currentPercentage
            }
        }
    }
}

extension CFAlertViewControllerNotificationInteractiveTransition  {
    
    // MARK: Pan Gesture Handle Methods
    @objc override public func handlePan(_ recognizer: UIPanGestureRecognizer)  {
        
        // Location reference
        var location = recognizer.location(in: swipeGestureView?.window)
        if let recognizerView = recognizer.view {
            location = location.applying(recognizerView.transform.inverted())
        }
        
        // Velocity reference
        var velocity = recognizer.velocity(in: swipeGestureView?.window)
        if let recognizerView = recognizer.view {
            velocity = velocity.applying(recognizerView.transform.inverted())
        }
        
        if recognizer.state == .began {
            
            isInteracting = true
            panStartLocation = location
            modalViewController?.dismiss(animated: true, completion: nil)
        }
        else if recognizer.state == .changed {
            
            if let alertViewController = modalViewController as? CFAlertViewController,
                let alertContainerView = alertViewController.containerView,
                let panStartLocation = panStartLocation
            {
                let animationRatio = (panStartLocation.y - location.y) / alertContainerView.bounds.height
                update(animationRatio)
            }
        }
        else if recognizer.state == .ended {
            
            if velocity.y < -100.0 {
                finish()
            }
            else {
                cancel()
            }
            isInteracting = false
        }
    }
}

extension CFAlertViewControllerNotificationInteractiveTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?    {
        transitionType = .present
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?    {
        transitionType = .dismiss
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?   {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?  {
        // Return nil if we are not interacting
        if enableInteractiveTransition && isInteracting {
            transitionType = .dismiss
            return self
        }
        return nil
    }
}

extension CFAlertViewControllerNotificationInteractiveTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get context vars
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        let containerView: UIView? = transitionContext.containerView
        let fromViewController: UIViewController? = transitionContext.viewController(forKey: .from)
        let toViewController: UIViewController? = transitionContext.viewController(forKey: .to)
        
        // Call Will System Methods
        fromViewController?.beginAppearanceTransition(false, animated: true)
        toViewController?.beginAppearanceTransition(true, animated: true)
        if transitionType == .present {
            
            /** SHOW ANIMATION **/
            if let alertViewController = toViewController as? CFAlertViewController, let containerView = containerView   {
                
                alertViewController.view?.frame = containerView.frame
                alertViewController.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                alertViewController.view?.translatesAutoresizingMaskIntoConstraints = true
                containerView.addSubview(alertViewController.view)
                alertViewController.view?.layoutIfNeeded()
                
                var frame: CGRect? = alertViewController.containerView?.frame
                let containerViewHeight = (frame?.height)!
                frame?.origin.y = -containerViewHeight
                alertViewController.containerView?.frame = frame!
                
                // Background
                if alertViewController.backgroundStyle == .blur    {
                    alertViewController.backgroundBlurView?.alpha = 0.0
                }
                alertViewController.backgroundColorView?.alpha = 0.0
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                    
                    // Background
                    if alertViewController.backgroundStyle == .blur    {
                        alertViewController.backgroundBlurView?.alpha = 1.0
                    }
                    alertViewController.backgroundColorView?.alpha = 1.0
                    
                }, completion: nil)
                
                // Animate height changes
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                    
                    alertViewController.view?.layoutIfNeeded()
                    if var frame = alertViewController.containerView?.frame    {
                        frame.origin.y = 0
                        alertViewController.containerView?.frame = frame
                    }
                    
                }, completion: {(_ finished: Bool) -> Void in
                    
                    // Call Did System Methods
                    toViewController?.endAppearanceTransition()
                    fromViewController?.endAppearanceTransition()
                    
                    // Declare Animation Finished
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
            else    {
                
                // Call Did System Methods
                toViewController?.endAppearanceTransition()
                fromViewController?.endAppearanceTransition()
                
                // Declare Animation Finished
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        else if transitionType == .dismiss {
            
            /** HIDE ANIMATION **/
            let alertViewController: CFAlertViewController? = (fromViewController as? CFAlertViewController)
            
            // Animate height changes
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                
                alertViewController?.view?.layoutIfNeeded()
                var frame: CGRect? = alertViewController?.containerView?.frame
                let containerViewHeight = (frame?.height)!
                frame?.origin.y = -containerViewHeight
                alertViewController?.containerView?.frame = frame!
                
                // Background
                if alertViewController?.backgroundStyle == .blur    {
                    alertViewController?.backgroundBlurView?.alpha = 0.0
                }
                alertViewController?.backgroundColorView?.alpha = 0.0
                
            }, completion: {(_ finished: Bool) -> Void in
                
                // Call Did System Methods
                toViewController?.endAppearanceTransition()
                fromViewController?.endAppearanceTransition()
                
                // Declare Animation Finished
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

