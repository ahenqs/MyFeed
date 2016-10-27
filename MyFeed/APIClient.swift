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
typealias JSONCompletion = (JSON?, HTTPURLResponse?, NSError?) -> Void
typealias JSONTask = URLSessionDataTask
typealias DataCompletion = (Data?, HTTPURLResponse?, NSError?) -> Void

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
    
    var request: URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = path
        
        if let url = components.url {
            return URLRequest(url: url)
        } else {
            return URLRequest(url: URL(string: "\(baseURL)/\(path)")!)
        }
    }
}

// MARK: Result
enum APIResult<T> {
    case success(T)
    case failure(Error)
}

// MARK: API client
protocol APIClient {
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWithRequest(_ request: URLRequest, completionHandler: @escaping JSONCompletion) -> JSONTask
    func fetch<T: JSONDecodable>(_ request: URLRequest, parse: @escaping (JSON) -> [T]?, completionHandler: @escaping (APIResult<[T]>) -> Void)
    func fetch<T: JSONDecodable>(_ request: URLRequest, parse: @escaping(JSON) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
}

extension APIClient {
    
    func JSONTaskWithRequest(_ request: URLRequest, completionHandler: @escaping JSONCompletion) -> JSONTask {
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response.", comment: "")]
                let error = NSError(domain: AHSNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error as NSError?)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? JSON
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("Received unhandled response with status code: \(HTTPResponse.statusCode)")
                }
            }
        }) 
        
        return task
    }
    
    func fetch<T>(_ request: URLRequest, parse: @escaping (JSON) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        
        let task = JSONTaskWithRequest(request) { (json, response, error) in
            
            DispatchQueue.main.async(execute: {
                
                guard let json = json else {
                    
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                        completionHandler(.failure(error))
                    }
                    return
                }
                
                if let resource = parse(json) {
                    completionHandler(.success(resource))
                } else {
                    let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completionHandler(.failure(error))
                }
                
            })
        }
        
        task.resume()
    }
    
    func fetch<T: JSONDecodable>(_ request: URLRequest, parse: @escaping (JSON) -> [T]?, completionHandler: @escaping (APIResult<[T]>) -> Void) {
        
        let task = JSONTaskWithRequest(request) { (json, response, error) in
            
            DispatchQueue.main.async(execute: {
                
                guard let json = json else {
                    
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                        completionHandler(.failure(error))
                    }
                    return
                }
                
                if let resource = parse(json) {
                    completionHandler(.success(resource))
                } else {
                    let error = NSError(domain: AHSNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completionHandler(.failure(error))
                }
                
            })
        }
        
        task.resume()
    }

}
