#CFAlertViewController
`CFAlertViewController` is a library that helps you display and customise **alerts and action sheets** on iPad and iPhone. It offers screen rotation as well as an adaptive UI support. CFAlertViewController’s functionality is almost similar to the native UIAlertController. You can check out the variations you can implement by using the library:

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
Below are variations with Alerts and Actionsheets which can be implemented easily
<p>
<img src="https://github.com/Codigami/CFAlertViewController/blob/develop/Images/Alert%20%26%20Action%20sheet.png" style="width: 100%" />
</p>
```
    CFAlertViewController *alert = [CFAlertViewController alertControllerWithTitle:@"You've hit the limit!"
                                                                           message:@"Looks like you've hit your daily follow/unfollow limit. Upgrade to our paid plan to be able to remove your limits."
                                                                     textAlignment:NSTextAlignmentLeft
                                                                    preferredStyle:CFAlertControllerStyleAlert
                                                            didDismissAlertHandler:^{
                                                                NSLog(@"Alert Dismissed");
                                                            }];
    CFAlertAction *actionDefault = [CFAlertAction actionWithTitle:@"UPGRADE"
                                                            style:CFAlertActionStyleDefault
                                                        alignment:CFAlertActionAlignmentRight
                                                            color:[UIColor colorWithRed:46.0/255.0 green:204.0/255.0  blue:113.0/255.0 alpha:1]
                                                          handler:^(CFAlertAction *action) {
                                                              NSLog(@"Button with %@ title tapped",action.title);
                                                          }];
    [alert addAction:actionDefault];

    [self presentViewController:alert animated:YES completion:nil];
```

## Customisations :

### Alerts
```
+ (nonnull instancetype) alertControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                    textAlignment:(NSTextAlignment)textAlignment
                                   preferredStyle:(CFAlertControllerStyle)preferredStyle
                                       headerView:(nullable UIView *)headerView
                                       footerView:(nullable UIView *)footerView
                           didDismissAlertHandler:(nullable CFAlertViewControllerDismissBlock)dismiss;
```
##### Title and Subtitle  
You can set custom title and subtitle of the alert (pass nil if you don’t need them).

##### Alignment  
You can customise alignment of the title and subtitle. Set the `textAlignment` property with one of the following values : 
```
NSTextAlignmentLeft,    
NSTextAlignmentRight,    
NSTextAlignmentCenter
```

##### Alert Style  
Presentation style of the alert can be customised as Alert or Action sheet. Just set the `preferredStyle` property with one of the following values :
```
CFAlertControllerStyleAlert,
CFAlertControllerStyleActionSheet
```

##### Header / Footer
 You can add header and footer to the alert (as shown in the gif). Set properties `headerView` and `footerView` with custom views (subclass of UIView). You can pass nil to this properties to opt them out.  Some examples where you can make the use of Header / Footer  
 
1) To show an image in header related to the Title and Subtitle  
<p>
    <img src="https://github.com/Codigami/CFAlertViewController/blob/develop/Images/Alert%20With%20Header.png" style="width: 100%" />
</p>

2) To give user more option than just dismissing the Alert
<p>
    <img src="https://github.com/Codigami/CFAlertViewController/blob/develop/Images/Alert%20With%20Footer.png" style="width: 100%" />
</p>

##### Callback
A block (of type CFAlertViewControllerDismissBlock) gets called when the Alert / Action Sheet is dismissed. You can use it to handle call backs.

### Actions
```
+ (nullable instancetype) actionWithTitle:(nonnull NSString *)title
                                    style:(CFAlertActionStyle)style
                                alignment:(CFAlertActionAlignment)alignment
                                    color:(nullable UIColor *)color
                                  handler:(nullable CFAlertActionHandlerBlock)handler
```                           
##### Title
You can set the title of action button to be added.  

##### Action Style
Configure the style of the action button that is to be added to alert view. Set `style` property of the above method with one of the following Action style  
```
 CFAlertActionStyleDefault,
 CFAlertActionStyleCancel,
 CFAlertActionStyleDestructive
```

##### Actions Alignment
Configure the alignment of the action button added to the alert view. Set `alignment` property of  CFAction constructor with one of the following action types
```
 CFAlertActionAlignmentJustified (Action Button occupies the full width),
 CFAlertActionAlignmentRight,
 CFAlertActionAlignmentLeft,
 CFAlertActionAlignmentCenter,
```

##### Callback
A block (of type CFAlertActionHandlerBlock) gets called when action is tapped. 

