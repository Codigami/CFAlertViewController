//
//  CFAlertAction.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 18/01/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc(CFAlertAction)
public class CFAlertAction: NSObject, NSCopying {

    // MARK: - Declarations
    public typealias CFAlertActionHandlerBlock = (_ action: CFAlertAction) -> ()
    
    @objc public enum CFAlertActionStyle: Int {
        case Default = 0
        case Cancel
        case Destructive
    }
    
    @objc public enum CFAlertActionAlignment: Int {
        case justified = 0
        case right
        case left
        case center
    }
    
    // MARK: - Variables
    public var title: String?
    public var style: CFAlertActionStyle = .Default
    public var alignment: CFAlertActionAlignment = .justified
    public var backgroundColor: UIColor?
    public var textColor: UIColor?
    public var handler: CFAlertActionHandlerBlock?
    
    
    // MARK: - Initialisation Method
    public class func action(title: String?, style: CFAlertActionStyle, alignment: CFAlertActionAlignment, backgroundColor: UIColor?, textColor: UIColor?, handler: CFAlertActionHandlerBlock?) -> CFAlertAction {
        
        let action = CFAlertAction.init()
        
        // Set Alert Properties
        action.title = title
        action.style = style
        action.alignment = alignment
        action.backgroundColor = backgroundColor
        action.textColor = textColor
        action.handler = handler
        
        return action
    }
    
    
    // MARK: - NSCopying
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = CFAlertAction.action(title: title,
                                        style: style,
                                        alignment: alignment,
                                        backgroundColor: backgroundColor,
                                        textColor: textColor,
                                        handler: handler)
        return copy
    }
}
