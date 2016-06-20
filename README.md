#CRAlertController
`CRAlertController` is a library that helps you display and customise **alerts and action sheets** on iPad and iPhone. It offers screen rotation as well as an adaptive UI support. CRAlertController’s functionality is almost similar to the native UIAlertController. You can check out the variations you can implement by using the library:

<GIF>

## Requirements :

CRAlertController works on devices (iPhone and iPad) with iOS 8.0+. It depends on the following Apple frameworks: 

* Foundation.framework
* UIKit.framework

## Install :

#### Install using Cocoapods (recommended)
We assume that your Cocoapods is already configured. If you are new to Cocoapods, have a look at the [documentation](https://cocoapods.org/)

1. Add `pod CRAlertController 8.0` to your Podfile.
2. Install the pod(s) by running `pod install` in terminal (in folder where `Podfile` file is located).
3. Include CRAlertController wherever you need it with `#import "CRAlertViewController.h"`.

#### Install using Source file  
1. Open the downloaded project in Xcode, then drag and drop folder named **CRAlertViewController** onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
2. Include CRAlertController wherever you need it with `#import "CRAlertViewController.h"`.

## Usage :
<p align="center">
  <img src="https://github.com/vinayak-codigami/temp/blob/master/IMG_2734.PNG" width="350" />
</p>

The alertview shown above can be implemented with following code snippet : 
```
CRAlertViewController *alert = [CRAlertViewController alertControllerWithTitle : @"Oops!"
                                                                       message : @"Please enter your name"
                                                                 textAlignment : NSTextAlignmentCenter
                                                                preferredStyle : CRAlertControllerStyleAlert
                                                                    headerView : nil
                                                                    footerView : nil
                                                        didDismissAlertHandler : ^{
                                                                            NSLog(@"Alert Dismissed");
                                                                            }];
    
CRAlertAction *actionDefault = [CRAlertAction actionWithTitle : @"Ohk"
                                                        style : CRAlertActionStyleDefault
                                                    alignment : CRAlertActionAlignmentJustified
                                                    color : [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1] 
                                                      handler : ^(CRAlertAction *action) {
                                                         NSLog(@"Button with %@ title tapped",action.title);
                                                        }];
[alert addAction:actionDefault];
    
[self presentViewController:alert animated:YES completion:nil];
```

## Customisations :

### Alerts
```
+ (instancetype) alertControllerWithTitle : (NSString *)title
                                  message : (NSString *)message
                            textAlignment : (NSTextAlignment)textAlignment
                           preferredStyle : (CRAlertControllerStyle)preferredStyle
                               headerView : (UIView *)headerView
                               footerView : (UIView *)footerView
                   didDismissAlertHandler : (CRAlertViewControllerDismissBlock)dismiss;
```
##### Title and Subtitle
> You can set custom title and subtitle of the alert (pass nil if you don’t need them). 

##### Alignment
> You can customise alignment of the title and subtitle. Set the `textAlignment` property with one of the following values : 
```
NSTextAlignmentLeft,    
NSTextAlignmentRight,    
NSTextAlignmentCenter
```

##### Alert Style
> Presentation style of the alert can be customised as Alert or Action sheet. Just set the `preferredStyle` property with one of the following values :
```
CRAlertControllerStyleAlert,
CRAlertControllerStyleActionSheet
```

##### Header / Footer
> You can add header and footer to the alert (as shown in the gif). Set properties `headerView` and `footerView` with custom views (subclass of UIView). You can pass nil to this properties to opt them out.  Some examples where you can make the use of Header / Footer  
1) To show some error Image on header  
<p align="center">
  <img src="https://github.com/vinayak-codigami/temp/blob/master/IMG_2734.PNG" width="350" />
</p>

>2) To give user more option than just dismissing the Alert
<p align="center">
  <img src="https://github.com/vinayak-codigami/temp/blob/master/IMG_2734.PNG" width="350" />
</p>

##### Callback
> A block (of type CRAlertViewControllerDismissBlock) gets called when the Alert / Action Sheet is dismissed. You can use it to handle call backs.

### Actions
```
+ (CRAlertAction *)actionWithTitle : (NSString *)title
                             style : (CRAlertActionStyle)style
                         alignment : (CRAlertActionAlignment)alignment
                             color : (UIColor *)color
                           handler : (CRAlertActionHandlerBlock)handler;
```                           
##### Title
> You can set the title of action button to be added.  

##### Action Style
> Configure the style of the action button that is to be added to alert view. Set `style` property of the above method with one of the following Action style  
```
 CRAlertActionStyleDefault,
 CRAlertActionStyleCancel,
 CRAlertActionStyleDestructive
```

##### Actions Alignment
> Configure the alignment of the action button added to the alert view. Set `alignment` property of  CRAction constructor with one of the following action types
```
 CRAlertActionAlignmentJustified (Action Button occupies the full width),
 CRAlertActionAlignmentRight,
 CRAlertActionAlignmentLeft,
 CRAlertActionAlignmentCenter,
```

##### Callback
> A block (of type CRAlertActionHandlerBlock) gets called when action is tapped. 

