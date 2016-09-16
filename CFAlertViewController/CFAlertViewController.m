//
//  CFAlertViewController.m
//  CFAlertViewController
//
//  Created by Shardul Patel on 07/06/16.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Codigami Inc
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "CFAlertViewController.h"
#import "CFAlertViewControllerPopupTransition.h"
#import "CFAlertViewControllerActionSheetTransition.h"
#import "CFAlertTitleSubtitleTableViewCell.h"
#import "CFAlertActionTableViewCell.h"



@interface CFAlertViewController () <UITableViewDataSource, UITableViewDelegate, CFAlertActionTableViewCellDelegate>

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *messageString;
@property (nonatomic, strong) NSMutableArray <CFAlertAction *> *actionList;
@property (nonatomic, copy) CFAlertViewControllerDismissBlock dismissHandler;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mainViewBottomConstraint;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewCenterYConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

// Keyboard Height Property
@property (nonatomic, assign) CGFloat keyboardHeight;

// Tap Gesture
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end



@implementation CFAlertViewController

#pragma mark - Synthesized Objects


#pragma mark - Initialisation Method

+ (nonnull instancetype) alertControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                    textAlignment:(NSTextAlignment)textAlignment
                                   preferredStyle:(CFAlertControllerStyle)preferredStyle
                           didDismissAlertHandler:(nullable CFAlertViewControllerDismissBlock)dismiss
{
    return [CFAlertViewController alertControllerWithTitle:title
                                                   message:message
                                             textAlignment:textAlignment
                                            preferredStyle:preferredStyle
                                                headerView:nil
                                                footerView:nil
                                    didDismissAlertHandler:dismiss];
}

+ (nonnull instancetype) alertControllerWithTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                    textAlignment:(NSTextAlignment)textAlignment
                                   preferredStyle:(CFAlertControllerStyle)preferredStyle
                                       headerView:(nullable UIView *)headerView
                                       footerView:(nullable UIView *)footerView
                           didDismissAlertHandler:(nullable CFAlertViewControllerDismissBlock)dismiss
{
    // Get Current Class Name
    NSString *currentClassName = NSStringFromClass([self class]);
    
    // Get Current Bundle
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    // Create New Instance Of Alert Controller
    CFAlertViewController *alert = [[CFAlertViewController alloc] initWithNibName:currentClassName
                                                                           bundle:bundle];
    alert.titleString = title;
    alert.messageString = message;
    alert.textAlignment = textAlignment;
    alert.preferredStyle = preferredStyle;
    [alert setHeaderView:headerView shouldUpdateContainerFrame:NO withAnimation:NO];
    [alert setFooterView:footerView shouldUpdateContainerFrame:NO withAnimation:NO];
    alert.dismissHandler = dismiss;
    
    // Custom Presentation
    alert.modalPresentationStyle = UIModalPresentationCustom;
    alert.transitioningDelegate = alert;
    
    return alert;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil   {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Basic Initialisation
        self.actionList = [NSMutableArray arrayWithCapacity:2];
        self.shouldDismissOnBackgroundTap = YES;
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)loadVariables   {
    
    // Register For Keyboard Notification Observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Text Field & Text View Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewOrTextFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewOrTextFieldDidBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    
    // Add Key Value Observer
    [self.tableView addObserver:self
                     forKeyPath:@"contentSize"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior
                        context:NULL];
}

- (void)loadDisplayContent  {
    
    // Add Tap Gesture Recognizer On View
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load Variables
    [self loadVariables];
    
    // Load Display Content
    [self loadDisplayContent];
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    
    // Update UI
    [self updateUIWithAnimation:NO];
}

- (void)viewDidAppear:(BOOL)animated   {
    [super viewDidAppear:animated];
}

#pragma mark - Setter Methods

- (void) setTextAlignment:(NSTextAlignment)textAlignment    {
    _textAlignment = textAlignment;
}

- (void) setPreferredStyle:(CFAlertControllerStyle)preferredStyle   {
    _preferredStyle = preferredStyle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        // Position Contraints for Container View
        if (preferredStyle == CFAlertControllerStyleActionSheet) {
            
            // Set Corner Radius
            self.containerView.layer.cornerRadius = 6.0f;
            
            self.containerViewCenterYConstraint.active = NO;
            self.containerViewBottomConstraint.active = YES;
            
        } else {
            
            // Set Corner Radius
            self.containerView.layer.cornerRadius = 8.0f;
            
            self.containerViewBottomConstraint.active = NO;
            self.containerViewCenterYConstraint.active = YES;
        }
        
        [self.view layoutIfNeeded];
    });
}

