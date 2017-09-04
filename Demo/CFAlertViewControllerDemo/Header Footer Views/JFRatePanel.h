//
//  JFRatePanel.h
//  CrowdFire
//
//  Created by Shardul Patel on 24/02/14.
//
//

#import <UIKit/UIKit.h>

@protocol JFRatePanelDelegate;

typedef enum {
    RateViewAlignmentLeft,
    RateViewAlignmentCenter,
    RateViewAlignmentRight
} RatePanelAlignment;


@interface JFRatePanel : UIView {
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
@property(nonatomic, assign) NSObject<JFRatePanelDelegate> *delegate;

- (JFRatePanel *)initWithFrame:(CGRect)frame;
- (JFRatePanel *)initWithFrame:(CGRect)rect fullStar:(UIImage *)fullStarImage emptyStar:(UIImage *)emptyStarImage;

- (void) setRate:(NSInteger)rate animate:(BOOL)animate;

- (void) flashAllStars;
- (void) bumpStarAtIndex:(NSInteger)starIndex;

@end


@protocol JFRatePanelDelegate

- (void)rateView:(JFRatePanel *)rateView changedToNewRate:(NSInteger)rate;

@end