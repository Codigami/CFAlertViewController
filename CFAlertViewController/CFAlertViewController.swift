//
//  CFAlertViewController.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 19/01/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


open class CFAlertViewController: UIViewController    {
    
    // MARK: - Declarations
    public typealias CFAlertViewControllerDismissBlock = (_ isBackgroundTapped: Bool) -> ()
    
    @objc public enum CFAlertControllerStyle : Int {
        case alert = 0
        case actionSheet
        case notification
    }
    
    @objc public enum CFAlertControllerBackgroundStyle : Int {
        case plain = 0
        case blur
    }
    @objc open static func CF_ALERT_DEFAULT_BACKGROUND_COLOR() -> UIColor   {
        return UIColor(white: 0.0, alpha: 0.7)
    }
    @objc open static func CF_ALERT_DEFAULT_TITLE_COLOR() -> UIColor {
        return UIColor.init(red: 1.0/255.0, green: 51.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }
    @objc open static func CF_ALERT_DEFAULT_MESSAGE_COLOR() -> UIColor {
        return UIColor.init(red: 1.0/255.0, green: 51.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }
    
    // MARK: - Variables
    // MARK: Public
    public internal(set) var textAlignment = NSTextAlignment(rawValue: 0)
    public internal(set) var preferredStyle = CFAlertControllerStyle(rawValue: 0)    {
        didSet  {
            DispatchQueue.main.async {
                // Position Contraints for Container View
                if self.preferredStyle == .notification {
                    
                    self.containerViewTopConstraint?.isActive = true
                    self.containerViewLeadingConstraint?.constant = 0
                    self.containerViewCenterYConstraint?.isActive = false
                    self.containerViewBottomConstraint?.isActive = false
                    self.containerViewTrailingConstraint?.constant = 0
                    
                    let width = (self.view.frame.size.width * 60) / 100   // 60% of the full width
                    self.tableViewWidthConstraint?.constant = max(500, min(width, 620))
                    self.tableViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 749)
                    self.tableViewTrailingConstraint?.priority = UILayoutPriority(rawValue: 749)
                }
                else if self.preferredStyle == .alert   {
                    
                    self.containerViewTopConstraint?.isActive = false
                    self.containerViewLeadingConstraint?.constant = 10
                    self.containerViewCenterYConstraint?.isActive = true
                    self.containerViewBottomConstraint?.isActive = false
                    self.containerViewTrailingConstraint?.constant = 10
                    
                    self.tableViewWidthConstraint?.constant = 500
                    self.tableViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 751)
                    self.tableViewTrailingConstraint?.priority = UILayoutPriority(rawValue: 751)
                }
                else if self.preferredStyle == .actionSheet {
                    
                    self.containerViewTopConstraint?.isActive = false
                    self.containerViewLeadingConstraint?.constant = 10
                    self.containerViewCenterYConstraint?.isActive = false
                    self.containerViewBottomConstraint?.isActive = true
                    self.containerViewTrailingConstraint?.constant = 10
                    
                    self.tableViewWidthConstraint?.constant = 500
                    self.tableViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 751)
                    self.tableViewTrailingConstraint?.priority = UILayoutPriority(rawValue: 751)
                }
                
                // Layout Full View
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc public private(set) var actions: [CFAlertAction]?   {
        set {
            // Dont Do Anything
        }
        get {
            return self.actionList
        }
    }
    internal var _headerView : UIView?
    @objc public var headerView: UIView?  {
        set {
            self.setHeaderView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _headerView
        }
    }
    internal var _footerView : UIView?
    @objc public var footerView: UIView?  {
        set {
            self.setFooterView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _footerView
        }
    }
    
    // Background
    @objc public var backgroundStyle = CFAlertControllerBackgroundStyle.plain    {
        didSet  {
            if isViewLoaded {
                // Set Background
                if backgroundStyle == .blur {
                    // Set Blur Background
                    backgroundBlurView?.alpha = 1.0
                }
                else {
                    // Display Plain Background
                    backgroundBlurView?.alpha = 0.0
                }
            }
        }
    }
    @objc public var backgroundColor: UIColor?    {
        didSet  {
            if isViewLoaded {
                view.backgroundColor = backgroundColor
            }
        }
    }
    @objc @IBOutlet public weak var backgroundBlurView: UIVisualEffectView?
    @objc public var shouldDismissOnBackgroundTap: Bool = true    // Default is True
    
    // The view which holds the popup UI
    // You can change corner radius or background color of this view for additional customisation
    @objc @IBOutlet public weak var containerView: UIView?
    
    // MARK: Private / Internal
    internal var titleString: String?
    internal var titleColor: UIColor = CFAlertViewController.CF_ALERT_DEFAULT_TITLE_COLOR()
    internal var messageString: String?
    internal var messageColor: UIColor = CFAlertViewController.CF_ALERT_DEFAULT_MESSAGE_COLOR()
    internal var actionList = [CFAlertAction]()
    internal var dismissHandler: CFAlertViewControllerDismissBlock?
    internal var keyboardHeight: CGFloat = 0.0   {
        
        didSet  {
            // Check if keyboard Height Changed
            if keyboardHeight != oldValue {
                
                // Update Main View Bottom Constraint
                mainViewBottomConstraint?.constant = keyboardHeight
            }
        }
    }
    internal var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet internal weak var mainViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableView: UITableView?
    @IBOutlet internal weak var containerViewTopConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var containerViewLeadingConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var containerViewCenterYConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var containerViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var containerViewTrailingConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableViewLeadingConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableViewTrailingConstraint: NSLayoutConstraint?
    
    
    // MARK: - Initialisation Methods
    @objc public class func alertController(title: String?,
                                            message: String?,
                                            textAlignment: NSTextAlignment,
                                            preferredStyle: CFAlertControllerStyle,
                                            didDismissAlertHandler dismiss: CFAlertViewControllerDismissBlock?) -> CFAlertViewController {
        
        return CFAlertViewController.alertController(title: title,
                                                     titleColor: nil,
                                                     message: message,
                                                     messageColor: nil,
                                                     textAlignment: textAlignment,
                                                     preferredStyle: preferredStyle,
                                                     headerView: nil,
                                                     footerView: nil,
                                                     didDismissAlertHandler: dismiss)
    }
    
    @objc public class func alertController(title: String?,
                                            titleColor: UIColor?,
                                            message: String?,
                                            messageColor: UIColor?,
                                            textAlignment: NSTextAlignment,
                                            preferredStyle: CFAlertControllerStyle,
                                            headerView: UIView?,
                                            footerView: UIView?,
                                            didDismissAlertHandler dismiss: CFAlertViewControllerDismissBlock?) -> CFAlertViewController {
        
        // Create New Instance Of Alert Controller
        return CFAlertViewController.init(title: title,
                                          titleColor: titleColor,
                                          message: message,
                                          messageColor: messageColor,
                                          textAlignment: textAlignment,
                                          preferredStyle: preferredStyle,
                                          headerView: headerView,
                                          footerView: footerView,
                                          didDismissAlertHandler: dismiss)
    }
    
    @objc public convenience init(title: String?,
                                  message: String?,
                                  textAlignment: NSTextAlignment,
                                  preferredStyle: CFAlertControllerStyle,
                                  didDismissAlertHandler dismiss: CFAlertViewControllerDismissBlock?) {
        
        // Create New Instance Of Alert Controller
        self.init(title: title,
                  titleColor: nil,
                  message: message,
                  messageColor: nil,
                  textAlignment: textAlignment,
                  preferredStyle: preferredStyle,
                  headerView: nil,
                  footerView: nil,
                  didDismissAlertHandler: dismiss)
    }
    
    @objc public convenience init(title: String?,
                                  titleColor: UIColor?,
                                  message: String?,
                                  messageColor: UIColor?,
                                  textAlignment: NSTextAlignment,
                                  preferredStyle: CFAlertControllerStyle,
                                  headerView: UIView?,
                                  footerView: UIView?,
                                  didDismissAlertHandler dismiss: CFAlertViewControllerDismissBlock?) {
        
        // Get Current Bundle
        let bundle = Bundle(for: CFAlertViewController.self)
        
        // Create New Instance Of Alert Controller
        self.init(nibName: "CFAlertViewController", bundle: bundle)
        
        // Assign Properties
        self.preferredStyle = preferredStyle
        backgroundStyle = .plain
        backgroundColor = CFAlertViewController.CF_ALERT_DEFAULT_BACKGROUND_COLOR()
        titleString = title
        if let titleColor = titleColor {
            self.titleColor = titleColor
        }
        
        messageString = message
        if let messageColor = messageColor {
            self.messageColor = messageColor
        }
        
        self.textAlignment = textAlignment
        setHeaderView(headerView, shouldUpdateContainerFrame: false, withAnimation: false)
        setFooterView(footerView, shouldUpdateContainerFrame: false, withAnimation: false)
        dismissHandler = dismiss
        
        // Custom Presentation
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        // Preload View
        if #available(iOS 9.0, *) {
            loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    // MARK: - View Life Cycle Methods
    internal func loadVariables() {
        
        // Register For Keyboard Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Text Field & Text View Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(textViewOrTextFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewOrTextFieldDidBeginEditing), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        
        // Register Cells For Table
        let actionCellNib = UINib(nibName: CFAlertActionTableViewCell.identifier(), bundle: Bundle(for: CFAlertActionTableViewCell.self))
        tableView?.register(actionCellNib, forCellReuseIdentifier: CFAlertActionTableViewCell.identifier())
        let titleSubtitleCellNib = UINib(nibName: CFAlertTitleSubtitleTableViewCell.identifier(), bundle: Bundle(for: CFAlertTitleSubtitleTableViewCell.self))
        tableView?.register(titleSubtitleCellNib, forCellReuseIdentifier: CFAlertTitleSubtitleTableViewCell.identifier())
        
        // Add Key Value Observer
        tableView?.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)
    }
    
    internal func loadDisplayContent() {
        
        // Set Container View Default Background Color
        containerView?.backgroundColor = UIColor.white
        
        // Update Container View Properties
        if preferredStyle == .notification   {
            containerView?.layer.cornerRadius = 0.0
        }
        else if preferredStyle == .alert    {
            containerView?.layer.cornerRadius = 8.0
        }
        else if preferredStyle == .actionSheet   {
            containerView?.layer.cornerRadius = 6.0
        }
        
        // Add Tap Gesture Recognizer On View
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewDidTap))
        view.addGestureRecognizer(self.tapGesture)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Variables
        loadVariables()
        
        // Load Display Content
        loadDisplayContent()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update UI
        updateUI(withAnimation: false)
    }
    
    
    // MARK: - Helper Methods
    @objc public func addAction(_ action: CFAlertAction?) {
        
        if let action = action {
            
            // Check For Cancel Action. Every Alert must have maximum 1 Cancel Action.
            if action.style == .Cancel {
                for existingAction: CFAlertAction in actionList {
                    // This line of code added to just supress the warning (Unused Variable) at build time
                    //unused(existingAction)
                    // It means this alert already contains a Cancel action. Throw an Assert so developer understands the reason.
                    assert(existingAction.style != .Cancel, "ERROR : CFAlertViewController can only have one action with a style of CFAlertActionStyle.Cancel")
                }
            }
            // Add Action Into List
            actionList.append(action)
        }
        else {
            print("WARNING >>> CFAlertViewController received nil action to add. It must not be nil.")
        }
    }
    
