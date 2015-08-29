//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var url: String?
    @NSManaged var thumbnailURL: String?
    @NSManaged var recipe: Recipe?

}
