//
//  FeedController.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit

class FeedController: UITableViewController {
    
    var service = WebserviceClient()
    
    var feed: Feed?
    
    var entries: [Entry]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        startService()
    }
    
    func setupUI() {
        self.title = feed!.title
    }
    
    func startService() {
        
        let newURLString = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=20&q=\(feed!.feedUrl!)"
        
        service.fetchEntriesList(newURLString) { (result) in
            
            switch result {
                
            case .Success(let entries):
                
                self.entries = entries
                
                break
            case .Failure(let error as NSError):
                
                print(error.localizedDescription)
                
                break
            default: break
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "FeedCell")

        let entry = entries?[indexPath.row]
        
        cell.textLabel?.text = entry?.title
        cell.detailTextLabel?.text = entry?.publishedDate

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let entryController = EntryController()
        entryController.entry = entries?[indexPath.row]
        
        navigationController?.pushViewController(entryController, animated: true)
    }
}
