//
//  InputPasswordHeaderView.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 9/5/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class InputPasswordHeaderView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK:- Initialisation Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func viewSetup() {
        let className = String(describing: InputPasswordHeaderView.self)
        let arrayOfViews = Bundle.main.loadNibNamed(className, owner: self, options: nil)
        
        if let view = arrayOfViews?.first as? UIView  {
            
            // Get First View
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = true
            
            // Clear Background Color
            backgroundColor = .white
            clipsToBounds = true
            
            // Add Subview
            addSubview(view)
        }
    }
}
