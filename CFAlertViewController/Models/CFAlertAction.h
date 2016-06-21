//
//  CFAlertAction.h
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



#import <UIKit/UIKit.h>


@class CFAlertAction;


typedef NS_ENUM(NSInteger, CFAlertActionStyle) {
    CFAlertActionStyleDefault = 0,
    CFAlertActionStyleCancel,
    CFAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, CFAlertActionAlignment) {
    CFAlertActionAlignmentJustified = 0,
    CFAlertActionAlignmentRight,
    CFAlertActionAlignmentLeft,
    CFAlertActionAlignmentCenter
};

typedef void (^ _Nullable CFAlertActionHandlerBlock)(CFAlertAction *_Nonnull action);


@interface CFAlertAction : NSObject <NSCopying>


+ (nullable instancetype) actionWithTitle:(nonnull NSString *)title
                                    style:(CFAlertActionStyle)style
                                alignment:(CFAlertActionAlignment)alignment
                                    color:(nullable UIColor *)color
                                  handler:(nullable CFAlertActionHandlerBlock)handler;

@property (nonatomic, readonly, nonnull) NSString *title;
@property (nonatomic, readonly) CFAlertActionStyle style;
@property (nonatomic, readonly) CFAlertActionAlignment alignment;
@property (nonatomic, readonly, nullable) UIColor *color;
@property (nonatomic, readonly, copy, nullable) CFAlertActionHandlerBlock handler;

@end
