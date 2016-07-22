//
//  Entry.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

class Entry: SafeJSONObject {
    
    var title: String?
    var link: String?
    var author: String?
    var publishedDate: String?
    var contentSnippet: String?
    var content: String?
    var categories: [String]?
}