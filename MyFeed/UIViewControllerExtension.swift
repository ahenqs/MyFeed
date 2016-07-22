//
//  UIViewControllerExtension.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title title: String, message: String, dismissText: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: dismissText, style: .Default, handler: nil)
        
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}