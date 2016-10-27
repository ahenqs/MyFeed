//
//  FeedSource.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

class FeedSource: SafeJSONObject {
    
    var feedUrl: String?
    var title: String?
    var link: String?
    var author: String?
    var feedDescription: String?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "description" {
            
            super.setValue(value, forKey: "feedDescription")
            
        } else {
            super.setValue(value, forKey: key)
        }
        
    }
}
