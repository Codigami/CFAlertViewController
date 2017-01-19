//
//  CFAlertTitleSubtitleTableViewCell.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/19/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

@objc class CFAlertTitleSubtitleTableViewCell: UITableViewCell {

    //MARK: Declarations
    public static let identifier = String(describing: CFAlertTitleSubtitleTableViewCell.self)
    
    
    // MARK: Variables
    public var contentTopMargin: CGFloat = 0.0 {
        didSet {
            setContentTopMargin(contentTopMargin: self.contentTopMargin)
        }
    }
    
    public var contentBottomMargin: CGFloat = 0.0 {
        didSet {
            setContentBottomMargin(contentBottomMargin: self.contentBottomMargin)
        }
    }
    
    public var contentLeadingSpace: CGFloat = 0.0 {
        didSet {
            setContentLeadingSpace(contentLeadingSpace: self.contentLeadingSpace)
        }
    }
    
    
    // MARK: Outlets
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var subtitleLabel: UILabel?
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var titleLeadingSpaceConstraint: NSLayoutConstraint?
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var titleSubtitleVerticalSpacingConstraint: NSLayoutConstraint?
    @IBOutlet weak var subtitleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var subtitleLeadingSpaceConstraint: NSLayoutConstraint?
    @IBOutlet weak var subtitleLabelBottomConstraint: NSLayoutConstraint?
    
    
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
    
    private func basicInitialisation() {
        // Reset Text
        setTitle(title: nil, subtitle: nil, alignment: .center)
        // Set Content Leading Space
        contentLeadingSpace = 20.0;
    }

    
    // MARK: Layout Methods
    override func layoutSubviews() {
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    
    // MARK: Setter Methods
    private func setContentTopMargin(contentTopMargin: CGFloat) {
        // Update Constraint
        self.titleLabelTopConstraint?.constant = self.contentTopMargin - 8.0
        self.subtitleLabelTopConstraint?.constant = (self.titleLabelTopConstraint?.constant)!
        self.layoutIfNeeded()
    }
    
    private func setContentBottomMargin(contentBottomMargin: CGFloat) {
        // Update Constraint
        self.titleLabelBottomConstraint?.constant = self.contentBottomMargin - 8.0
        self.subtitleLabelBottomConstraint?.constant = (self.titleLabelBottomConstraint?.constant)!
        self.layoutIfNeeded()
    }
    
    private func setContentLeadingSpace(contentLeadingSpace: CGFloat) {
        // Update Constraint Values
        self.titleLeadingSpaceConstraint?.constant = self.contentLeadingSpace - 8.0
        self.subtitleLeadingSpaceConstraint?.constant = (self.titleLeadingSpaceConstraint?.constant)!
        self.layoutIfNeeded()
    }
    
    
    // MARK: Helper Methods
    public func setTitle(title: String?, subtitle: String?, alignment: NSTextAlignment) {
        // Set Cell Text Fonts & Colors
        self.titleLabel?.text = title
        self.titleLabel?.textAlignment = alignment
        subtitleLabel?.text = subtitle
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
