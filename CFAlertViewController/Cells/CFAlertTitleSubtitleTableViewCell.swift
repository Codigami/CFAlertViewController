//
//  CFAlertTitleSubtitleTableViewCell.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/19/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc(CFAlertTitleSubtitleTableViewCell)
public class CFAlertTitleSubtitleTableViewCell: UITableViewCell {
    
    // MARK: - Declarations
    
    
    // MARK: - Variables
    // MARK: Public
    public static func identifier() -> String    {
        return String(describing: CFAlertTitleSubtitleTableViewCell.self)
    }
    @IBOutlet public var titleLabel: UILabel?
    @IBOutlet public var subtitleLabel: UILabel?
    public var contentTopMargin: CGFloat = 0.0 {
        didSet {
            // Update Constraint
            titleLabelTopConstraint?.constant = contentTopMargin - 8.0
            subtitleLabelTopConstraint?.constant = (titleLabelTopConstraint?.constant)!
            layoutIfNeeded()
        }
    }
    public var contentBottomMargin: CGFloat = 0.0 {
        didSet {
            // Update Constraint
            titleLabelBottomConstraint?.constant = contentBottomMargin - 8.0
            subtitleLabelBottomConstraint?.constant = (titleLabelBottomConstraint?.constant)!
            layoutIfNeeded()
        }
    }
    public var contentLeadingSpace: CGFloat = 0.0 {
        didSet {
            // Update Constraint Values
            titleLeadingSpaceConstraint?.constant = contentLeadingSpace - 8.0
            subtitleLeadingSpaceConstraint?.constant = (titleLeadingSpaceConstraint?.constant)!
            layoutIfNeeded()
        }
    }
    
    // MARK: Private
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleLeadingSpaceConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleLabelBottomConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleSubtitleVerticalSpacingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var subtitleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var subtitleLeadingSpaceConstraint: NSLayoutConstraint?
    @IBOutlet private weak var subtitleLabelBottomConstraint: NSLayoutConstraint?
    
    
    // MARK: Initialization Methods
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        basicInitialisation()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialization code
        basicInitialisation()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func basicInitialisation() {
        // Reset Text and Color
        setTitle(nil, titleColor: nil, subtitle: nil, subtitleColor: nil, alignment: .center)
        
        // Set Content Leading Space
        contentLeadingSpace = 20.0;
    }
    
    
    // MARK: - Layout Methods
    override public func layoutSubviews() {
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    
    // MARK: Helper Methods
    public func setTitle(_ title: String?, titleColor: UIColor?, subtitle: String?, subtitleColor: UIColor?, alignment: NSTextAlignment) {
        
        // Set Cell Text Fonts & Colors
        titleLabel?.text = title
        titleLabel?.textColor = titleColor
        titleLabel?.textAlignment = alignment
        subtitleLabel?.text = subtitle
        subtitleLabel?.textColor = subtitleColor
        subtitleLabel?.textAlignment = alignment
        
        // Update Constraints
        if let titleChars = titleLabel?.text?.characters, let subtitleChars = subtitleLabel?.text?.characters {
            if (titleChars.count <= 0 && subtitleChars.count <= 0) || subtitleChars.count <= 0 {
                titleLabelBottomConstraint?.isActive = true
                subtitleLabelTopConstraint?.isActive = false
                titleSubtitleVerticalSpacingConstraint?.constant = 0.0
            }
            else if titleChars.count <= 0 {
                titleLabelBottomConstraint?.isActive = false
                subtitleLabelTopConstraint?.isActive = true
                titleSubtitleVerticalSpacingConstraint?.constant = 0.0
            }
            else {
                titleLabelBottomConstraint?.isActive = false
                subtitleLabelTopConstraint?.isActive = false
                titleSubtitleVerticalSpacingConstraint?.constant = 5.0
            }
        }
    }
}
