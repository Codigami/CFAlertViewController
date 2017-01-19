//
//  CFAlertAction.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 18/01/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit


@objc(CFAlertAction)
class CFAlertAction: NSObject, NSCopying {

    // MARK: - Declarations
    public typealias CFAlertActionHandlerBlock = (_ action: CFAlertAction) -> ()
    
    
    // MARK: - Variables
    public var style: CFAlertActionStyle = .Default
    @objc public enum CFAlertActionStyle: Int {
        case Default
        case Cancel
        case Destructive
    }
    
    public var alignment: CFAlertActionAlignment = .Justified
    @objc public enum CFAlertActionAlignment: Int {
        case Justified
        case Right
        case Left
        case Center
    }
    
    public var title: String?
    public var color: UIColor?
    public var handler: CFAlertActionHandlerBlock?
    
    
    // MARK: - Initialisation Method
    convenience init(title: String?, style: CFAlertActionStyle, alignment: CFAlertActionAlignment, color: UIColor?, handler: CFAlertActionHandlerBlock?) {
        self.init()
        
        self.title = title
        self.style = style
        self.alignment = alignment
        self.color = color
        self.handler = handler
    }
    
    
    // MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy : CFAlertAction = CFAlertAction(title: title,
                                                 style: style,
                                                 alignment: alignment,
                                                 color: color,
                                                 handler: handler)
        return copy
    }
}
