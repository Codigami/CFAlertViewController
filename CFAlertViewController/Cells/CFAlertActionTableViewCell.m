//
//  CFAlertActionTableViewCell.m
//  CFAlertViewController
//
//  Created by Shardul Patel on 07/06/16.
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


#import "CFAlertActionTableViewCell.h"
#import "CFPushButton.h"



#define CF_DEFAULT_ACTION_COLOR     [UIColor colorWithRed:41.0/255.0 green:198.0/255.0 blue:77.0/255.0 alpha:1.0]
#define CF_CANCEL_ACTION_COLOR      [UIColor colorWithRed:103.0/255.0 green:104.0/255.0 blue:217.0/255.0 alpha:1.0]
#define CF_DESTRUCTIVE_ACTION_COLOR [UIColor colorWithRed:255.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0]



@interface CFAlertActionTableViewCell ()

@property (nonatomic, strong) IBOutlet CFPushButton *actionButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionButtonLeadingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionButtonCenterXConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionButtonTrailingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionButtonBottomConstraint;

@end



@implementation CFAlertActionTableViewCell

#pragma mark - Synthesized Objects


#pragma mark - Initialisation Methods

+ (NSString *) identifier   {
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Get Current Class Name
        NSString *currentClassName = NSStringFromClass([self class]);
        
        // Get Current Bundle
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        // Initialization code
        NSArray *arrayOfViews = [bundle loadNibNamed:currentClassName owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[CFAlertActionTableViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        // Initialization code
        [self basicInitialisation];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self basicInitialisation];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Basic Initialisation
    [self basicInitialisation];
}

- (void)basicInitialisation {
    
    // Set Action Button Properties
    self.actionButton.layer.cornerRadius = 6.0f;
    self.actionButton.pushTransformScaleFactor = 0.9;
}

#pragma mark - Layout Method

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

#pragma mark - Getter Methods


#pragma mark Setter Methods

- (void) setActionButtonTopMargin:(CGFloat)actionButtonTopMargin    {
    _actionButtonTopMargin = actionButtonTopMargin;
    
    // Update Constraint
    self.actionButtonTopConstraint.constant = self.actionButtonTopMargin - 8.0;
    [self layoutIfNeeded];
}

- (void) setActionButtonBottomMargin:(CGFloat)actionButtonBottomMargin    {
    _actionButtonBottomMargin = actionButtonBottomMargin;
    
    // Update Constraint
    self.actionButtonBottomConstraint.constant = self.actionButtonBottomMargin - 8.0;
    [self layoutIfNeeded];
}

- (void) setAction:(CFAlertAction *)action  {
    _action = action;
    
    // Set Action Style
    UIColor *actionColor = self.action.color;
    switch (self.action.style) {
            
        case CFAlertActionStyleCancel:  {
            if (!actionColor) {
                actionColor = CF_CANCEL_ACTION_COLOR;
            }
            self.actionButton.backgroundColor = [UIColor clearColor];
            [self.actionButton setTitleColor:actionColor forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = actionColor.CGColor;
            self.actionButton.layer.borderWidth = 1.0;
            break;
        }
            
        case CFAlertActionStyleDestructive: {
            if (!actionColor) {
                actionColor = CF_DESTRUCTIVE_ACTION_COLOR;
            }
            self.actionButton.backgroundColor = actionColor;
            [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = nil;
            self.actionButton.layer.borderWidth = 0.0;
            break;
        }
            
        default:    {
            if (!actionColor) {
                actionColor = CF_DEFAULT_ACTION_COLOR;
            }
            self.actionButton.backgroundColor = actionColor;
            [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = nil;
            self.actionButton.layer.borderWidth = 0.0;
            break;
        }
    }
    
    // Set Alignment
    switch (self.action.alignment) {
            
        case CFAlertActionAlignmentRight:   {
            
            // Right Align
            self.actionButtonLeadingConstraint.priority = 749.0;
            self.actionButtonCenterXConstraint.active = NO;
            self.actionButtonTrailingConstraint.priority = 751.0;
            
            // Set Content Edge Inset
            self.actionButton.contentEdgeInsets = UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0);
            break;
        }
            
        case CFAlertActionAlignmentLeft:    {
           
            // Left Align
            self.actionButtonLeadingConstraint.priority = 751.0;
            self.actionButtonCenterXConstraint.active = NO;
            self.actionButtonTrailingConstraint.priority = 749.0;
            
            // Set Content Edge Inset
            self.actionButton.contentEdgeInsets = UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0);
            break;
        }
            
        case CFAlertActionAlignmentCenter:  {
            
            // Center Align
            self.actionButtonLeadingConstraint.priority = 750.0;
            self.actionButtonCenterXConstraint.active = YES;
            self.actionButtonTrailingConstraint.priority = 750.0;
            
            // Set Content Edge Inset
            self.actionButton.contentEdgeInsets = UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0);
            break;
        }
            
        default:    {
            
            // Justified Align
            self.actionButtonLeadingConstraint.priority = 751.0;
            self.actionButtonCenterXConstraint.active = NO;
            self.actionButtonTrailingConstraint.priority = 751.0;
            
            // Set Content Edge Inset
            self.actionButton.contentEdgeInsets = UIEdgeInsetsMake(15.0, 20.0, 15.0, 20.0);
            break;
        }
    }
    
    // Set Title
    [self.actionButton setTitle:self.action.title forState:UIControlStateNormal];
}

#pragma mark - Helper Methods


#pragma mark - Button Click Events

- (IBAction) actionButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(alertActionCell:didClickAction:)]) {
        [self.delegate alertActionCell:self didClickAction:self.action];
    }
}

@end
