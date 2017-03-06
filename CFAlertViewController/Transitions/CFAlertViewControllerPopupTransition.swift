//
//  CFAlertViewControllerPopupTransition.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/20/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc(CFAlertViewControllerPopupTransition)
public class CFAlertViewControllerPopupTransition: NSObject {

    // MARK: - Declarations
    @objc public enum CFAlertPopupTransitionType : Int {
        case present = 0
        case dismiss
    }
    
    
    // MARK: - Variables
    // MARK: Public
    public var transitionType = CFAlertPopupTransitionType(rawValue: 0)
    
    
    // MARK: - Initialisation Methods
    public override init() {
        super.init()
        
        // Default Transition Type
        transitionType = CFAlertPopupTransitionType(rawValue: 0)
    }
}


// MARK: - UIViewControllerAnimatedTransitioning
extension CFAlertViewControllerPopupTransition: UIViewControllerAnimatedTransitioning   {
    
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
                
                alertViewController.containerView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                alertViewController.view?.frame = containerView.frame
                alertViewController.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                alertViewController.view?.translatesAutoresizingMaskIntoConstraints = true
                containerView.addSubview(alertViewController.view)
                alertViewController.view?.layoutIfNeeded()
                alertViewController.backgroundView?.alpha = 0.0
                
                // Remove Blur Effect
                alertViewController.visualEffectView?.effect = nil
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    // Animate height changes
                    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 16.0, options: [.curveEaseIn, .allowUserInteraction], animations: {() -> Void in
                        alertViewController.containerView?.transform = CGAffineTransform.identity
                        alertViewController.backgroundView?.alpha = 1.0
                    }, completion: {(_ finished: Bool) -> Void in
                        
                        // Call Did System Methods
                        toViewController?.endAppearanceTransition()
                        fromViewController?.endAppearanceTransition()
                        
                        // Declare Animation Finished
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                    
                    // Animate Blur Effect
                    UIView.animate(withDuration: duration, animations: {
                        
                        // Add Blur Effect
                        alertViewController.visualEffectView?.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
                    })
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
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {() -> Void in
                alertViewController?.containerView?.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                alertViewController?.backgroundView?.alpha = 0.0
                
                // Remove Blur Effect
                alertViewController?.visualEffectView?.effect = nil
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
