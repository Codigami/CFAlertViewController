//
//  ColorPickerTableViewController.h
//  CFAlertViewControllerDemo
//
//  Created by Ram Suthar on 06/03/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerTableViewControllerDelegate;

@interface ColorPickerTableViewController : UITableViewController

@property (nonatomic, weak) id <ColorPickerTableViewControllerDelegate> delegate;

// Color
@property (nonatomic, strong) UIColor *color;

@end

@protocol ColorPickerTableViewControllerDelegate <NSObject>

- (void)colorPicker:(ColorPickerTableViewController *)colorPicker didSelectColor:(UIColor *)color;

@end