- (void) setHeaderView:(UIView *)headerView {
    [self setHeaderView:headerView shouldUpdateContainerFrame:YES withAnimation:YES];
}

- (void) setHeaderView:(UIView *)headerView shouldUpdateContainerFrame:(BOOL)shouldUpdateContainerFrame withAnimation:(BOOL)animate
{
    _headerView = headerView;
    
    // Set Into Table Header View
    self.tableView.tableHeaderView = self.headerView;
    
    // Update Container View Frame If Requested
    if(shouldUpdateContainerFrame)  {
        [self updateContainerViewFrameWithAnimation:animate];
    }
}

- (void) setFooterView:(UIView *)footerView {
    [self setFooterView:footerView shouldUpdateContainerFrame:YES withAnimation:YES];
}

- (void) setFooterView:(UIView *)footerView shouldUpdateContainerFrame:(BOOL)shouldUpdateContainerFrame withAnimation:(BOOL)animate
{
    _footerView = footerView;
    
    // Set Into Table Footer View
    self.tableView.tableFooterView = self.footerView;
    
    // Update Container View Frame If Requested
    if(shouldUpdateContainerFrame)  {
        [self updateContainerViewFrameWithAnimation:animate];
    }
}

- (void) setKeyboardHeight:(CGFloat)keyboardHeight  {
    
    // Check if keyboard Height Changed
    BOOL isKeyboardHeightChanged = NO;
    if (self.keyboardHeight != keyboardHeight) {
        isKeyboardHeightChanged = YES;
    }
    
    // Update Keyboard Height
    _keyboardHeight = keyboardHeight;
    
    // Update Table View Bottom Constraint
    if (isKeyboardHeightChanged)    {
        
        // Update Main View Bottom Constraint
        self.mainViewBottomConstraint.constant = self.keyboardHeight;
    }
}

#pragma mark - Getter Methods

- (NSArray <CFAlertAction *> *) actions   {
    return [NSArray arrayWithArray:self.actionList];
}

#pragma mark - Helper Methods

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (void)addAction:(CFAlertAction *)action   {
    
    if (action) {
        
        // Check For Cancel Action. Every Alert must have maximum 1 Cancel Action.
        if (action.style == CFAlertActionStyleCancel) {
            
            for (CFAlertAction *existingAction in self.actionList) {
                
                // This line of code added to just supress the warning (Unused Variable) at build time
                #pragma unused(existingAction)
                
                // It means this alert already contains a Cancel action. Throw an Assert so developer understands the reason.
                NSAssert(existingAction.style != CFAlertActionStyleCancel, @"ERROR : CFAlertViewController can only have one action with a style of CFAlertActionStyleCancel");
            }
        }
        
        // Add Action Into List
        [self.actionList addObject:action];
    }
    else    {
        NSLog(@"WARNING >>> CFAlertViewController received nil action to add. It must not be nil.");
    }
}

- (void) updateUIWithAnimation:(BOOL)shouldAnimate   {
    
    // Refresh Preferred Style
    self.preferredStyle = self.preferredStyle;
    
    // Update Table Header View
    [self setHeaderView:self.headerView shouldUpdateContainerFrame:NO withAnimation:NO];
    
    // Update Table Footer View
    [self setFooterView:self.footerView shouldUpdateContainerFrame:NO withAnimation:NO];
    
    // Reload Table Content
    [self.tableView reloadData];
    
    // Update Container View Frame
    [self updateContainerViewFrameWithAnimation:shouldAnimate];
}