    @objc public func dismissAlert(withAnimation animate: Bool, completion: (() -> Void)?) {
        dismissAlert(withAnimation: animate, isBackgroundTapped: false, completion: completion)
    }
    
    internal func dismissAlert(withAnimation animate: Bool, isBackgroundTapped: Bool, completion: (() -> Void)?) {
        
        // Dismiss Self
        self.dismiss(animated: animate, completion: {() -> Void in
            // Call Completion Block
            if let completion = completion {
                completion()
            }
            // Call Dismiss Block
            if let dismissHandler = self.dismissHandler {
                dismissHandler(isBackgroundTapped)
            }
        })
    }
    
    internal func setHeaderView(_ headerView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _headerView = headerView
        // Set Into Table Header View
        if let tableView = tableView    {
            tableView.tableHeaderView = self.headerView
            // Update Container View Frame If Requested
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    internal func setFooterView(_ footerView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _footerView = footerView
        // Set Into Table Footer View
        if let tableView = tableView    {
            tableView.tableFooterView = self.footerView
            // Update Container View Frame If Requested
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    internal func updateUI(withAnimation shouldAnimate: Bool) {
        // Refresh Preferred Style
        let currentPreferredStyle = preferredStyle
        preferredStyle = currentPreferredStyle
        // Update Table Header View
        setHeaderView(headerView, shouldUpdateContainerFrame: false, withAnimation: false)
        // Update Table Footer View
        setFooterView(footerView, shouldUpdateContainerFrame: false, withAnimation: false)
        // Reload Table Content
        tableView?.reloadData()
        // Update Background
        let currentBackgroundStyle = backgroundStyle
        backgroundStyle = currentBackgroundStyle
        // Update Container View Frame
        updateContainerViewFrame(withAnimation: shouldAnimate)
    }
    
    internal func updateContainerViewFrame(withAnimation shouldAnimate: Bool) {
        
        NSObject.runSynchronouslyOnMainQueueWithoutDeadlocking {

            if shouldAnimate {
                // Animate height changes
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {() -> Void in

                    // Update Container View Frame
                    self.updateContainerViewFrame()

                    // Relayout
                    self.view.layoutIfNeeded()

                }, completion: { _ in })
            }
            else {
        
                // Update Container View Frame
                self.updateContainerViewFrame()
            }
        }
    }
    
    internal func updateContainerViewFrame() {
        
        if let tableView = self.tableView   {
            
            // Update Content Size
            self.tableViewHeightConstraint?.constant = tableView.contentSize.height
            
            // Enable / Disable Bounce Effect
            if let containerView = self.containerView, tableView.contentSize.height <= containerView.frame.size.height {
                tableView.bounces = false
            }
            else {
                tableView.bounces = true
            }
        }
    }
    
    
    // MARK: - Handle Tap Events
    @objc internal func viewDidTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        // Get Tap Location
        let tapLocation: CGPoint = gestureRecognizer.location(in: self.view)
        
        if let containerView = self.containerView, containerView.frame.contains(tapLocation) {
            // Close Keyboard
            self.view.endEditing(true)
        }
        else if shouldDismissOnBackgroundTap {
            // Dismiss Alert
            dismissAlert(withAnimation: true, isBackgroundTapped: true, completion: {() -> Void in
                // Simulate Cancel Button
                for existingAction: CFAlertAction in self.actionList {
                    if existingAction.style == .Cancel {
                        // Call Action Handler
                        if let actionHandler = existingAction.handler {
                            actionHandler(existingAction)
                        }
                    }
                }
            })
        }
    }
    
    
    // MARK: - UIKeyboardWillShowNotification
    @objc internal func keyboardWillShow(_ notification: Notification) {
        
        let info: [AnyHashable: Any]? = notification.userInfo
        if let info = info  {
            if let kbRect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                if let viewRect = self.view.window?.convert(self.view.frame, from: self.view)   {
                    let intersectRect: CGRect = kbRect.intersection(viewRect)
                    if intersectRect.size.height > 0.0 {
                        
                        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
                            // Update Keyboard Height
                            self.keyboardHeight = intersectRect.size.height
                            self.view.layoutIfNeeded()
                        }, completion: { _ in })
                    }
                }
            }
        }
    }
    
    // MARK: UIKeyboardWillHideNotification
    @objc internal func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
            // Update Keyboard Height
            self.keyboardHeight = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in })
    }
    
    // MARK: UITextViewTextDidBeginEditingNotification | UITextFieldTextDidBeginEditingNotification
    @objc internal func textViewOrTextFieldDidBeginEditing(_ notification: Notification) {
        
        if let notificationObject = notification.object, (notificationObject is UITextField || notificationObject is UITextView) {
            
            DispatchQueue.main.async    {
                let view: UIView? = (notificationObject as? UIView)
                if let view = view  {
                    
                    // Keyboard becomes visible
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
                        // Get Location Of View inside Table View
                        let visibleRect: CGRect? = self.tableView?.convert(view.frame, from: view.superview)
                        // Scroll To Visible Rect
                        self.tableView?.scrollRectToVisible(visibleRect!, animated: false)
                    }, completion: { _ in })
                }
            }
        }
    }
    
    
    // MARK: - View Rotation / Size Change Method
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Code here will execute before the rotation begins.
        // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // Place code here to perform animations during the rotation.
            // You can pass nil or leave this block empty if not necessary.
            // Update UI
            self.updateUI(withAnimation: false)
        }, completion: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // Code here will execute after the rotation has finished.
            // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        })
    }
    
    
    // MARK: - Key Value Observers
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize") {
            // Update Container View Frame Without Animation
            updateContainerViewFrame(withAnimation: false)
        }
    }
    
    
    // MARK: - StatusBar Update Methods
    #if NS_EXTENSION_UNAVAILABLE_IOS
    override func prefersStatusBarHidden() -> Bool {
        return UIApplication.shared.statusBarHidden
    }
    #endif
    
    
    // MARK: - Dealloc
    deinit {
        
        // Remove KVO
        tableView?.removeObserver(self, forKeyPath: "contentSize")
        
        // Remove Dismiss Handler
        dismissHandler = nil
        
        print("Popup Dealloc")
    }
}


