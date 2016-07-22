//
//  SafeJSONObject.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

class SafeJSONObject: NSObject {
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        let selectorString = "set\(key.uppercaseString.characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        
        if respondsToSelector(selector) {
            super.setValue(value, forKey: key)
        }
    }
}