- (void) updateContainerViewFrameWithAnimation:(BOOL)shouldAnimate   {
    
    void (^animate)(void) = ^{
        
        // Update Content Size
        self.tableViewHeightConstraint.constant = self.tableView.contentSize.height;
        
        // Enable / Disable Bounce Effect
        if (self.tableView.contentSize.height <= self.containerView.frame.size.height) {
            self.tableView.bounces = NO;
        }
        else    {
            self.tableView.bounces = YES;
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (shouldAnimate) {
            
            // Animate height changes
            [UIView animateWithDuration:0.4
                                  delay:0.0
                 usingSpringWithDamping:0.84
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 // Animate
                                 animate();
                                 
                                 // Relayout
                                 [self.view layoutIfNeeded];
                                 
                             } completion:nil];
        }
        else    {
            animate();
        }
    });
}

- (void) dismissAlertWithAnimation:(BOOL)animate completion:(void (^__nullable)(void))completion   {
    
    // Dismiss
    [self dismissViewControllerAnimated:animate
                             completion:^{
                                 
                                 // Call Completion Block
                                 if (completion) {
                                     completion();
                                 }
                                 
                                 // Call Dismiss Block
                                 if (self.dismissHandler) {
                                     self.dismissHandler();
                                 }
                             }];
}

#pragma mark - Button Click Events


#pragma mark - Handle Tap Events

