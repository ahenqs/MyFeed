//
//  HomeController.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UITableViewController {
    
    var feeds: [Feed]? {
        didSet {
            tableView.reloadData()
        }
    }

    var service = WebserviceClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        loadData()
    }
    
    func setupUI() {
        
        self.title = "Feeds"
        
        let addItem = UIBarButtonItem(title: "New feed", style: .Plain, target: self, action: #selector(handleAdd(_:)))
        
        navigationItem.rightBarButtonItem = addItem
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }


    func loadData() {
        
        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "Feed")
            
            let sort = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
            
            fetchRequest.sortDescriptors = [sort]
            
            do {
                
                let feeds = try context.executeFetchRequest(fetchRequest) as! [Feed]
                
                self.feeds = feeds
            
            } catch let error as NSError {
                
                print(error.localizedDescription)
            }
        
        }
        
    }
    
    func handleAdd(sender: UIBarButtonItem) {
        
        showAddURLString()
        
    }
    
    func showAddURLString() {
        
        let alertController = UIAlertController(title: "New Feed", message: "Fill in with the RSS Feed URL:", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.borderStyle = .None
        }
        
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            
            if let textfield = alertController.textFields?.first {
                
                if !textfield.text!.isEmpty {
                    
                    self.searchFeed(textfield.text!)
                    
                } else {
                    self.showAlert(title: "Oops!", message: "A valid RSS Feed URL is required.", dismissText: "OK")
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func searchFeed(urlString: String) {
        
        let newURLString = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=1&q=\(urlString)"
        
        service.fetchFeed(newURLString) { (result) in
            
            switch result {
            case .Success(let feed):
                
                //add to database
                self.save(feed)
                
                break
            case .Failure(let error as NSError):
                
                print(error.localizedDescription)
                
                self.showAlert(title: "Oops!", message: "Invalid RSS Feed URL.", dismissText: "OK")
                
                break
            default: break
            }
            
        }
    }
    
    func save(feed: FeedSource) {
        
        print(feed.title, feed.feedDescription, feed.feedUrl)
        
        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let feedEntity = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: context) as! Feed
            
            feedEntity.feedUrl = feed.feedUrl
            feedEntity.title = feed.title
            feedEntity.link = feed.link
            feedEntity.author = feed.author
            feedEntity.feedDescription = feed.feedDescription
            feedEntity.type = feed.type

            do {
                try context.save()
                
                self.feeds?.append(feedEntity)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "HomeCell")

        let feed = feeds?[indexPath.row]
        
        cell.textLabel?.text = feed?.title
        cell.detailTextLabel?.text = feed?.feedDescription

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let feed = feeds?[indexPath.row]
        
        let feedController = FeedController(style: .Plain)
        feedController.feed = feed
        
        navigationController?.pushViewController(feedController, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let feed = feeds?[indexPath.row]
            
            if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
               
                context.deleteObject(feed!)
                
                do {
                    
                    try context.save()
                    
                    self.feeds?.removeAtIndex(indexPath.row)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
}
