//
//  Feed+CoreDataProperties.swift
//  MyFeed
//
//  Created by André Henrique da Silva on 22/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Feed {

    @NSManaged var feedUrl: String?
    @NSManaged var title: String?
    @NSManaged var link: String?
    @NSManaged var author: String?
    @NSManaged var feedDescription: String?
    @NSManaged var type: String?

}
