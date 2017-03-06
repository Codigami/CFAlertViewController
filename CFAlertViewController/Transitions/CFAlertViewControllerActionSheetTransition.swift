//
//  CFAlertViewControllerActionSheetTransition.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/20/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc(CFAlertViewControllerActionSheetTransition)
public class CFAlertViewControllerActionSheetTransition: NSObject {
    
    // MARK: - Declarations
    @objc public enum CFAlertActionSheetTransitionType : Int {
        case present = 0
        case dismiss
    }
    
    
    // MARK: - Variables
    // MARK: Public
    public var transitionType = CFAlertActionSheetTransitionType(rawValue: 0)
    
    
    // MARK: - Initialisation Methods
    public override init() {
        super.init()
        
        // Default Transition Type
        transitionType = CFAlertActionSheetTransitionType(rawValue: 0)
    }
}


// MARK: - UIViewControllerAnimatedTransitioning
extension CFAlertViewControllerActionSheetTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
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
                let backgroundColorRef: UIColor? = alertViewController.backgroundColor
                alertViewController.backgroundColor = UIColor.clear
                if alertViewController.backgroundStyle == .blur    {
                    alertViewController.backgroundBlurView?.alpha = 0.0
                }
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                    
                    // Background
                    if alertViewController.backgroundStyle == .blur    {
                        alertViewController.backgroundBlurView?.alpha = 1.0
                    }
                    alertViewController.backgroundColor = backgroundColorRef
                    
                }, completion: nil)
                
                // Animate height changes
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                    
                    alertViewController.view?.layoutIfNeeded()
                    var frame: CGRect? = alertViewController.containerView?.frame
                    frame?.origin.y = (frame?.origin.y)! - (frame?.size.height)! - 10
                    alertViewController.containerView?.frame = frame!
                    
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
                alertViewController?.view?.backgroundColor = UIColor.clear
                
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
