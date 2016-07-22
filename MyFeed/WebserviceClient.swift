//
//  WebserviceClient.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 16/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

final class WebserviceClient: APIClient {
    let configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    init(configuration: NSURLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .defaultSessionConfiguration())
    }
    
    func fetchEntriesList(urlString: String, completionHandler: APIResult<[Entry]> -> Void) {
        
        let url = NSURL(string: urlString)!
        
        let request = NSURLRequest(URL: url)
        
        fetch(request, parse: { json -> [Entry]? in
            
            if let responseData = json["responseData"] {
                
                if let feed = responseData["feed"] {
                    
                    if let entries = feed!["entries"] as? [[String: AnyObject]] {
                        
                        var posts = [Entry]()
                        
                        for entryDict in entries {
                            let entry = Entry()
                            entry.setValuesForKeysWithDictionary(entryDict)
                            posts.append(entry)
                        }
                        
                        return posts
                        
                    } else {
                        return nil
                    }
                    
                } else {
                    return nil
                }
                
            } else {
                return nil
            }
            
            }, completionHandler: completionHandler)
    }
    
    func fetchFeed(urlString: String, completionHandler: APIResult<FeedSource> -> Void) {
        
        let url = NSURL(string: urlString)!
        
        let request = NSURLRequest(URL: url)
        
        fetch(request, parse: { json -> FeedSource? in
            
            if let responseData = json["responseData"] {
                
                if let feed = responseData["feed"] as? [String: AnyObject] {
                    
                    let feedSource = FeedSource()
                    
                    feedSource.setValuesForKeysWithDictionary(feed)
                    
                    return feedSource
                    
                } else {
                    return nil
                }
                
            } else {
                return nil
            }
            
            }, completionHandler: completionHandler)
        
    }
}