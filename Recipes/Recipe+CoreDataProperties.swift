//
//  Recipe+CoreDataProperties.swift
//  Recipes
//
//  Created by Nofel Mahmood on 30/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recipe {
  
  @NSManaged var createdAt: NSDate?
  @NSManaged var difficulty: NSNumber?
  @NSManaged var favorite: NSNumber?
  @NSManaged var id: NSNumber?
  @NSManaged var instructions: String?
  @NSManaged var name: String?
  @NSManaged var specification: String?
  @NSManaged var updatedAt: NSDate?
  @NSManaged var photo_URL: String?
  @NSManaged var photo_thumbnailURL: String?
  @NSManaged var photo: NSData?
    
}
