//
//  EntryController.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit

class EntryController: UIViewController {
    
    var entry: Entry? {
        didSet {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: (entry?.link)!)!))
        }
    }
    
    let webView: UIWebView = {
        let webView = UIWebView()
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setupViews()
    }
    
    func setupUI() {
        self.title = entry?.title
    }
    
    func setupViews() {
        
        view.addSubview(webView)
        
        view.addConstraintWithFormat("H:|[v0]|", views: webView)
        view.addConstraintWithFormat("V:|[v0]|", views: webView)
        
    }

}
