//
//  CFAlertActionTableViewCell.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/19/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

@objc protocol CFAlertActionTableViewCellDelegate {
    func alertActionCell(cell: CFAlertActionTableViewCell, action: CFAlertAction);
}


@objc class CFAlertActionTableViewCell: UITableViewCell {
    
    // MARK: Declarations
    let CF_DEFAULT_ACTION_COLOR = UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(198.0 / 255.0), blue: CGFloat(77.0 / 255.0), alpha: CGFloat(1.0))
    let CF_CANCEL_ACTION_COLOR = UIColor(red: CGFloat(103.0 / 255.0), green: CGFloat(104.0 / 255.0), blue: CGFloat(217.0 / 255.0), alpha: CGFloat(1.0))
    let CF_DESTRUCTIVE_ACTION_COLOR = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(75.0 / 255.0), blue: CGFloat(75.0 / 255.0), alpha: CGFloat(1.0))
    public static let identifier = String(describing: CFAlertActionTableViewCell.self)
    
    @IBOutlet var actionButton: CFPushButton?
    @IBOutlet weak var actionButtonTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var actionButtonLeadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var actionButtonCenterXConstraint: NSLayoutConstraint?
    @IBOutlet weak var actionButtonTrailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var actionButtonBottomConstraint: NSLayoutConstraint?
    
    
    // MARK: Variables
    var actionButtonTopMargin: CGFloat = 0.0 {
        didSet {
            setActionButtonTopMargin(actionButtonTopMargin: actionButtonTopMargin)
        }
    }
    var action: CFAlertAction? {
        didSet {
            
            if let action = self.action    {
                setAction(action: action)
            }
        }
    }
    var actionButtonBottomMargin: CGFloat = 0.0 {
        didSet {
            setActionButtonTopMargin(actionButtonTopMargin: actionButtonBottomMargin)
        }
    }
    var delegate: CFAlertActionTableViewCellDelegate?
    
    
    // MARK: Initialization Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        basicInitialisation()
    }
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        basicInitialisation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func basicInitialisation() {
        // Set Action Button Properties
        actionButton?.layer.cornerRadius = 6.0
        actionButton?.pushTransformScaleFactor = 0.9
    }
    
    
    // MARK: Layout Methods
    
    override func layoutSubviews() {
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    
    // MARK: Setter Methods
    func setActionButtonTopMargin(actionButtonTopMargin: CGFloat) {
        // Update Constraint
        self.actionButtonTopConstraint?.constant = actionButtonTopMargin - 8.0
        self.layoutIfNeeded()
    }
    
    func setActionButtonBottomMargin(actionButtonBottomMargin: CGFloat) {
        // Update Constraint
        self.actionButtonBottomConstraint?.constant = actionButtonBottomMargin - 8.0
        self.layoutIfNeeded()
    }
    func setAction(action: CFAlertAction) {

        // Set Action Style
        var actionColor: UIColor? = action.color
        
        switch action.style {
            
        case .Cancel:
            if actionColor == nil {
                actionColor = CF_CANCEL_ACTION_COLOR
            }
            actionButton?.backgroundColor = UIColor.clear
            actionButton?.setTitleColor(actionColor, for: .normal)
            actionButton?.layer.borderColor = actionColor?.cgColor
            actionButton?.layer.borderWidth = 1.0
            
        case .Destructive:
            if actionColor == nil {
                actionColor = CF_DESTRUCTIVE_ACTION_COLOR
            }
            actionButton?.backgroundColor = actionColor
            actionButton?.setTitleColor(UIColor.white, for: .normal)
            actionButton?.layer.borderColor = nil
            actionButton?.layer.borderWidth = 0.0
            
        default:
            if actionColor == nil {
                actionColor = CF_DEFAULT_ACTION_COLOR
            }
            actionButton?.backgroundColor = actionColor
            actionButton?.setTitleColor(UIColor.white, for: .normal)
            actionButton?.layer.borderColor = nil
            actionButton?.layer.borderWidth = 0.0
        }
        
        
        //        // Set Alignment
        switch action.alignment {
            
        case .Right:
        // Right Align
        actionButtonLeadingConstraint?.priority = 749.0
        actionButtonCenterXConstraint?.isActive = false
        actionButtonTrailingConstraint?.priority = 751.0
        // Set Content Edge Inset
        actionButton?.contentEdgeInsets = UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0)
        case .Left:
        // Left Align
        actionButtonLeadingConstraint?.priority = 751.0
        actionButtonCenterXConstraint?.isActive = false
        actionButtonTrailingConstraint?.priority = 749.0
        // Set Content Edge Inset
        actionButton?.contentEdgeInsets = UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0)
        case .Center:
        // Center Align
        actionButtonLeadingConstraint?.priority = 750.0
        actionButtonCenterXConstraint?.isActive = true
        actionButtonTrailingConstraint?.priority = 750.0
        // Set Content Edge Inset
        actionButton?.contentEdgeInsets = UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0)
        default:
        // Justified Align
        actionButtonLeadingConstraint?.priority = 751.0
        actionButtonCenterXConstraint?.isActive = false
        actionButtonTrailingConstraint?.priority = 751.0
        // Set Content Edge Inset
        actionButton?.contentEdgeInsets = UIEdgeInsetsMake(15.0, 20.0, 15.0, 20.0)
        }
        
        // Set Title
        actionButton?.setTitle(self.action?.title, for: .normal)
    }
    
    // MARK: Button click events
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.alertActionCell(cell: self, action: self.action!)
        }
    }
    
}
