//
//  Recipe+CoreDataProperties.swift
//  Recipes
//
//  Created by Nofel Mahmood on 05/09/2015.
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
    @NSManaged var name: String?
    @NSManaged var specification: String?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var instructions: NSSet?
    @NSManaged var photo: Photo?

}
