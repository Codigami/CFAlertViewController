//
//  ExampleTableViewCell.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 9/1/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell {

    @IBOutlet weak var exampleNameLabel: UILabel!
    
    static func reuseIdentifier() -> String {
        return "ExampleTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
