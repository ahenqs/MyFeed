//
//  UIViewExtension.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
