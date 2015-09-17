//
//  RecipeApiModel.swift
//  Recipes
//
//  Created by Nofel Mahmood on 13/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeApiModel: NSObject {
  
  var id: NSNumber?
  var name: String!
  var difficulty: NSNumber!
  var instructions: String?
  var specification: String?
  var favorite: NSNumber?
  var created_at: NSDate?
  var updated_at: NSDate?
  var photo: [String: String]?
  
  var url: String? {
    return self.photo?["url"]
  }
  
  var thumbnail_url: String? {
    return self.photo?["thumbnail_url"]
  }
  
  var photoData: NSData?
  
  var serverRepresentation: [String: AnyObject] {
    var representation = [String: AnyObject]()
    representation["name"] = self.name
    representation["difficulty"] = self.difficulty
    if let instructions = self.instructions {
      representation["instructions"] = instructions
    }
    if let specification = self.specification {
      representation["description"] = specification
    }
    if let favorite = self.favorite {
      representation["favorite"] = favorite
    }
    return representation
  }
  
  init(recipeKeyValue keyValue:[String: AnyObject]) {
    super.init()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = ApiDateFormatString
    for (key, value) in keyValue {
      if let _ = value as? NSNull {
        continue
      }
      if key == "description" {
        self.setValue(value, forKey: "specification")
      } else if respondsToSelector(NSSelectorFromString(key)) {
        if key == "created_at" || key == "updated_at" {
          if let dateValue = dateFormatter.dateFromString(value as! String) {
            self.setValue(dateValue, forKey: key)
          }
        } else {
          self.setValue(value, forKey: key)
        }
      }
    }
  }
  
  init(recipe: Recipe) {
    super.init()
    self.id = recipe.id
    self.name = recipe.name
    self.difficulty = recipe.difficulty
    self.instructions = recipe.instructions
    self.specification = recipe.specification
    self.favorite = recipe.favorite
    self.created_at = recipe.createdAt
    self.updated_at = recipe.updatedAt
    self.photoData = recipe.photo
  }
}
