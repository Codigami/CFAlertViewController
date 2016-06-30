//
//  CFAlertTitleSubtitleTableViewCell.m
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


#import "CFAlertTitleSubtitleTableViewCell.h"



@interface CFAlertTitleSubtitleTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleSubtitleVerticalSpacingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleLabelBottomConstraint;


@end



@implementation CFAlertTitleSubtitleTableViewCell

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
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[CFAlertTitleSubtitleTableViewCell class]]) {
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
    
    // Reset Text
    [self setTitle:nil andSubtitle:nil withTextAlignment:NSTextAlignmentCenter];
    
    // Set Content Leading Space
    self.contentLeadingSpace = 20.0f;
}

#pragma mark - Layout Method

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.subtitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.subtitleLabel.frame);
}

#pragma mark - Getter Methods


#pragma mark Setter Methods

- (void) setContentTopMargin:(CGFloat)contentTopMargin    {
    _contentTopMargin = contentTopMargin;
    
    // Update Constraint
    self.titleLabelTopConstraint.constant = self.contentTopMargin - 8.0;
    self.subtitleLabelTopConstraint.constant = self.titleLabelTopConstraint.constant;
    [self layoutIfNeeded];
}

- (void) setContentBottomMargin:(CGFloat)contentBottomMargin    {
    _contentBottomMargin = contentBottomMargin;
    
    // Update Constraint
    self.titleLabelBottomConstraint.constant = self.contentBottomMargin - 8.0;
    self.subtitleLabelBottomConstraint.constant = self.titleLabelBottomConstraint.constant;
    [self layoutIfNeeded];
}

- (void) setContentLeadingSpace:(CGFloat)contentLeadingSpace    {
    _contentLeadingSpace = contentLeadingSpace;
    
    // Update Constraint Values
    self.titleLeadingSpaceConstraint.constant = self.contentLeadingSpace - 8.0;
    self.subtitleLeadingSpaceConstraint.constant = self.titleLeadingSpaceConstraint.constant;
    [self layoutIfNeeded];
}

#pragma mark - Helper Methods

- (void) setTitle:(NSString *)title andSubtitle:(NSString *)subtitle withTextAlignment:(NSTextAlignment)alignment    {
    
    // Set Cell Text Fonts & Colors
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = alignment;
    self.subtitleLabel.text = subtitle;
    self.subtitleLabel.textAlignment = alignment;
    
    // Update Constraints
    if ((self.titleLabel.text.length <= 0 && self.subtitleLabel.text.length <= 0) ||
        self.subtitleLabel.text.length <= 0)
    {
        self.titleLabelBottomConstraint.active = YES;
        self.subtitleLabelTopConstraint.active = NO;
        self.titleSubtitleVerticalSpacingConstraint.constant = 0.0;
    }
    else if (self.titleLabel.text.length <= 0) {
        self.titleLabelBottomConstraint.active = NO;
        self.subtitleLabelTopConstraint.active = YES;
        self.titleSubtitleVerticalSpacingConstraint.constant = 0.0;
    }
    else    {
        self.titleLabelBottomConstraint.active = NO;
        self.subtitleLabelTopConstraint.active = NO;
        self.titleSubtitleVerticalSpacingConstraint.constant = 5.0;
    }
}

#pragma mark - Button Click Events


@end
