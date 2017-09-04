//
//  JFRatePanel.m
//  CrowdFire
//
//  Created by Shardul Patel on 24/02/14.
//
//

#import "JFRatePanel.h"

static NSString *DefaultFullStarImageFilename = @"Star_Yellow";
static NSString *DefaultEmptyStarImageFilename = @"Star_DarkGray";

@interface JFRatePanel () <UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSMutableArray *starImageViewList;

- (void)commonSetup;
- (void)handleTouchAtLocation:(CGPoint)location touchFinished:(BOOL)isTouchFinished;
- (void)notifyDelegate;

@end


@implementation JFRatePanel

#pragma mark - Synthesized Objects

@synthesize totalStars = _totalStars;
@synthesize rate = _rate;
@synthesize alignment = _alignment;
@synthesize padding = _padding;
@synthesize editable = _editable;
@synthesize fullStarImage = _fullStarImage;
@synthesize emptyStarImage = _emptyStarImage;
@synthesize delegate = _delegate;

#pragma mark - Initialisation Methods

- (JFRatePanel *)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame fullStar:[UIImage imageNamed:DefaultFullStarImageFilename] emptyStar:[UIImage imageNamed:DefaultEmptyStarImageFilename]];
}

- (JFRatePanel *)initWithFrame:(CGRect)frame fullStar:(UIImage *)fullStarImage emptyStar:(UIImage *)emptyStarImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _fullStarImage = fullStarImage;
        _emptyStarImage = emptyStarImage;
        
        [self commonSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _fullStarImage = [UIImage imageNamed:DefaultFullStarImageFilename];
        _emptyStarImage = [UIImage imageNamed:DefaultEmptyStarImageFilename];
        
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    // Init Objects
    _starImageViewList = [NSMutableArray arrayWithCapacity:5];
    _padding = 10;
    _totalStars = 5;
    _rate = 0;
    _alignment = RateViewAlignmentLeft;
    self.editable = NO;
    
    // Setup View
    [self setUpView];
    
    // Add Tap Gesture Recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void) setUpView  {
    
    [self removeAllChildViews];
    
    switch (_alignment) {
        case RateViewAlignmentLeft:
        {
            _origin = CGPointMake(0, (self.bounds.size.height/2) - (_fullStarImage.size.height/2));
            break;
        }
        case RateViewAlignmentCenter:
        {
            _origin = CGPointMake((self.bounds.size.width - _totalStars * _fullStarImage.size.width - (_totalStars - 1) * _padding)/2,
                                  (self.bounds.size.height/2) - (_fullStarImage.size.height/2));
            break;
        }
        case RateViewAlignmentRight:
        {
            _origin = CGPointMake(self.bounds.size.width - _totalStars * _fullStarImage.size.width - (_totalStars - 1) * _padding,
                                  (self.bounds.size.height/2) - (_fullStarImage.size.height/2));
            break;
        }
    }
    
    // Set Empty Star Image Views
    float x = _origin.x;
    for(int i = 0; i < _totalStars; i++) {
        UIImageView *emptyStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, _origin.y, _fullStarImage.size.width, _fullStarImage.size.height)];
        emptyStarImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_starImageViewList addObject:emptyStarImageView];
        [self addSubview:emptyStarImageView];
        x += _fullStarImage.size.width + _padding;
    }
}

#pragma mark - Helper Methods

- (void)removeAllChildViews {
    
    // Remove All Star Views From Screen
    for (UIView *childView in self.subviews) {
        [childView removeFromSuperview];
    }
    
    // Remove All Star View References
    [_starImageViewList removeAllObjects];
}

#pragma mark - Accessible Methods

- (void) setRate:(NSInteger)rate animate:(BOOL)animate notifyToDelegate:(BOOL)shouldNotifyDelegate  {
    
    if (rate < 0) {
        rate = 0;
    }
    else if(rate > _totalStars)   {
        rate = _totalStars;
    }
    else    {
        rate = rate;
    }
    
    if (_rate != rate) {
        _rate = rate;
    }
    else    {
        animate = NO;
    }
    
    if (animate) {
        
        // Set Full Star Images
        int imageCount = 0;
        for (; imageCount<_rate; imageCount++) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imageView = [_starImageViewList objectAtIndex:imageCount];
                
                [UIView transitionWithView:imageView
                                  duration:0.2
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    imageView.image = _fullStarImage;
                                } completion:NULL];
            });
        }
        
        // Set Empty Star Images
        for (; imageCount<_starImageViewList.count; imageCount++) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [_starImageViewList objectAtIndex:imageCount];
                
                [UIView transitionWithView:imageView
                                  duration:0.18
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    imageView.image = _emptyStarImage;
                                } completion:NULL];
            });
        }
    }
    else    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Set Full Star Images
            int imageCount = 0;
            for (; imageCount<_rate; imageCount++) {
                UIImageView *imageView = [_starImageViewList objectAtIndex:imageCount];
                imageView.image = _fullStarImage;
            }
            
            // Set Empty Star Images
            for (; imageCount<_starImageViewList.count; imageCount++) {
                UIImageView *imageView = [_starImageViewList objectAtIndex:imageCount];
                imageView.image = _emptyStarImage;
            }
        });
    }
    
    // Notify Delegate For Value Change Event
    if (shouldNotifyDelegate) {
        [self notifyDelegate];
    }
}

