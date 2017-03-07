//
//  ColorPickerTableViewController.m
//  CFAlertViewControllerDemo
//
//  Created by Ram Suthar on 06/03/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

#import "ColorPickerTableViewController.h"

@interface ColorPickerTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

@end

@implementation ColorPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set Done Button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Update Color
    self.color = self.color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter

- (void)setColor:(UIColor *)color {
    _color = color;
    
    self.colorView.backgroundColor = self.color;
    
    // Get RGBA components
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    // Set Slider Values
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    self.alphaSlider.value = alpha;
}

#pragma mark - IBActions

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.color = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:self.alphaSlider.value];
    self.colorView.backgroundColor = self.color;
}

- (IBAction)doneButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(colorPicker:didSelectColor:)]) {
        [self.delegate colorPicker:self didSelectColor:self.color];
    }
    
    // Go Back
    [self.navigationController popViewControllerAnimated:YES];
}

@end
