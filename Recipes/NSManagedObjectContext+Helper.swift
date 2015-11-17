//
//  NSManagedObjectContext+Helper.swift
//  Recipes
//
//  Created by Nofel Mahmood on 28/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
  func saveIfHasChanges() throws {
    if hasChanges {
      try save()
    }
  }
}
