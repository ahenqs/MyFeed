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
                
            case .success(let entries):
                
                self.entries = entries
                
                break
            case .failure(let error as NSError):
                
                print(error.localizedDescription)
                
                break
            default: break
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FeedCell")

        let entry = entries?[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = entry?.title
        cell.detailTextLabel?.text = entry?.publishedDate

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entryController = EntryController()
        entryController.entry = entries?[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(entryController, animated: true)
    }
}
