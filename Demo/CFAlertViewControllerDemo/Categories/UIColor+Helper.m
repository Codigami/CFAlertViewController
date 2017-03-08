//
//  UIColor+Helper.m
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 08/03/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *) randomColor   {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    CGFloat alpha = ((double)arc4random() / 0x100000000);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *) randomColorWithAlpha:(CGFloat)alpha   {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
