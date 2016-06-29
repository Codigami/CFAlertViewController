//
//  CFAlertViewControllerActionSheetTransition.m
//  CFAlertViewController
//
//  Created by Ram Suthar on 07/06/16.
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


#import "CFAlertViewControllerActionSheetTransition.h"
#import "CFAlertViewController.h"



#define kCFAlertViewControllerActionSheetTransitionDuration 0.4f;



@implementation CFAlertViewControllerActionSheetTransition

#pragma mark - Synthesized Objects

@synthesize transitionType = _transitionType;

#pragma mark - Initialisation Methods

- (id) init {
    
    self = [super init];
    if (self) {
        
        // Default Transition Type
        self.transitionType = CFAlertActionSheetTransitionTypePresent;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioning Delegates

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kCFAlertViewControllerActionSheetTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    // Get context vars
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Call Will System Methods
    [fromViewController beginAppearanceTransition:NO animated:YES];
    [toViewController beginAppearanceTransition:YES animated:YES];
    
    if (self.transitionType == CFAlertActionSheetTransitionTypePresent) {
        
        /** SHOW ANIMATION **/
        
        CFAlertViewController *alertViewController = (CFAlertViewController *)toViewController;
        
        alertViewController.view.frame = containerView.frame;
        
        alertViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        alertViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
        
        [containerView addSubview:alertViewController.view];
        [alertViewController.view layoutIfNeeded];
        
        CGRect frame = alertViewController.containerView.frame;
        frame.origin.y = containerView.frame.size.height;
        alertViewController.containerView.frame = frame;
        
        UIColor *backgroundColorRef = alertViewController.view.backgroundColor;
        alertViewController.view.backgroundColor = [UIColor clearColor];
        
        // Animate height changes
        [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [alertViewController.view layoutIfNeeded];
            
            CGRect frame = alertViewController.containerView.frame;
            frame.origin.y = frame.origin.y - frame.size.height - 10;
            alertViewController.containerView.frame = frame;
            
            alertViewController.view.backgroundColor = backgroundColorRef;
            
        } completion:^(BOOL finished) {
            
            // Call Did System Methods
            [toViewController endAppearanceTransition];
            [fromViewController endAppearanceTransition];
            
            // Declare Animation Finished
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else if (self.transitionType == CFAlertActionSheetTransitionTypeDismiss) {
        
        /** HIDE ANIMATION **/
        
        CFAlertViewController *alertViewController = (CFAlertViewController *)fromViewController;
        
        // Animate height changes
        [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [alertViewController.view layoutIfNeeded];
        
            CGRect frame = alertViewController.containerView.frame;
            frame.origin.y = containerView.frame.size.height;
            alertViewController.containerView.frame = frame;
            
            alertViewController.view.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            // Call Did System Methods
            [toViewController endAppearanceTransition];
            [fromViewController endAppearanceTransition];
            
            // Declare Animation Finished
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
