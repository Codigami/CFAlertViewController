//
//  CFPushButton.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/18/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc class CFPushButton: UIButton {

    //MARK: Declarations
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DURATION: CGFloat = 0.22
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DELAY: CGFloat = 0.0
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DAMPING: CGFloat = 0.6
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_VELOCITY: CGFloat = 0.0
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DURATION: CGFloat = 0.7
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DELAY: CGFloat = 0.0
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DAMPING: CGFloat = 0.65
    let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_VELOCITY: CGFloat = 0.0
    
    
    // MARK: Variables

    // Original Transform Property
    var originalTransform = CGAffineTransform()
    
    // Push Transform Property
    var pushTransformScaleFactor: CGFloat = 0.0
    
    // Set Highlight Property
    var highlightStateBackgroundColor: UIColor?
    
    // Touch Handler Blocks
    var touchDownHandler: ((_ button: CFPushButton) -> Void)?
    var touchUpHandler: ((_ button: CFPushButton) -> Void)?
    
    // Push Transition Animation Properties
    var touchDownDuration: CGFloat = 0.0
    var touchDownDelay: CGFloat = 0.0
    var touchDownDamping: CGFloat = 0.0
    var touchDownVelocity: CGFloat = 0.0
    
    var touchUpDuration: CGFloat = 0.0
    var touchUpDelay: CGFloat = 0.0
    var touchUpDamping: CGFloat = 0.0
    var touchUpVelocity: CGFloat = 0.0
    
    // Add Extra Parameters
    var extraParam: Any?
    
    var normalStateBackgroundColor: UIColor?
    
    
    //MARK: Initialization Methods
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        basicInitialisation()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicInitialisation()
    }
    
    func basicInitialisation() {
        
        // Default Transform Scale Factor Property
        pushTransformScaleFactor = 0.8
        
        // Set Default Original Transform
        originalTransform = CGAffineTransform.identity
        
        // Set Default Animation Properties
        touchDownDuration = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DURATION
        touchDownDelay = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DELAY
        touchDownDamping = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DAMPING
        touchDownVelocity = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_VELOCITY
        touchUpDuration = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DURATION
        touchUpDelay = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DELAY
        touchUpDamping = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DAMPING
        touchUpVelocity = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_VELOCITY
    }
    
    
    //MARK: Setter Methods
    func setBackgroundColor(backgroundColor: UIColor) {
        normalStateBackgroundColor = backgroundColor
        
        // Store Normal State Background Color
        self.backgroundColor = backgroundColor
    }
    
    func setOriginalTransform(originalTransform: CGAffineTransform) {
        self.originalTransform = originalTransform
        
        // Update Button Transform
        self.transform = originalTransform
    }
    
    
    //MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pushButton(pushButton: true, shouldAnimate: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pushButton(pushButton: false, shouldAnimate: true, completion: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        pushButton(pushButton: false, shouldAnimate: true, completion: nil)
    }
    
    
    //MARK: Animation Method
    func pushButton(pushButton: Bool, shouldAnimate: Bool, completion: (() -> Void)?) {
        // Call Touch Events
        if pushButton {
            // Call Touch Down Handler
            if (self.touchDownHandler != nil) {
                self.touchDownHandler!(self)
            }
        }
        else {
            // Call Touch Up Handler
            if (self.touchUpHandler != nil) {
                self.touchUpHandler!(self)
            }
        }
        let animate: ((_: Void) -> Void)? = {() -> Void in
            if pushButton {
                // Set Transform
                self.transform = self.originalTransform.scaledBy(x: self.pushTransformScaleFactor, y: self.pushTransformScaleFactor)
                // Update Background Color
                if (self.highlightStateBackgroundColor != nil) {
                    super.backgroundColor = self.highlightStateBackgroundColor
                }
            }
            else {
                // Set Transform
                self.transform = self.originalTransform
                // Set Background Color
                super.backgroundColor = self.normalStateBackgroundColor
            }
            // Layout
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        if shouldAnimate {
            // Configure Animation Properties
            var duration: CGFloat
            var delay: CGFloat
            var damping: CGFloat
            var velocity: CGFloat
            if pushButton {
                duration = self.touchDownDuration
                delay = self.touchDownDelay
                damping = self.touchDownDamping
                velocity = self.touchDownVelocity
            }
            else {
                duration = self.touchUpDuration
                delay = self.touchUpDelay
                damping = self.touchUpDamping
                velocity = self.touchUpVelocity
            }
            // Animate
            DispatchQueue.main.async(execute: {() -> Void in
                // Animate
                UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {() -> Void in
                    animate!()
                }, completion: {(_ finished: Bool) -> Void in
                    if finished && completion != nil {
                        completion!()
                    }
                })
            })
        }
        else {
            animate!()
            if completion != nil {
                completion!()
            }
        }
    }
}
