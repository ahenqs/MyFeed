//
//  WebserviceClient.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 16/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

final class WebserviceClient: APIClient {
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetchEntriesList(_ urlString: String, completionHandler: @escaping (APIResult<[Entry]>) -> Void) {
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        
        fetch(request, parse: { json -> [Entry]? in
            
            if let responseData = json["responseData"] {
                
                if let feed = responseData["feed"] as? [String: AnyObject] {
                    
                    if let entries = feed["entries"] as? [[String: AnyObject]] {
                        
                        var posts = [Entry]()
                        
                        for entryDict in entries {
                            let entry = Entry()
                            entry.setValuesForKeys(entryDict)
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
    
    func fetchFeed(_ urlString: String, completionHandler: @escaping (APIResult<FeedSource>) -> Void) {
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        
        fetch(request, parse: { json -> FeedSource? in
            
            if let responseData = json["responseData"] {
                
                if let feed = responseData["feed"] as? [String: AnyObject] {
                    
                    let feedSource = FeedSource()
                    
                    feedSource.setValuesForKeys(feed)
                    
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
