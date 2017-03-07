//
//  CustomFooterView.m
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 03/07/17.
//
//

#import "CustomFooterView.h"
#import "CFAlertViewControllerDemo-Swift.h"



@interface CustomFooterView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIView *orContainerView;
@property (nonatomic, weak) IBOutlet UILabel *tweetViewTitleLabel;
@property (nonatomic, weak) IBOutlet UIView *tweetTextContainerView;
@property (nonatomic, weak) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) IBOutlet UILabel *tweetCharacterCountLabel;

@property (nonatomic, weak) IBOutlet CFPushButton *tweetButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tweetButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tweetButtonLeadingConstraint;
@property (nonatomic, assign) BOOL isExpanded;

// Numbers
@property (nonatomic, assign) NSInteger remainingBioCharacters;
@property (nonatomic, assign) NSInteger characterLimit;

@property (nonatomic, strong) NSString *bioText;

@end



@implementation CustomFooterView


#pragma mark - Initialization Methods

- (instancetype)init   {
    self = [super init];
    if (self){
        // Setup View
        if (![self viewSetup]) {
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        // Setup View
        if (![self viewSetup]) {
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
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
    
    if ([arrayOfViews count] < 1) {
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

- (void)basicInitialisation {
    
    // Set Clips To Bound On
    self.clipsToBounds = YES;
    
    // Set Or Container Properties
    self.orContainerView.layer.cornerRadius = self.orContainerView.frame.size.height*0.5;
    self.orContainerView.layer.borderColor = [UIColor colorWithRed:243.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1].CGColor;
    self.orContainerView.layer.borderWidth = 2.0;
    
    // Set Tweet View Title
    self.tweetViewTitleLabel.text = @"Tweet to increase limit";
    
    // Set Tweet Text Container Properties
    self.tweetTextContainerView.layer.cornerRadius = 8.0;
    self.tweetTextContainerView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1].CGColor;
    self.tweetTextContainerView.layer.borderWidth = 1.0;
    
    // Set Tweet Text View Properties
    self.tweetTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // Set Tweet Button Properties
    UIColor *buttonColor = [UIColor colorWithRed:41.0/255.0 green:198.0/255.0 blue:77.0/255.0 alpha:1];
    self.tweetButton.backgroundColor = [UIColor clearColor];
    [self.tweetButton setTitleColor:buttonColor forState:UIControlStateNormal];
    self.tweetButton.layer.borderColor = buttonColor.CGColor;
    self.tweetButton.layer.borderWidth = 1.0;
    self.tweetButton.layer.cornerRadius = 8.0;
    self.tweetButton.pushTransformScaleFactor = 0.92;
    
    // Set Tweet Character Limit
    self.characterLimit = 140;
    [self updateCaptionCharacterCountLabel];
    
    // Initialize Bio Text
    self.bioText = @"I've been using Crowdfire to grow my network on Twitter, and I'm lovin' it. Anyone else tried it yet? http://www.crowdfireapp.com";
    
    // Update Height
    self.isExpanded = NO;
    
    // Update Height
    [self updateHeight];
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

- (void) setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         if (self.isExpanded) {
                             
                             // Expand View
                             self.tweetButtonTopConstraint.active = NO;
                             self.tweetButtonLeadingConstraint.active = NO;
                             self.tweetViewTitleLabel.alpha = 1.0;
                             self.tweetTextContainerView.alpha = 1.0;
                             self.tweetCharacterCountLabel.alpha = 1.0;
                             [self.tweetButton setTitle:@"TWEET"
                                               forState:UIControlStateNormal];
                         }
                         else    {
                             
                             // Collapse View
                             self.tweetButtonTopConstraint.active = YES;
                             self.tweetButtonLeadingConstraint.active = YES;
                             self.tweetViewTitleLabel.alpha = 0.0;
                             self.tweetTextContainerView.alpha = 0.0;
                             self.tweetCharacterCountLabel.alpha = 0.0;
                             [self.tweetButton setTitle:@"TWEET TO INCREASE LIMIT"
                                               forState:UIControlStateNormal];
                         }
                         
                         // Update Height
                         [self updateHeight];
                         
                     } completion:nil];
}

#pragma mark - UITextView Delegate

- (void) textViewDidChange:(UITextView *)textView    {
    
    // Set Caption Text
    self.bioText = textView.text;
    [self updateCaptionCharacterCountLabel];
}

#pragma mark - Tweet Limit Calculation

- (void) updateCaptionCharacterCountLabel   {
    
    self.remainingBioCharacters = self.characterLimit - self.tweetTextView.text.length;
    
    // Update charecter Count Label
    self.tweetCharacterCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.remainingBioCharacters];
    
    [self enableTweetButton];
}

- (void)enableTweetButton{
    if (self.remainingBioCharacters < 0 || self.remainingBioCharacters == self.characterLimit) {
        self.tweetButton.enabled = NO;
        UIColor *buttonColor = [UIColor grayColor];
        [self.tweetButton setTitleColor:buttonColor forState:UIControlStateNormal];
        self.tweetButton.layer.borderColor = buttonColor.CGColor;
    }
    else {
        self.tweetButton.enabled = YES;
        UIColor *buttonColor = [UIColor colorWithRed:41.0/255.0 green:198.0/255.0 blue:77.0/255.0 alpha:1];
        [self.tweetButton setTitleColor:buttonColor forState:UIControlStateNormal];
        self.tweetButton.layer.borderColor = buttonColor.CGColor;
    }
}

#pragma mark - Actions

- (IBAction)tweetButtonPressed:(id)sender{
    
    if (!self.isExpanded) {
        self.isExpanded = YES;
    }
    else    {
        [self.alertController dismissAlertWithAnimation:YES completion:nil];
    }
}

@end
