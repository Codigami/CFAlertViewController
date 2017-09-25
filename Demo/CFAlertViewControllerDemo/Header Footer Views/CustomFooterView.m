//
//  CustomFooterView.m
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 03/07/17.
//
//

#import "CustomFooterView.h"
#import "UIColor+Helper.h"

#if TARGET_APP_EXTENSION
    #import "CFAlertViewControllerShareExtensionDemo-Swift.h"
#else
    #import "CFAlertViewControllerDemo-Swift.h"
#endif



@interface CustomFooterView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *orContainerView;
@property (nonatomic, weak) IBOutlet UIView *configurationUIContainer;

@property (nonatomic, weak) IBOutlet UILabel *titleNoteLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *backgroundStyleSegment;
@property (nonatomic, weak) IBOutlet UIButton *backgroundColorButton;
@property (nonatomic, weak) IBOutlet UIButton *addRemoveHeaderButton;
@property (nonatomic, assign) BOOL shouldDisplayHeader;
@property (nonatomic, weak) IBOutlet UIView *textViewContainer;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) IBOutlet CFPushButton *expandButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *expandButtonLabelVerticalConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *expandButtonTextViewContainerVerticalConstraint;
@property (nonatomic, assign) BOOL isExpanded;

@end



@implementation CustomFooterView


#pragma mark - Initialization Methods

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        // Setup View
        if (![self viewSetup]) {
            return nil;
        }
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Setup View
        if (![self viewSetup]) {
            return nil;
        }
    }
    return self;
}

- (BOOL) viewSetup {

    // Initialization code
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomFooterView class])
                                                          owner:self
                                                        options:nil];
    
    if (arrayOfViews.count < 1) {
        return NO;
    }
    
    UIView *someView = [arrayOfViews objectAtIndex:0];
    
    if (![someView isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    someView.frame = self.bounds;
    someView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    someView.translatesAutoresizingMaskIntoConstraints = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:someView];
    
    // Basic Initialisation
    [self basicInitialisation];
    
    return YES;
}

- (void) basicInitialisation {
    
    // Set Clips To Bound On
    self.clipsToBounds = YES;
    
    // Set Or Container Properties
    self.orContainerView.layer.cornerRadius = self.orContainerView.frame.size.height*0.5;
    self.orContainerView.layer.borderColor = [UIColor colorWithRed:243.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1].CGColor;
    self.orContainerView.layer.borderWidth = 2.0;
    
    // Set Expand Button Properties
    self.backgroundColorButton.backgroundColor = self.alertController.backgroundColor;
    self.backgroundColorButton.layer.cornerRadius = 5.0;
    
    // Set Add/Remove Header Button Properties
    self.addRemoveHeaderButton.layer.cornerRadius = 5.0;
    
    // Set Text View Container Properties
    self.textViewContainer.layer.cornerRadius = 8.0;
    self.textViewContainer.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1].CGColor;
    self.textViewContainer.layer.borderWidth = 1.0;
    
    // Set Text View Properties
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 6, 10, 6);
    
    // Set Expand Button Properties
    self.expandButton.layer.cornerRadius = 5.0;
    self.expandButton.pushTransformScaleFactor = 0.92;
    
    // Set Default Expanded State
    self.isExpanded = NO;
}

#pragma mark - Layout Method

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // Update Content View Frame
    self.contentView.frame = self.bounds;
}

- (void) updateHeight   {
    
    // Layout Subviews
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize contentViewSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            contentViewSize.height);
    
    // Update Self View in Alert Controller
    if (self.alertController.headerView == self) {
        self.alertController.headerView = self;
    }
    else if (self.alertController.footerView == self)   {
        self.alertController.footerView = self;
    }
}

#pragma mark - Setter / Getter Methods

- (void) setAlertController:(CFAlertViewController *)alertController    {
    _alertController = alertController;
    
    // Update Background Style and Color
    [self updateBackgroundStyle:self.alertController.backgroundStyle
             andBackgroundColor:self.alertController.backgroundColor
                  withAnimation:NO];
    
    // Update Header Display State
    self.shouldDisplayHeader = self.alertController.headerView;
}

