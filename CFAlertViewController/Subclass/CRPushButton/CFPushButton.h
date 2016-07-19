//
//  CFPushButton.h
//  SampleButton
//
//  Created by Shardul Patel on 12/21/15.
//  
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Codigami Inc
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import <UIKit/UIKit.h>

#define CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DURATION  0.22
#define CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DELAY     0.0
#define CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DAMPING   0.6
#define CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_VELOCITY  0.0

#define CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DURATION    0.7
#define CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DELAY       0.0
#define CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DAMPING     0.65
#define CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_VELOCITY    0.0

@class CFPushButton;
typedef void(^CFPushButtonTouchEventHandler)(CFPushButton *button);



@interface CFPushButton : UIButton

// Set Original Transform Property
@property (nonatomic) CGAffineTransform originalTransform;

// Push Transform Property
@property (nonatomic, assign) CGFloat pushTransformScaleFactor;

// Set Highlight Property
@property (nonatomic, strong) UIColor *highlightStateBackgroundColor;

// Animation Helper Method
- (void) pushButton:(BOOL)pushButton
           animated:(BOOL)shouldAnimate
         completion:(void (^)())completed;

// Touch Handler Blocks
@property (nonatomic, copy) CFPushButtonTouchEventHandler touchDownHandler;
@property (nonatomic, copy) CFPushButtonTouchEventHandler touchUpHandler;

// Push Transition Animation Properties
@property (nonatomic, assign) CGFloat touchDownDuration;
@property (nonatomic, assign) CGFloat touchDownDelay;
@property (nonatomic, assign) CGFloat touchDownDamping;
@property (nonatomic, assign) CGFloat touchDownVelocity;

@property (nonatomic, assign) CGFloat touchUpDuration;
@property (nonatomic, assign) CGFloat touchUpDelay;
@property (nonatomic, assign) CGFloat touchUpDamping;
@property (nonatomic, assign) CGFloat touchUpVelocity;

// Add Extra Parameters
@property (nonatomic, assign) id extraParam;

@end
