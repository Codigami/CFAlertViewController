//
//  HomeTableViewController.h
//  CFAlertViewControllerDemo
//
//  Created by Vinayak Parmar on 15/06/16.
//  Copyright © 2016 Codigami Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>



// Delegate Protocol
@protocol HomeTableViewControllerDelegate;



@interface HomeTableViewController : UITableViewController
@property (nonatomic, weak) id<HomeTableViewControllerDelegate> delegate;
@end


// Delegate Declarations
@protocol HomeTableViewControllerDelegate <NSObject>

@optional
- (void) homeTableViewControllerDidClose:(HomeTableViewController *)viewController;

@end