- (void) setRate:(NSInteger)rate animate:(BOOL)animate  {
    [self setRate:rate animate:animate notifyToDelegate:YES];
}

- (void) bumpStarAtIndex:(NSInteger)starIndex   {
    
    starIndex = starIndex - 1;
    
    if (starIndex < 0 || starIndex>=_totalStars) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Bump Current Rate Star
        UIImageView *currentRatedStarImageView = [_starImageViewList objectAtIndex:starIndex];
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             // Scale Up Star Image View
                             currentRatedStarImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             [self layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.2f
                                                   delay:0.0f
                                                 options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  
                                                  // Scale News Container View To Original Postion
                                                  currentRatedStarImageView.transform = CGAffineTransformIdentity;
                                                  [self layoutIfNeeded];
                                              }
                                              completion:^(BOOL finished) {
                                                  
                                                  // Enable User Interaction
                                                  self.userInteractionEnabled = YES;
                                              }];
                         }];
    });
}

- (void) flashAllStars  {
    
    NSInteger currentRate = _rate;
    
    for (int imageCount = 1; imageCount<=_totalStars; imageCount++) {
        [self performSelector:@selector(setRateWithAnimation:) withObject:[NSNumber numberWithInteger:imageCount] afterDelay:(0.16 * imageCount)];
        [self performSelector:@selector(bumpStar:) withObject:[NSNumber numberWithInteger:imageCount] afterDelay:(0.19 * imageCount)];
    }
    
    [self performSelector:@selector(setRateWithAnimation:) withObject:[NSNumber numberWithInteger:currentRate] afterDelay:(0.18 * _totalStars + 0.6)];
}

- (void) setRateWithAnimation:(NSNumber *)rate   {
    [self setRate:[rate integerValue] animate:YES notifyToDelegate:NO];
}

- (void) bumpStar:(NSNumber *)starIndex {
    [self bumpStarAtIndex:starIndex.integerValue];
}

#pragma mark - Setter / Getter Methods

- (void)setTotalStars:(NSInteger)totalStars {
    _totalStars = totalStars;
    [self setUpView];
}

- (void)setRate:(NSInteger)rate {
    [self setRate:rate animate:YES];
}

- (void)setAlignment:(RatePanelAlignment)alignment
{
    _alignment = alignment;
    [self setUpView];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.userInteractionEnabled = _editable;
}

- (void)setFullStarImage:(UIImage *)fullStarImage
{
    if (fullStarImage != _fullStarImage) {
        _fullStarImage = fullStarImage;
        [self setRate:_rate];
    }
}

- (void)setEmptyStarImage:(UIImage *)emptyStarImage
{
    if (emptyStarImage != _emptyStarImage) {
        _emptyStarImage = emptyStarImage;
        [self setRate:_rate];
    }
}

#pragma mark - Touch Handlers

- (void)handleTouchAtLocation:(CGPoint)location touchFinished:(BOOL)isTouchFinished {
    for(NSInteger i = _totalStars - 1; i > -1; i--) {
        if (location.x > _origin.x + i * (_fullStarImage.size.width + _padding) - _padding / 2.) {
            NSInteger rate = i + 1;
            [self setRate:rate animate:YES notifyToDelegate:isTouchFinished];
            return;
        }
    }
    [self setRate:0 animate:YES notifyToDelegate:isTouchFinished];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint touchLocation = [tapGestureRecognizer locationInView:self];
    [self handleTouchAtLocation:touchLocation touchFinished:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation touchFinished:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation touchFinished:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event    {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation touchFinished:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event    {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation touchFinished:NO];
}

- (void)notifyDelegate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rateView:changedToNewRate:)]) {
        [self.delegate rateView:self changedToNewRate:self.rate];
    }
}

#pragma mark - Memory Management

- (void)dealloc {
    _fullStarImage = nil;
    _emptyStarImage = nil;
}

@end
