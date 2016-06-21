//
//  CFAlertViewController.h
//  CFAlertViewController
//
//  Created by Shardul Patel on 07/06/16.
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Codigami Inc
 
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
#import "CFAlertAction.h"



typedef NS_ENUM(NSInteger, CFAlertControllerStyle) {
    CFAlertControllerStyleAlert = 0,
    CFAlertControllerStyleActionSheet
};


typedef void (^ _Nullable CFAlertViewControllerDismissBlock)();


@interface CFAlertViewController : UIViewController <UIViewControllerTransitioningDelegate> {
    
}


+ (nonnull instancetype) alertControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                    textAlignment:(NSTextAlignment)textAlignment
                                   preferredStyle:(CFAlertControllerStyle)preferredStyle
                           didDismissAlertHandler:(nullable CFAlertViewControllerDismissBlock)dismiss;

+ (nonnull instancetype) alertControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                    textAlignment:(NSTextAlignment)textAlignment
                                   preferredStyle:(CFAlertControllerStyle)preferredStyle
                                       headerView:(nullable UIView *)headerView
                                       footerView:(nullable UIView *)footerView
                           didDismissAlertHandler:(nullable CFAlertViewControllerDismissBlock)dismiss;

- (void)addAction:(nonnull CFAlertAction *)action;
@property (nonatomic, readonly, nullable) NSArray<CFAlertAction *> *actions;

@property (nonatomic, readonly) NSTextAlignment textAlignment;
@property (nonatomic, readonly) CFAlertControllerStyle preferredStyle;

@property (nonatomic, strong, nullable) UIView * headerView;
@property (nonatomic, strong, nullable) UIView * footerView;

// Default is YES
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTap;

// Transition Reference Object
@property (nonatomic, weak, nullable) IBOutlet UIView * containerView;

// Dismiss Alert Controller
- (void) dismissAlertWithAnimation:(BOOL)animate completion:(void (^__nullable)(void))completion;

@end
