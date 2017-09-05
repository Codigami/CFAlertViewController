//
//  CFAlertActionSheetInteractiveTransition.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/20/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class CFAlertActionSheetInteractiveTransition: CFAlertBaseInteractiveTransition {
    
    // MARK: - Initialisation Methods
    public override init(modalViewController: UIViewController,
                         swipeGestureView: UIView?,
                         contentScrollView: UIScrollView?)
    {
        super.init(modalViewController: modalViewController,
                   swipeGestureView: swipeGestureView,
                   contentScrollView: contentScrollView)
    }
    
    
    // MARK: - Override Methods
    public override func classForGestureRecognizer() -> CFAlertBaseTransitionGestureRecognizer.Type {
        return CFAlertActionSheetTransitionGestureRecognizer.self
    }
    
    public override func updateUIState(transitionContext: UIViewControllerContextTransitioning,
                                       percentComplete: CGFloat,
                                       transitionType: CFAlertTransitionType)
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
                let startY = alertViewController.view.frame.size.height - alertContainerView.frame.size.height - 10
                let endY = alertViewController.view.frame.size.height
                let currentTopOffset = CFAlertBaseInteractiveTransition.valueBetween(start: startY,
                                                                                     andEnd: endY,
                                                                                     forProgress: (1.0-currentPercentage))
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

extension CFAlertActionSheetInteractiveTransition  {
    
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
                let animationRatio = (location.y - panStartLocation.y) / alertContainerView.bounds.height
                update(animationRatio)
            }
        }
        else if recognizer.state == .ended {
            
            if velocity.y > 100.0 {
                finish()
            }
            else {
                cancel()
            }
            isInteracting = false
        }
    }
}


// MARK: - UIViewControllerAnimatedTransitioning
extension CFAlertActionSheetInteractiveTransition   {
    
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get context vars
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        let containerView: UIView? = transitionContext.containerView
        let fromViewController: UIViewController? = transitionContext.viewController(forKey: .from)
        let toViewController: UIViewController? = transitionContext.viewController(forKey: .to)
        
        // Call Will System Methods
        fromViewController?.beginAppearanceTransition(false, animated: true)
        toViewController?.beginAppearanceTransition(true, animated: true)
        if self.transitionType == .present {
            
            /** SHOW ANIMATION **/
            if let alertViewController = toViewController as? CFAlertViewController, let containerView = containerView   {
                
                alertViewController.view?.frame = containerView.frame
                alertViewController.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                alertViewController.view?.translatesAutoresizingMaskIntoConstraints = true
                containerView.addSubview(alertViewController.view)
                alertViewController.view?.layoutIfNeeded()
                
                var frame: CGRect? = alertViewController.containerView?.frame
                frame?.origin.y = containerView.frame.size.height
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
                        frame.origin.y = frame.origin.y - frame.size.height - 10
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
        else if self.transitionType == .dismiss {
            
            /** HIDE ANIMATION **/
            let alertViewController: CFAlertViewController? = (fromViewController as? CFAlertViewController)
            
            // Animate height changes
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                
                alertViewController?.view?.layoutIfNeeded()
                var frame: CGRect? = alertViewController?.containerView?.frame
                frame?.origin.y = (containerView?.frame.size.height)!
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