- (void) viewDidTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint loc = [gestureRecognizer locationInView:self.view];
    if ( CGRectContainsPoint(self.containerView.frame, loc) ) {
        
        // Close Keyboard
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    else if (self.shouldDismissOnBackgroundTap)    {
        
        // Dismiss Alert
        [self dismissAlertWithAnimation:YES completion:^{
            
            // Simulate Cancel Button
            for (CFAlertAction *existingAction in self.actionList) {
                
                if (existingAction.style == CFAlertActionStyleCancel) {
                    
                    // Call Action Handler If Set
                    if (existingAction.handler) {
                        existingAction.handler(existingAction);
                    }
                    
                    break;
                }
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    
    switch (section) {
            
        case 0: {
            if (self.titleString.length>0 || self.messageString.length>0) {
                return 1;
            }
            break;
        }
            
        case 1: {
            return self.actionList.count;
            break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell;
    switch (indexPath.section) {
            
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:[CFAlertTitleSubtitleTableViewCell identifier]];
            if (!cell) {
                cell = [[CFAlertTitleSubtitleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                                reuseIdentifier:[CFAlertTitleSubtitleTableViewCell identifier]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // Title Subtitle Cell
            CFAlertTitleSubtitleTableViewCell *titleSubtitleCell = (CFAlertTitleSubtitleTableViewCell *) cell;
            
            // Set Content
            [titleSubtitleCell setTitle:self.titleString
                            andSubtitle:self.messageString
                      withTextAlignment:self.textAlignment];
            
            // Set Content Margin
            titleSubtitleCell.contentTopMargin = 20.0;
            if (self.actionList.count <= 0) {
                titleSubtitleCell.contentBottomMargin = 20.0;
            }
            else    {
                titleSubtitleCell.contentBottomMargin = 0.0;
            }
            
            break;
        }
            
        case 1: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:[CFAlertActionTableViewCell identifier]];
            if (!cell) {
                cell = [[CFAlertActionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                                reuseIdentifier:[CFAlertActionTableViewCell identifier]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // Title Subtitle Cell
            CFAlertActionTableViewCell *actionCell = (CFAlertActionTableViewCell *) cell;
            
            // Set Delegate
            actionCell.delegate = self;
            
            // Set Action
            actionCell.action = [self.actionList objectAtIndex:indexPath.row];
            
            // Set Top Margin For First Action
            if(indexPath.row == 0)  {
                
                if (self.titleString.length>0 || self.messageString.length>0) {
                    actionCell.actionButtonTopMargin = 20.0;
                }
                else    {
                    actionCell.actionButtonTopMargin = 20.0;
                }
            }
            
            // Set Bottom Margin For Last Action
            if (indexPath.row == self.actionList.count-1) {
                actionCell.actionButtonBottomMargin = 20.0;
            }
            else    {
                actionCell.actionButtonBottomMargin = 10.0;
            }
            
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return UITableViewAutomaticDimension;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Deselect Table Cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CFAlertActionTableViewCellDelegate

- (void) alertActionCell:(CFAlertActionTableViewCell *)cell didClickAction:(CFAlertAction *)action  {
    
    // Dimiss Self
    [self dismissAlertWithAnimation:YES completion:^{
        
        // Call Action Handler If Set
        if (action.handler) {
            action.handler(action);
        }
    }];
}

#pragma mark - Key Value Observers

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])   {
        
        // Update Container View Frame Without Animation
        [self updateContainerViewFrameWithAnimation:NO];
    }
}

#pragma mark - Keyboard Show / Hide Notification Handlers

- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect viewRect = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect intersectRect = CGRectIntersection(kbRect, viewRect);
    
    if (intersectRect.size.height > 0.0)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                                  delay:0.0f
                 usingSpringWithDamping:1.0f
                  initialSpringVelocity:0.0f
                                options:[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue]
                             animations:^{
                                 
                                 // Update Keyboard Height
                                 self.keyboardHeight = intersectRect.size.height;
                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];
        });
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:0.0f
                            options:[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue]
                         animations:^{
                             
                             // Update Keyboard Height
                             self.keyboardHeight = 0.0;
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    });
}

#pragma mark - TextView or Text Field Did Begin Editing Notification

- (void) textViewOrTextFieldDidBeginEditing:(NSNotification *)notification {
    
    if ([notification.object isMemberOfClass:[UITextField class]] ||
        [notification.object isMemberOfClass:[UITextView class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            UIView *view = (UIView *) notification.object;
            
            // Keyboard becomes visible
            [UIView animateWithDuration:0.4
                                  delay:0.0
                 usingSpringWithDamping:1.0
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 // Get Location Of View inside Table View
                                 CGRect visibleRect = [self.tableView convertRect:view.frame
                                                                         fromView:view.superview];
                                 
                                 // Scroll To Visible Rect
                                 [self.tableView scrollRectToVisible:visibleRect animated:NO];
                                 
                             } completion:nil];
        });
    }
}

#pragma mark - View Rotation / Size Change Method

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
        // Update UI
        [self updateUIWithAnimation:NO];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
    }];
}

#pragma mark - Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[CFAlertViewController class]]) {
        
        if (self.preferredStyle == CFAlertControllerStyleAlert) {
            CFAlertViewControllerPopupTransition *transition = [CFAlertViewControllerPopupTransition new];
            transition.transitionType = CFAlertPopupTransitionTypePresent;
            return transition;
        }
        else    {
            CFAlertViewControllerActionSheetTransition *transition = [CFAlertViewControllerActionSheetTransition new];
            transition.transitionType = CFAlertActionSheetTransitionTypePresent;
            return transition;
        }
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[CFAlertViewController class]]) {
        
        if (self.preferredStyle == CFAlertControllerStyleAlert) {
            CFAlertViewControllerPopupTransition *transition = [CFAlertViewControllerPopupTransition new];
            transition.transitionType = CFAlertPopupTransitionTypeDismiss;
            return transition;
        }
        else    {
            CFAlertViewControllerActionSheetTransition *transition = [CFAlertViewControllerActionSheetTransition new];
            transition.transitionType = CFAlertActionSheetTransitionTypeDismiss;
            return transition;
        }
    }
    return nil;
}

#pragma mark - Dealloc

- (void) dealloc    {
    
    // Remove KVO
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    
    NSLog(@"Popup Dealloc");
}

@end
