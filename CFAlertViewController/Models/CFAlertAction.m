//
//  CFAlertAction.m
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



#import "CFAlertAction.h"


@implementation CFAlertAction

#pragma mark - Initialisation Methods

+ (nullable instancetype) actionWithTitle:(nonnull NSString *)title
                                    style:(CFAlertActionStyle)style
                                alignment:(CFAlertActionAlignment)alignment
                                    color:(nullable UIColor *)color
                                  handler:(nullable CFAlertActionHandlerBlock)handler
{
    CFAlertAction *action = [[CFAlertAction alloc] initWithTitle:title style:style alignment:alignment color:color handler:handler];
    
    return action;
}

- (instancetype)initWithTitle:(NSString *)title
                        style:(CFAlertActionStyle)style
                    alignment:(CFAlertActionAlignment)alignment
                        color:(UIColor *)color
                      handler:(CFAlertActionHandlerBlock)handler{
    
    self = [super init];
    if (self) {
        _title = title;
        _style = style;
        _alignment = alignment;
        _color = color;
        _handler = handler;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone{
    CFAlertAction *copy = [[CFAlertAction alloc] initWithTitle:self.title
                                                         style:self.style
                                                     alignment:self.alignment
                                                         color:self.color
                                                       handler:self.handler];
    return copy;
}

@end