- (void) setShouldDisplayHeader:(BOOL)shouldDisplayHeader   {
    _shouldDisplayHeader = shouldDisplayHeader;
    
    UIImageView *headerView;
    if (self.shouldDisplayHeader) {
        
        // Create Header View
        headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_image"]];
        headerView.contentMode = UIViewContentModeBottom;
        headerView.clipsToBounds = YES;
        headerView.frame = CGRectMake(0, 0, self.alertController.containerView.frame.size.width, 110.0);
        headerView.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        if (self.shouldDisplayHeader) {
            
            // Set Alert Header
            headerView.alpha = 1.0;
            self.alertController.headerView = headerView;
            
            // Update Add/Remove Header Button
            [self.addRemoveHeaderButton setTitle:@"Remove Header" forState:UIControlStateNormal];
            self.addRemoveHeaderButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1];
        }
        else    {
            
            // Remove Header
            self.alertController.headerView = nil;
            
            // Update Add/Remove Header Button
            [self.addRemoveHeaderButton setTitle:@"Add Header" forState:UIControlStateNormal];
            self.addRemoveHeaderButton.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:161.0/255.0 blue:242.0/255.0 alpha:1];
        }
    } completion:nil];
}

- (void) setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    
    if (!self.isExpanded) {
        
        // Hide Subviews
        for (UIView *childView in self.configurationUIContainer.subviews) {
            if (childView == self.titleNoteLabel ||
                childView == self.expandButton)
            {
                childView.alpha = 1.0;
            }
            else   {
                childView.alpha = 0.0;
            }
        }
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         if (self.isExpanded) {
                             
                             // Expand View
                             self.expandButtonLabelVerticalConstraint.active = NO;
                             self.expandButtonTextViewContainerVerticalConstraint.active = YES;
                             
                             // Configure Expand Button
                             [self.expandButton setTitle:@"Close"
                                                forState:UIControlStateNormal];
                             UIColor *grayColor = [UIColor grayColor];
                             self.expandButton.backgroundColor = [grayColor colorWithAlphaComponent:0.15];
                             [self.expandButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                             
                             // Show All Subviews
                             for (UIView *childView in self.configurationUIContainer.subviews) {
                                 childView.alpha = 1.0;
                             }
                         }
                         else    {
                             
                             // Collapse View
                             self.expandButtonTextViewContainerVerticalConstraint.active = NO;
                             self.expandButtonLabelVerticalConstraint.active = YES;
                             
                             // Configure Expand Button
                             [self.expandButton setTitle:@"Configurations"
                                                forState:UIControlStateNormal];
                             UIColor *blueColor = [UIColor colorWithRed:29.0/255.0 green:161.0/255.0 blue:242.0/255.0 alpha:1];
                             self.expandButton.backgroundColor = blueColor;
                             [self.expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                             
                             // Dismiss Keyboard
                             [self endEditing:YES];
                         }
                         
                         // Update Height
                         [self updateHeight];
                         
                     } completion:nil];
}

#pragma mark - Helper Methods

- (void) updateBackgroundStyle:(CFAlertControllerBackgroundStyle)style
            andBackgroundColor:(UIColor *)color
                 withAnimation:(BOOL)shouldAnimate
{
    if (shouldAnimate) {
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [self updateBackgroundStyle:style andBackgroundColor:color];
            
        } completion:nil];
    }
    else    {
        [self updateBackgroundStyle:style andBackgroundColor:color];
    }
}

- (void) updateBackgroundStyle:(CFAlertControllerBackgroundStyle)style andBackgroundColor:(UIColor *)color  {
    
    // Update Background Style Segment
    switch (style) {
            
        case CFAlertControllerBackgroundStylePlain:
            self.backgroundStyleSegment.selectedSegmentIndex = 0;
            break;
            
        case CFAlertControllerBackgroundStyleBlur:
            self.backgroundStyleSegment.selectedSegmentIndex = 1;
            break;
    }
    
    // Update Background Color Button
    self.backgroundColorButton.backgroundColor = color;
    
    // Update Alert View Controller Properties
    self.alertController.backgroundStyle = style;
    self.alertController.backgroundColor = color;
}

#pragma mark - Button Click Actions

- (IBAction) expandButtonPressed:(id)sender {
    self.isExpanded = !self.isExpanded;
}

- (IBAction) backgroundStyleSegmentValueChanged:(id)sender    {
    [self updateBackgroundStyle:self.backgroundStyleSegment.selectedSegmentIndex
             andBackgroundColor:self.backgroundColorButton.backgroundColor
                  withAnimation:YES];
}

- (IBAction) addRemoveHeaderButtonPressed:(id)sender    {
    self.shouldDisplayHeader = !self.shouldDisplayHeader;
}

- (IBAction) backgroundColorButtonPressed:(id)sender    {
    [self updateBackgroundStyle:self.alertController.backgroundStyle
             andBackgroundColor:[UIColor randomColor]
                  withAnimation:YES];
}

@end
