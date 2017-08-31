//
//  CFPushButton.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/18/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


open class CFPushButton: UIButton {
    
    // MARK: - Declarations
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DURATION: CGFloat = 0.22
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DELAY: CGFloat = 0.0
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DAMPING: CGFloat = 0.6
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_VELOCITY: CGFloat = 0.0
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DURATION: CGFloat = 0.7
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DELAY: CGFloat = 0.0
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DAMPING: CGFloat = 0.65
    @objc public static let CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_VELOCITY: CGFloat = 0.0
    
    
    // MARK: - Variables
    
    // Original Transform Property
    @objc open var originalTransform = CGAffineTransform.identity {
        didSet  {
            // Update Button Transform
            transform = originalTransform
        }
    }
    
    // Set Highlight Property
    @objc open var highlightStateBackgroundColor: UIColor?
    
    // Push Transform Property
    @objc open var pushTransformScaleFactor: CGFloat = 0.8
    
    // Touch Handler Blocks
    @objc open var touchDownHandler: ((_ button: CFPushButton) -> Void)?
    @objc open var touchUpHandler: ((_ button: CFPushButton) -> Void)?
    
    // Push Transition Animation Properties
    @objc open var touchDownDuration: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DURATION
    @objc open var touchDownDelay: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DELAY
    @objc open var touchDownDamping: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DAMPING
    @objc open var touchDownVelocity: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_VELOCITY
    
    @objc open var touchUpDuration: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DURATION
    @objc open var touchUpDelay: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DELAY
    @objc open var touchUpDamping: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DAMPING
    @objc open var touchUpVelocity: CGFloat = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_VELOCITY
    
    // Add Extra Parameters
    @objc open var extraParam: Any?
    
    private var normalStateBackgroundColor: UIColor?
    @objc open override var backgroundColor: UIColor? {
        didSet  {
            // Store Normal State Background Color
            normalStateBackgroundColor = backgroundColor
        }
    }
    
    
    // MARK: - Initialization Methods
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        basicInitialisation()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        basicInitialisation()
    }
    
    open func basicInitialisation() {
        
        // Set Default Original Transform
        originalTransform = CGAffineTransform.identity
    }
    
    
    // MARK: - Touch Events
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pushButton(pushButton: true, shouldAnimate: true, completion: nil)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pushButton(pushButton: false, shouldAnimate: true, completion: nil)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        pushButton(pushButton: false, shouldAnimate: true, completion: nil)
    }
    
    
    // MARK: - Animation Method
    @objc open func pushButton(pushButton: Bool, shouldAnimate: Bool, completion: (() -> Void)?) {
        
        // Call Touch Events
        if pushButton {
            // Call Touch Down Handler
            if let touchDownHandler = touchDownHandler {
                touchDownHandler(self)
            }
        }
        else {
            // Call Touch Up Handler
            if let touchUpHandler = touchUpHandler {
                touchUpHandler(self)
            }
        }
        
        // Animation Block
        let animate: (() -> Void)? = {() -> Void in
            
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
                duration = touchDownDuration
                delay = touchDownDelay
                damping = touchDownDamping
                velocity = touchDownVelocity
            }
            else {
                duration = touchUpDuration
                delay = touchUpDelay
                damping = touchUpDamping
                velocity = touchUpVelocity
            }
            
            DispatchQueue.main.async    {
                // Animate
                UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {() -> Void in
                    animate!()
                }, completion: {(_ finished: Bool) -> Void in
                    if let completion = completion, finished {
                        completion()
                    }
                })
            }
        }
        else {
            animate!()
            
            // Call Completion Block
            if let completion = completion {
                completion()
            }
        }
    }
    
    // MARK: - Dealloc
    deinit {
        
        // Remove Touch Handlers
        touchDownHandler = nil
        touchUpHandler = nil
    }
}
