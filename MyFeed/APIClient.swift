//
//  ClientAPI.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 16/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

// MARK: Typealiases
public typealias JSON = [String: AnyObject]
typealias JSONCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask
typealias DataCompletion = (NSData?, NSHTTPURLResponse?, NSError?) -> Void

// MARK: Error handling

public let AHSNetworkingErrorDomain = "com.ahenqs.APIClient.NetworkingError"
public let MissingHTTPResponseError = 1
public let UnexpectedResponseError  = 2

// MARK: JSON handling
protocol JSONDecodable {
    init(JSON: JSON)
}

// MARK: Endpoint
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
}

extension Endpoint {
    
    var request: NSURLRequest {
        let components = NSURLComponents(string: baseURL)!
        components.path = path
        
        if let url = components.URL {
            return NSURLRequest(URL: url)
        } else {
            return NSURLRequest(URL: NSURL(string: "\(baseURL)/\(path)")!)
        }
    }
}

// MARK: Result
enum APIResult<T> {
    case Success(T)
    case Failure(ErrorType)
}

// MARK: API client
protocol APIClient {
    var configuration: NSURLSessionConfiguration { get }
    var session: NSURLSession { get }
    
    func JSONTaskWithRequest(request: NSURLRequest, completionHandler: JSONCompletion) -> JSONTask
    func fetch<T: JSONDecodable>(request: NSURLRequest, parse: JSON -> [T]?, completionHandler: APIResult<[T]> -> Void)
    func fetch<T: JSONDecodable>(request: NSURLRequest, parse: JSON -> T?, completionHandler: APIResult<T> -> Void)
}

extension APIClient {
    
    func JSONTaskWithRequest(request: NSURLRequest, completionHandler: JSONCompletion) -> JSONTask {
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard let HTTPResponse = response as? NSHTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response.", comment: "")]
                let error = NSError(domain: AHSNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? JSON
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("Received unhandled response with status code: \(HTTPResponse.statusCode)")
                }
            }
        }
        
        return task
    }
    
    func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completionHandler: APIResult<T> -> Void) {
        
        let task = JSONTaskWithRequest(request) { (json, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                guard let json = json else {
                    
                    if let error = error {
                        completionHandler(.Failure(error))
                    } else {
                        let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                        completionHandler(.Failure(error))
                    }
                    return
                }
                
                if let resource = parse(json) {
                    completionHandler(.Success(resource))
                } else {
                    let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completionHandler(.Failure(error))
                }
                
            })
        }
        
        task.resume()
    }
    
    func fetch<T: JSONDecodable>(request: NSURLRequest, parse: JSON -> [T]?, completionHandler: APIResult<[T]> -> Void) {
        
        let task = JSONTaskWithRequest(request) { (json, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                guard let json = json else {
                    
                    if let error = error {
                        completionHandler(.Failure(error))
                    } else {
                        let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                        completionHandler(.Failure(error))
                    }
                    return
                }
                
                if let resource = parse(json) {
                    completionHandler(.Success(resource))
                } else {
                    let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completionHandler(.Failure(error))
                }
                
            })
        }
        
        task.resume()
    }

}