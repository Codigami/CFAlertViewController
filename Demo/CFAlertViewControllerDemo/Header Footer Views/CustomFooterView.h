//
//  CustomFooterView.h
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 03/07/17.
//
//

#import <UIKit/UIKit.h>
@class CFAlertViewController;



@interface CustomFooterView : UIView

// Alert view controller reference
@property (nonatomic, weak) CFAlertViewController *alertController;

// This method will update height of this view
- (void) updateHeight;

@end
