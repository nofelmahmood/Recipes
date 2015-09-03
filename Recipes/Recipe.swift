//
//  Recipe.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

enum RecipeDifficulty: Int {
  case Easy = 1
  case Medium = 2
  case Hard = 3
}
class Recipe: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  func difficultyDescription() -> String? {
    if let difficulty = self.difficulty?.integerValue {
      switch(difficulty) {
      case RecipeDifficulty.Easy.rawValue:
        return "\(RecipeDifficulty.Easy)"
      case RecipeDifficulty.Medium.rawValue:
        return "\(RecipeDifficulty.Medium)"
      case RecipeDifficulty.Hard.rawValue:
        return "\(RecipeDifficulty.Hard)"
      default:
        return nil
      }
    }
    return nil
  }
}
