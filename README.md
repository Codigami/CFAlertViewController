#CFAlertViewController
`CFAlertViewController` is a library that helps you display and customise **alerts and action sheets** on iPad and iPhone. It offers screen rotation as well as an adaptive UI support. CFAlertViewController’s functionality is almost similar to the native UIAlertController.

<GIF>

## Requirements :

CFAlertViewController works on devices (iPhone and iPad) with iOS 8.0+. It depends on the following Apple frameworks: 

* Foundation.framework
* UIKit.framework

#### Install using Cocoapods (recommended)
We assume that your Cocoapods is already configured. If you are new to Cocoapods, have a look at the [documentation](https://cocoapods.org/)

1. Add `pod 'CFAlertViewController'` to your Podfile.
2. Install the pod(s) by running `pod install` in terminal (in folder where `Podfile` file is located).
3. Include CFAlertViewController wherever you need it with `#import "CFAlertViewController.h"`.

#### Install using Source file  
1. Open the downloaded project in Xcode, then drag and drop folder named **CFAlertViewController** onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
2. Include CFAlertViewController wherever you need it with `#import "CFAlertViewController.h"`.

## Usage :  
<p>
    <img src="https://github.com/Codigami/CFAlertViewController/blob/develop/Images/Alert%20%26%20Action%20sheet.png" style="width: 100%" />
</p>  
The above shown alert and actionsheet can easily be implemented using the code snippet given below by some small tweaks
```objective-c
// Create Alert
CFAlertViewController *alert = [CFAlertViewController alertControllerWithTitle:@"You've hit the limit!"
                                                                       message:@"Looks like you've hit your daily follow/unfollow limit. Upgrade to our paid plan to be able to remove your limits."
                                                                 textAlignment:NSTextAlignmentCenter
                                                                preferredStyle:CFAlertControllerStyleAlert
                                                        didDismissAlertHandler:^{
                                                            NSLog(@"Alert Dismissed");
                                                        }];
    
// Add Action Button
CFAlertAction *actionDefault = [CFAlertAction actionWithTitle:@"UPGRADE"
                                                        style:CFAlertActionStyleDefault
                                                    alignment:CFAlertActionAlignmentJustified
                                                        color:[UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1]
                                                      handler: ^(CFAlertAction *action) {
                                                          NSLog(@"Button with %@ title tapped",action.title);
                                                       }];
                                                       
// Add Action Button Into Alert
[alert addAction:actionDefault];
    
// Present Alert
[self presentViewController:alert animated:YES completion:nil];
```

## Customisations :

### Alerts
```objective-c
+ (nonnull instancetype) alertControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                    textAlignment:(NSTextAlignment)textAlignment
                                   preferredStyle:(CFAlertControllerStyle)preferredStyle
                                       headerView:(nullable UIView *)headerView
                                       footerView:(nullable UIView *)footerView
                           didDismissAlertHandler:(nullable CFAlertViewControllerDismissBlock)dismiss;
```
##### Title and Message  
You can set custom title and message of the alert (pass nil if you don’t need them).

##### Alignment  
You can customise alignment of the title and message. Set the `textAlignment` property with one of the following values : 
```objective-c
NSTextAlignmentLeft,    
NSTextAlignmentRight,    
NSTextAlignmentCenter
```

##### Alert Style  
Presentation style of the alert can be customised as Alert or Action sheet. Just set the `preferredStyle` property with one of the following values :
```objective-c
CFAlertControllerStyleAlert,
CFAlertControllerStyleActionSheet
```

##### Header / Footer
 You can add header and footer to the alert. Set properties `headerView` and `footerView` with custom views (subclass of UIView). You can pass nil to this properties to opt them out.  
 
 1) Some examples where you can make the use of header in alert (the dollar image is in header)
<p>
    <img src="https://github.com/Codigami/CFAlertViewController/blob/develop/Images/Alert%20With%20Header.png" style="width: 100%" />
</p>

2) Some examples where you can make the use of footer in alert
<p>
    <img src="https://github.com/Codigami/CFAlertViewController/blob/develop/Images/Alert%20With%20Footer.png" style="width: 100%" />
</p>

##### Callback
A block (of type CFAlertViewControllerDismissBlock) gets called when the Alert / Action Sheet is dismissed. You can use it to handle call back.

### Actions
```objective-c
+ (nullable instancetype) actionWithTitle:(nonnull NSString *)title
                                    style:(CFAlertActionStyle)style
                                alignment:(CFAlertActionAlignment)alignment
                                    color:(nullable UIColor *)color
                                  handler:(nullable CFAlertActionHandlerBlock)handler;
```                           
##### Title
You can set the title of action button to be added.  

##### Action Style
Configure the style of the action button that is to be added to alert view. Set `style` property of the above method with one of the following Action style  
```objective-c
 CFAlertActionStyleDefault,
 CFAlertActionStyleCancel,
 CFAlertActionStyleDestructive
```

##### Actions Alignment
Configure the alignment of the action button added to the alert view. Set `alignment` property of  CFAction constructor with one of the following action types
```objective-c
 CFAlertActionAlignmentJustified,   // Action Button occupies the full width
 CFAlertActionAlignmentRight,
 CFAlertActionAlignmentLeft,
 CFAlertActionAlignmentCenter
```

##### Callback
A block (of type CFAlertActionHandlerBlock) gets invoked when action is tapped. 

##License
This code is distributed under the terms and conditions of the MIT license.
