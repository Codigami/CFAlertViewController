//
//  CFAlertViewControllerBaseTransition.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 02/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass


@objc protocol CFAlertViewControllerTransitionDelegate: class {
    @objc optional func alertViewControllerTransitionWillBegin(_ transition: CFAlertViewControllerBaseTransition)
    @objc optional func alertViewControllerTransitionWillFinish(_ transition: CFAlertViewControllerBaseTransition)
    @objc optional func alertViewControllerTransitionDidFinish(_ transition: CFAlertViewControllerBaseTransition)
    @objc optional func alertViewControllerTransitionWillCancel(_ transition: CFAlertViewControllerBaseTransition)
    @objc optional func alertViewControllerTransitionDidCancel(_ transition: CFAlertViewControllerBaseTransition)
}


class CFAlertViewControllerBaseTransition: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Declarations
    @objc public enum CFAlertViewControllerTransitionMode : Int {
        case present = 0
        case dismiss
    }
    
    
    // MARK: - Variables
    // MARK: Public
    public weak var delegate : CFAlertViewControllerTransitionDelegate?
    public weak var modalViewController : UIViewController?
    public var transitionMode : CFAlertViewControllerTransitionMode = .present
    public var transitionDuration : TimeInterval = 0.4
    public var enableInteractiveTransition : Bool  {
        didSet {
            
            // Remove Existing Gesture
            removeGestureRecognizerFromModalController()
            
            if enableInteractiveTransition && (swipeGestureView != nil) {
                
                // Add New Gesture Recognizer
                gesture = CFAlertViewControllerTransitionGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                if let gesture = gesture    {
                    gesture.delegate = self
                    gesture.cancelsTouchesInView = false
                    swipeGestureView?.addGestureRecognizer(gesture)
                }
            }
        }
    }
    public weak var swipeGestureView : UIView?  {
        didSet  {
            
            // Reload "enableInteractiveTransition" Property
            let enableInteractiveTransition = self.enableInteractiveTransition
            self.enableInteractiveTransition = enableInteractiveTransition
        }
    }
    public weak var contentScrollView: UIScrollView? {
        set {
            gesture?.scrollView = newValue
        }
        get {
            return gesture?.scrollView
        }
    }
    public private(set) var isInteracting : Bool = false
    public var gestureRecognizerToFailPan : UIGestureRecognizer?
    public var transitionContext : UIViewControllerContextTransitioning?
    
    // MARK: Private
    private var gesture : CFAlertViewControllerTransitionGestureRecognizer?
    private var panStartLocation : CGPoint?
    
    
    // MARK: - Initialisation Methods
    public init(modalViewController: UIViewController,
                swipeGestureView: UIView?,
                contentScrollView: UIScrollView?)
    {
        // By Default Interactive Transition Is Turned Off
        enableInteractiveTransition = true
        
        super.init()
        
        defer {
            // Set Default Values
            self.modalViewController = modalViewController
            self.swipeGestureView = swipeGestureView
            gesture?.scrollView = contentScrollView
        }
    }
    
    
    // MARK: - Helper Methods
    private func removeGestureRecognizerFromModalController() {
        if let gesture = gesture,
            let gestureRecognizers = swipeGestureView?.gestureRecognizers,
            gestureRecognizers.contains(gesture)
        {
            swipeGestureView?.removeGestureRecognizer(gesture)
            self.gesture = nil
        }
    }
    
    class public func valueBetween(start: CGFloat, andEnd end: CGFloat, forProgress currentProgress: CGFloat) -> CGFloat  {
        
        // Validation
        var progress = currentProgress
        if progress < 0.0 {
            progress = 0.0
        }
        else if progress > 1.0  {
            progress = 1.0
        }
        
        // Equation
        return start+((end-start)*progress)
    }
    
    
    // MARK: - Override Methods
    public func updateUIState(transitionContext: UIViewControllerContextTransitioning,
                              percentComplete: CGFloat,
                              transitionMode: CFAlertViewControllerTransitionMode)
    {
        // Override this method in child class to get desired output
    }
    
    
    // MARK: - Memory Management
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CFAlertViewControllerBaseTransition: UIGestureRecognizerDelegate  {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let gestureRecognizerToFailPan = gestureRecognizerToFailPan,
            gestureRecognizerToFailPan == otherGestureRecognizer
        {
            return true
        }
        return false
    }
    
    // MARK: Pan Gesture Handle Methods
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer)  {
        
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
            
            if let modalControllerView = modalViewController?.view, let panStartLocation = panStartLocation    {
                let animationRatio = (location.y - panStartLocation.y) / modalControllerView.bounds.height
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


// MARK: - UIPercentDrivenInteractiveTransition
extension CFAlertViewControllerBaseTransition {
    
    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // Update Transitioning Context
        self.transitionContext = transitionContext
        
        // Call Transition Will Begin Delegate
        delegate?.alertViewControllerTransitionWillBegin?(self)
    }
    
    public override func update(_ percentComplete: CGFloat) {
        
        // Update UI
        if let transitionContext = transitionContext {
            updateUIState(transitionContext: transitionContext,
                          percentComplete: 1.0-percentComplete,
                          transitionMode: transitionMode)
        }
    }
    
    public override func finish() {
        
        // Validation
        guard let transitionContext = transitionContext else    {
            return
        }
        
        // Grab the from and to view controllers from the context
//        let duration = transitionDuration(using: transitionContext)
//        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        // Call Transition Will Finish Delegate
        delegate?.alertViewControllerTransitionWillFinish?(self)
        
        // Call Will System Methods
        fromViewController?.beginAppearanceTransition(false, animated: true)
        toViewController?.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.curveEaseOut, .beginFromCurrentState],
                       animations: {
                        
                        // Update UI
                        if let transitionContext = self.transitionContext {
                            self.updateUIState(transitionContext: transitionContext,
                                          percentComplete: 0.0,
                                          transitionMode: self.transitionMode)
                        }
                        
        }) { (finished) in
            
            // Call Did System Methods
            toViewController?.endAppearanceTransition()
            fromViewController?.endAppearanceTransition()
            
            // Call Transition Did Finish Delegate
            self.delegate?.alertViewControllerTransitionDidFinish?(self)
            
            // Complete Transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    public override func cancel() {
        
        // Validation
        guard let transitionContext = transitionContext else    {
            return
        }
        
        // Cancel Interactive Transition
        transitionContext.cancelInteractiveTransition()
        
        // Grab the from and to view controllers from the context
//        let duration = transitionDuration(using: transitionContext)
//        let containerView = transitionContext.containerView
//        let fromViewController = transitionContext.viewController(forKey: .from)
//        let toViewController = transitionContext.viewController(forKey: .to)
        
        // Call Will Cancel Delegate
        delegate?.alertViewControllerTransitionWillCancel?(self)
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.curveEaseOut, .beginFromCurrentState],
                       animations: {
                        
                        // Update UI
                        if let transitionContext = self.transitionContext {
                            self.updateUIState(transitionContext: transitionContext,
                                               percentComplete: 1.0,
                                               transitionMode: self.transitionMode)
                        }
                        
        }) { (finished) in
            
            // Call Transition Did Cancel Delegate
            self.delegate?.alertViewControllerTransitionDidCancel?(self)
            
            // Complete Transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}



// MARK: - UIViewControllerTransitioningDelegate
extension CFAlertViewControllerBaseTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?    {
        transitionMode = .present
        return self;
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?    {
        transitionMode = .dismiss
        return self;
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?   {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?  {
        // Return nil if we are not interacting
        if enableInteractiveTransition && isInteracting {
            transitionMode = .dismiss
            return self
        }
        return nil
    }
}


// MARK: - UIViewControllerAnimatedTransitioning
extension CFAlertViewControllerBaseTransition: UIViewControllerAnimatedTransitioning {
    
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
        if self.transitionMode == .present {
            
            /** SHOW ANIMATION **/
            if let alertViewController = toViewController as? CFAlertViewController, let containerView = containerView   {
                
                alertViewController.view?.frame = containerView.frame
                alertViewController.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                alertViewController.view?.translatesAutoresizingMaskIntoConstraints = true
                containerView.addSubview(alertViewController.view)
                alertViewController.view?.layoutIfNeeded()
                
                var frame: CGRect = alertViewController.view.frame
                frame.origin.y = containerView.frame.size.height
                alertViewController.view.frame = frame
                
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
                    frame.origin.y = 0
                    alertViewController.view.frame = frame
                    
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
        else if self.transitionMode == .dismiss {
            
            /** HIDE ANIMATION **/
            
            // Animate height changes
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {() -> Void in
                
                if let fromViewController = fromViewController  {
                    
                    fromViewController.view.layoutIfNeeded()
                    var frame: CGRect = fromViewController.view.frame
                    frame.origin.y = frame.size.height
                    fromViewController.view.frame = frame
                }
                
                if let alertViewController = fromViewController as? CFAlertViewController   {
                    
                    // Background
                    if alertViewController.backgroundStyle == .blur    {
                        alertViewController.backgroundBlurView?.alpha = 0.0
                    }
                    alertViewController.view.backgroundColor = UIColor.clear
                }
                
            }, completion: {(_ finished: Bool) -> Void in
                
                // Call Did System Methods
                toViewController?.endAppearanceTransition()
                fromViewController?.endAppearanceTransition()
                
                // Declare Animation Finished
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        // Cleanup on Animation Completion
        isInteracting = false
        transitionContext = nil
    }
}

class CFAlertViewControllerTransitionGestureRecognizer: UIPanGestureRecognizer  {
    
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

        guard let scrollView = scrollView else  {
            return;
        }

        if self.state == .failed    {
            return
        }

        let velocity = self.velocity(in: view)
        let nowPoint = touches.first?.location(in: view) ?? CGPoint.zero
        let prevPoint = touches.first?.previousLocation(in: view) ?? CGPoint.zero

        if let isFail = isFail {
            if isFail.boolValue {
                state = .failed
            }
            return;
        }

        let topVerticalOffset = -(scrollView.contentInset.top)

        if ((fabs(velocity.x) < fabs(velocity.y)) &&
            (nowPoint.y > prevPoint.y) &&
            (scrollView.contentOffset.y <= topVerticalOffset))
        {
            isFail = NSNumber.init(value: false)
        }
        else if (scrollView.contentOffset.y >= topVerticalOffset) {
            state = .failed
            isFail = NSNumber.init(value: true)
        }
        else {
            isFail = NSNumber.init(value: false)
        }
    }
}


