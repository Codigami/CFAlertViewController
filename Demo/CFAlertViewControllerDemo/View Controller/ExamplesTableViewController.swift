//
//  ExamplesTableViewController.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 8/31/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//

import UIKit

class ExamplesTableViewController: UIViewController {

    enum SimpleExampleType: Int {
        case simpleExample1
        case simpleExample2
        case simpleExample3
        case simpleExample4
    }
    
    enum AdvancedExampleType: Int {
        case advancedExample1
        case advancedExample2
        case advancedExample3
        case advancedExample4
        case advancedExample5
        case advancedExample6
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: Constants
    let alertTitle = "Title of the message"
    let alertBodyText = "Add message body here. If the text exceeds a certain limit then the alert will automatically become scrollable."
    let defaultActionTitle = "Action #1"
    let defaultActionTitle2 = "Action #2"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cells
        let nib = UINib(nibName: ExampleTableViewCell.reuseIdentifier(), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: ExampleTableViewCell.reuseIdentifier())
        
        navigationItem.title = "Examples"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    deinit {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: Table view delegate and data source methods
extension ExamplesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Simple Use Cases"
        case 1:
            return "Creative Use Cases"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExampleTableViewCell.reuseIdentifier()) as? ExampleTableViewCell
        if indexPath.section == 0 {
            if let exampleType = SimpleExampleType.init(rawValue: indexPath.row) {
                cell?.exampleNameLabel.text = cellTextForSimpleExampleType(exampleType: exampleType)
            }
        }
        else {
            if let exampleType = AdvancedExampleType.init(rawValue: indexPath.row) {
                cell?.exampleNameLabel.text = cellTextForAdvancedExampleType(exampleType: exampleType)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if let exampleType = SimpleExampleType.init(rawValue: indexPath.row) {
                showAlertForSimpleExampleType(exampleType: exampleType)
            }
        }
        else {
            if let exampleType = AdvancedExampleType.init(rawValue: indexPath.row) {
                showAlertForAdvancedExampleType(exampleType: exampleType)
            }
        }
    }
}


// MARK: Private helper methods
extension ExamplesTableViewController {
    
    private func cellTextForSimpleExampleType(exampleType: SimpleExampleType) -> String {
        
        switch exampleType {
        case .simpleExample1:
            return "Basic"
        case .simpleExample2:
            return "Multiple Actions"
        case .simpleExample3:
            return "Custom Header"
        case .simpleExample4:
            return "Custom Footer"
        }
    }
    
    private func cellTextForAdvancedExampleType(exampleType: AdvancedExampleType) -> String {
        
        switch exampleType {
        case .advancedExample1:
            return "Custom Background"
        case .advancedExample2:
            return "Airpods Action Sheet"
        case .advancedExample3:
            return "Error Notification"
        case .advancedExample4:
            return "App Rating Alert"
        case .advancedExample5:
            return "App Intro Alert"
        case .advancedExample6:
            return "Secure Password Popup"
        }
    }
    
    private func showAlertForSimpleExampleType(exampleType: SimpleExampleType) {
        
        let selectedControlIndex = segmentedControl.selectedSegmentIndex
        
        switch exampleType {
            
        // Single Action
        case .simpleExample1:
            let alert = CFAlertViewController.alertController(title: alertTitle, titleColor: .black, message: alertBodyText, messageColor: .black, textAlignment: .left, preferredStyle: styleForSelectedIndex(index: selectedControlIndex), headerView: nil, footerView: nil, didDismissAlertHandler: nil)
            let defaultAction = CFAlertAction.action(title: defaultActionTitle, style: .Default, alignment: .right, backgroundColor: .green, textColor: .white, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
        // Multiple Actions
        case .simpleExample2:
            let alert = CFAlertViewController.alertController(title: alertTitle, titleColor: .black, message: alertBodyText, messageColor: .black, textAlignment: .left, preferredStyle: styleForSelectedIndex(index: selectedControlIndex), headerView: nil, footerView: nil, didDismissAlertHandler: nil)
            let defaultAction = CFAlertAction.action(title: defaultActionTitle, style: .Default, alignment: .right, backgroundColor: .green, textColor: .white, handler: nil)
            let destructiveAction = CFAlertAction.action(title: defaultActionTitle, style: .Default, alignment: .right, backgroundColor: .red, textColor: .white, handler: nil)
            alert.addAction(defaultAction)
            alert.addAction(destructiveAction)
            self.present(alert, animated: true, completion: nil)
            
        // Custom Header
        case .simpleExample3:
            let headerView = UIImageView.init(image: UIImage.init(named: "header_image"))
            headerView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 70)
            headerView.contentMode = .bottom
            headerView.clipsToBounds = true
            let alert = CFAlertViewController.alertController(title: alertTitle, titleColor: .black, message: alertBodyText, messageColor: .black, textAlignment: .left, preferredStyle: styleForSelectedIndex(index: selectedControlIndex), headerView: headerView, footerView: nil, didDismissAlertHandler: nil)
            self.present(alert, animated: true, completion: nil)
         
        // Custom Footer
        case .simpleExample4:
            let footerView = UIImageView.init(image: UIImage.init(named: "header_image"))
            footerView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 70)
            footerView.contentMode = .top
            footerView.clipsToBounds = true
            let alert = CFAlertViewController.alertController(title: alertTitle, titleColor: .black, message: alertBodyText, messageColor: .black, textAlignment: .left, preferredStyle: styleForSelectedIndex(index: selectedControlIndex), headerView: nil, footerView: footerView, didDismissAlertHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showAlertForAdvancedExampleType(exampleType: AdvancedExampleType) {
        
        switch exampleType {
        
        // Custom Alert background
        case .advancedExample1:
            let alert = CFAlertViewController.alertController(title: alertTitle, titleColor: .black, message: alertBodyText, messageColor: .black, textAlignment: .center, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
            alert.backgroundStyle = .blur
            alert.backgroundColor = UIColor.black.withAlphaComponent(0.10)
            alert.containerView?.backgroundColor = .clear
            self.present(alert, animated: true, completion: nil)
        
        // Airpods Bottom Sheet Style
        case .advancedExample2:
            let headerView = UIImageView.init(image: UIImage.init(named: "airpods_image"))
            headerView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 260)
            headerView.contentMode = .bottom
            headerView.clipsToBounds = true
            let alert = CFAlertViewController.alertController(title: "Airpods", titleColor: .black, message: nil, messageColor: .black, textAlignment: .center, preferredStyle: .actionSheet, headerView: headerView, footerView: nil, didDismissAlertHandler: nil)
            let connectAction = CFAlertAction.action(title: "Connect", style: .Default, alignment: .center, backgroundColor: UIColor.black.withAlphaComponent(0.14), textColor: .black, handler: nil)
            alert.addAction(connectAction)
            self.present(alert, animated: true, completion: nil)
            
        case .advancedExample4:
            break

        default:
            break
        }
        
        
    }
    
    private func styleForSelectedIndex(index: Int) -> CFAlertViewController.CFAlertControllerStyle {
        
        switch index {
        case 0:
            return .alert
        case 1:
            return .actionSheet
        case 2:
            return .notification
        default:
            return .alert
        }
    }
    
    
    
    
}
