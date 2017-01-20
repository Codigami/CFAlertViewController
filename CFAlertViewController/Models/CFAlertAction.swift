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
    public var color: UIColor?
    public var handler: CFAlertActionHandlerBlock?
    
    
    // MARK: - Initialisation Method
    convenience init(title: String?, style: CFAlertActionStyle, alignment: CFAlertActionAlignment, color: UIColor?, handler: CFAlertActionHandlerBlock?) {
        self.init()
        
        // Set Properties
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
