//
//  CFAlertAction.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 18/01/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc(CFAlertAction)
open class CFAlertAction: NSObject, NSCopying {

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
    public class func action(title: String?,
                             style: CFAlertActionStyle,
                             alignment: CFAlertActionAlignment,
                             backgroundColor: UIColor?,
                             textColor: UIColor?,
                             handler: CFAlertActionHandlerBlock?) -> CFAlertAction  {
        
        return CFAlertAction.init(title: title,
                                  style: style,
                                  alignment: alignment,
                                  backgroundColor: backgroundColor,
                                  textColor: textColor,
                                  handler: handler)
    }
    
    public convenience init(title: String?,
                            style: CFAlertActionStyle,
                            alignment: CFAlertActionAlignment,
                            backgroundColor: UIColor?,
                            textColor: UIColor?,
                            handler: CFAlertActionHandlerBlock?) {
        
        // Create New Instance Of Alert Controller
        self.init()
        
        // Set Alert Properties
        self.title = title
        self.style = style
        self.alignment = alignment
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.handler = handler
    }
    
    
    // MARK: - NSCopying
    public func copy(with zone: NSZone? = nil) -> Any {
        return CFAlertAction.init(title: title,
                                      style: style,
                                      alignment: alignment,
                                      backgroundColor: backgroundColor,
                                      textColor: textColor,
                                      handler: handler)
    }
}