extension CFAlertViewController: UITableViewDataSource, UITableViewDelegate, CFAlertActionTableViewCellDelegate {
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            if let titleString = self.titleString, !titleString.isEmpty {
                return 1
            }
            if let messageString = self.messageString, !messageString.isEmpty  {
                return 1
            }
            
        case 1:
            return self.actionList.count
            
        default:
            break
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        switch indexPath.section {
            
        case 0:
            // Get Title Subtitle Cell Instance
            cell = tableView.dequeueReusableCell(withIdentifier: CFAlertTitleSubtitleTableViewCell.identifier())
            let titleSubtitleCell: CFAlertTitleSubtitleTableViewCell? = (cell as? CFAlertTitleSubtitleTableViewCell)
            // Set Content
            titleSubtitleCell?.setTitle(titleString, titleColor: titleColor, subtitle: messageString, subtitleColor: messageColor, alignment: textAlignment!)
            // Set Content Margin
            titleSubtitleCell?.contentTopMargin = 20.0
            if self.actionList.count <= 0 {
                titleSubtitleCell?.contentBottomMargin = 20.0
            }
            else {
                titleSubtitleCell?.contentBottomMargin = 0.0
            }
            
        case 1:
            // Get Action Cell Instance
            cell = tableView.dequeueReusableCell(withIdentifier: CFAlertActionTableViewCell.identifier())
            let actionCell: CFAlertActionTableViewCell? = (cell as? CFAlertActionTableViewCell)
            // Set Delegate
            actionCell?.delegate = self
            // Set Action
            actionCell?.action = self.actionList[indexPath.row]
            // Set Top Margin For First Action
            if indexPath.row == 0 {
                if let titleString = titleString, let messageString = messageString, (!titleString.isEmpty && !messageString.isEmpty)   {
                    actionCell?.actionButtonTopMargin = 20.0
                }
                else {
                    actionCell?.actionButtonTopMargin = 20.0
                }
            }
            // Set Bottom Margin For Last Action
            if indexPath.row == self.actionList.count - 1 {
                actionCell?.actionButtonBottomMargin = 20.0
            }
            else {
                actionCell?.actionButtonBottomMargin = 10.0
            }
            
        default:
            break
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect Table Cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: CFAlertActionTableViewCellDelegate
    public func alertActionCell(_ cell: CFAlertActionTableViewCell, didClickAction action: CFAlertAction?) {
        // Dimiss Self
        dismissAlert(withAnimation: true, completion: {() -> Void in
            // Call Action Handler If Set
            if let action = action, let actionHandler = action.handler {
                actionHandler(action)
            }
        })
    }
}


extension CFAlertViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: - Transitioning Delegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (presented is CFAlertViewController) {
            if self.preferredStyle == .notification {
                let transition = CFAlertViewControllerNotificationTransition()
                transition.transitionType = .present
                return transition
            }
            else if preferredStyle == .alert {
                let transition = CFAlertViewControllerPopupTransition()
                transition.transitionType = .present
                return transition
            }
            else if preferredStyle == .actionSheet {
                let transition = CFAlertViewControllerActionSheetTransition()
                transition.transitionType = .present
                return transition
            }
        }
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (dismissed is CFAlertViewController) {
            if self.preferredStyle == .notification {
                let transition = CFAlertViewControllerNotificationTransition()
                transition.transitionType = .dismiss
                return transition
            }
            else if self.preferredStyle == .alert {
                let transition = CFAlertViewControllerPopupTransition()
                transition.transitionType = .dismiss
                return transition
            }
            else if self.preferredStyle == .actionSheet {
                let transition = CFAlertViewControllerActionSheetTransition()
                transition.transitionType = .dismiss
                return transition
            }
        }
        return nil
    }
}


extension NSObject  {
    
    internal class func runSynchronouslyOnMainQueueWithoutDeadlocking(completion: () -> Swift.Void) {
        
        if Thread.isMainThread {
            completion()
        }
        else    {
            DispatchQueue.main.sync(execute: completion)
        }
    }
}


