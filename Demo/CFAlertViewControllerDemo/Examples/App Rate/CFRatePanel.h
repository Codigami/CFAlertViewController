//
//  CFRatePanel.h
//  CrowdFire
//
//  Created by Shardul Patel on 24/02/14.
//
//

#import <UIKit/UIKit.h>

@protocol CFRatePanelDelegate;

typedef enum {
    RateViewAlignmentLeft,
    RateViewAlignmentCenter,
    RateViewAlignmentRight
} RatePanelAlignment;


@interface CFRatePanel : UIView {
    UIImage *_fullStarImage;
    UIImage *_emptyStarImage;
    CGPoint _origin;
}

@property(nonatomic, assign) RatePanelAlignment alignment;
@property(nonatomic, assign) NSInteger totalStars;
@property(nonatomic, assign) NSInteger rate;
@property(nonatomic, assign) CGFloat padding;
@property(nonatomic, assign) BOOL editable;
@property(nonatomic, retain) UIImage *fullStarImage;
@property(nonatomic, retain) UIImage *emptyStarImage;
@property(nonatomic, assign) NSObject<CFRatePanelDelegate> *delegate;

- (CFRatePanel *)initWithFrame:(CGRect)frame;
- (CFRatePanel *)initWithFrame:(CGRect)rect fullStar:(UIImage *)fullStarImage emptyStar:(UIImage *)emptyStarImage;

- (void) setRate:(NSInteger)rate animate:(BOOL)animate;

- (void) flashAllStars;
- (void) bumpStarAtIndex:(NSInteger)starIndex;

@end


@protocol CFRatePanelDelegate

- (void)rateView:(CFRatePanel *)rateView changedToNewRate:(NSInteger)rate;

@end
