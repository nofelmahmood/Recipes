//
//  Recipe+CoreDataProperties.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recipe {

    @NSManaged var id: NSNumber?
    @NSManaged var specification: String?
    @NSManaged var name: String?
    @NSManaged var difficulty: NSNumber?
    @NSManaged var instructions: String?
    @NSManaged var favorite: NSNumber?
    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var photo: Photo?

}
