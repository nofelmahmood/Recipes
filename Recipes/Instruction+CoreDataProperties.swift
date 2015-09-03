//
//  Instruction+CoreDataProperties.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Instruction {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var recipe: Recipe?

}
