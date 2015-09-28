//
//  Tombstone.swift
//  Recipes
//
//  Created by Nofel Mahmood on 24/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

class Tombstone: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  class func insertNewTombstone(forRecipeID recipeID: NSNumber, inManagedObjectContext context: NSManagedObjectContext) -> Tombstone? {
    guard let tombstone = NSEntityDescription.insertNewObjectForEntityForName("Tombstone", inManagedObjectContext: context) as? Tombstone else {
      return nil
    }
    tombstone.recordID = recipeID
    return tombstone
  }
  
  class func all(inContext context: NSManagedObjectContext) -> [Tombstone]? {
    let fetchRequest = NSFetchRequest(entityName: "Tombstone")
    let result = try? context.executeFetchRequest(fetchRequest)
    if let results = result as? [Tombstone] {
      return results
    }
    return nil
  }
}
