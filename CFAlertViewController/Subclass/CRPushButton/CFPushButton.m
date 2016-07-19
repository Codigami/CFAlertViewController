//
//  CFPushButton.m
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


#import "CFPushButton.h"



@interface CFPushButton ()

@property (nonatomic, strong) UIColor *normalStateBackgroundColor;

@end



@implementation CFPushButton

#pragma mark - Initialisation Methods

- (instancetype) initWithCoder:(NSCoder *)coder  {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self basicInitialisation];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame   {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self basicInitialisation];
    }
    return self;
}

- (void) basicInitialisation  {
    
    // Default Transform Scale Factor Property
    self.pushTransformScaleFactor = 0.8;
    
    // Set Default Original Transform
    self.originalTransform = CGAffineTransformIdentity;
    
    // Set Default Animation Properties
    self.touchDownDuration = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DURATION;
    self.touchDownDelay = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DELAY;
    self.touchDownDamping = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_DAMPING;
    self.touchDownVelocity = CF_PUSH_BUTTON_DEFAULT_TOUCH_DOWN_VELOCITY;
    
    self.touchUpDuration = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DURATION;
    self.touchUpDelay = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DELAY;
    self.touchUpDamping = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_DAMPING;
    self.touchUpVelocity = CF_PUSH_BUTTON_DEFAULT_TOUCH_UP_VELOCITY;
}

#pragma mark - Setter Methods

- (void) setBackgroundColor:(UIColor *)backgroundColor  {
    [super setBackgroundColor:backgroundColor];
    
    // Store Normal State Background Color
    self.normalStateBackgroundColor = backgroundColor;
}

- (void) setOriginalTransform:(CGAffineTransform)originalTransform  {
    _originalTransform = originalTransform;
    
    // Update Button Transform
    self.transform = self.originalTransform;
}

#pragma mark - Touch Events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event    {
    [super touchesBegan:touches withEvent:event];
    [self pushButton:YES animated:YES completion:nil];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event    {
    [super touchesEnded:touches withEvent:event];
    [self pushButton:NO animated:YES completion:nil];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event    {
    [super touchesCancelled:touches withEvent:event];
    [self pushButton:NO animated:YES completion:nil];
}

#pragma mark - Animation Method

- (void) pushButton:(BOOL)pushButton
           animated:(BOOL)shouldAnimate
         completion:(void (^)())completed
{
    // Call Touch Events
    if (pushButton) {
        
        // Call Touch Down Handler
        if (self.touchDownHandler) {
            self.touchDownHandler(self);
        }
    }
    else    {
        
        // Call Touch Up Handler
        if (self.touchUpHandler) {
            self.touchUpHandler(self);
        }
    }
    
    void (^animate)(void) = ^{
        
        if (pushButton) {
            
            // Set Transform
            self.transform = CGAffineTransformScale(self.originalTransform, self.pushTransformScaleFactor, self.pushTransformScaleFactor);
            
            // Update Background Color
            if (self.highlightStateBackgroundColor) {
                [super setBackgroundColor:self.highlightStateBackgroundColor];
            }
        }
        else    {
            
            // Set Transform
            self.transform = self.originalTransform;
            
            // Set Background Color
            [super setBackgroundColor:self.normalStateBackgroundColor];
        }
        
        // Layout
        [self setNeedsLayout];
        [self layoutIfNeeded];
    };
    
    if (shouldAnimate) {
        
        // Configure Animation Properties
        CGFloat duration;
        CGFloat delay;
        CGFloat damping;
        CGFloat velocity;
        
        if (pushButton) {
            duration = self.touchDownDuration;
            delay = self.touchDownDelay;
            damping = self.touchDownDamping;
            velocity = self.touchDownVelocity;
        }
        else    {
            duration = self.touchUpDuration;
            delay = self.touchUpDelay;
            damping = self.touchUpDamping;
            velocity = self.touchUpVelocity;
        }
        
        // Animate
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Animate
            [UIView animateWithDuration:duration
                                  delay:delay
                 usingSpringWithDamping:damping
                  initialSpringVelocity:velocity
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 animate();
                             } completion:^(BOOL finished) {
                                 if (finished && completed) {
                                     completed();
                                 }
                             }];
        });
    }
    else    {
        
        animate();
        if (completed) {
            completed();
        }
    }
}

@end
