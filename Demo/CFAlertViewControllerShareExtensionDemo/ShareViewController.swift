//
//  ShareViewController.swift
//  CFAlertViewControllerShareExtensionDemo
//
//  Created by Shardul Patel on 06/09/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Application's Main Storyboard File
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // Present Demo View Controller
        let viewController = mainStoryBoard.instantiateInitialViewController()
        
        // Set Delegate
        if let navigationVC = viewController as? UINavigationController,
            let homeTableVC = navigationVC.visibleViewController as? HomeTableViewController
        {
            homeTableVC.delegate = self
        }
        
        DispatchQueue.main.async {
            self.present(viewController!, animated: true, completion: nil)
        }
    }
}


extension ShareViewController: HomeTableViewControllerDelegate  {
    
    public func homeTableViewControllerDidClose(_ viewController: HomeTableViewController!) {
        
        // Terminate Share Extension
        dismiss(animated: false, completion: nil)
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
