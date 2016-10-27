//
//  SafeJSONObject.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

class SafeJSONObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
}
