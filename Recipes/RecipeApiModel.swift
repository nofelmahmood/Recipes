//
//  RecipeApiModel.swift
//  Recipes
//
//  Created by Nofel Mahmood on 13/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation

class RecipeApiModel: NSObject {
  
  private var recipeKeyValueDictionary: [String: AnyObject]!
  private var dateFormatter: NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = ApiDateFormatString
    return formatter
  }
  
  var id: NSNumber? {
    get {
      return self.recipeKeyValueDictionary["id"] as? NSNumber
    } set {
      self.recipeKeyValueDictionary["id"] = newValue
    }
  }
  
  var name: String {
    get {
    return self.recipeKeyValueDictionary["name"] as! String
    } set {
      self.recipeKeyValueDictionary["name"] = newValue
    }
  }
  
  var difficulty: NSNumber! {
    get {
    return self.recipeKeyValueDictionary["difficulty"] as! NSNumber
    } set {
      self.recipeKeyValueDictionary["difficulty"] = newValue
    }
  }
  
  var instructions: String? {
    get {
    return self.recipeKeyValueDictionary["instructions"] as? String
    } set {
      self.recipeKeyValueDictionary["instructions"] = newValue
    }
  }
  
  var specification: String? {
    get {
    return self.recipeKeyValueDictionary["description"] as? String
    } set {
      self.recipeKeyValueDictionary["description"] = newValue
    }
  }
  
  var favorite: NSNumber? {
    get {
    return self.recipeKeyValueDictionary["favorite"] as? NSNumber
    } set {
      self.recipeKeyValueDictionary["favorite"] = newValue
    }
  }
  
  var created_at: NSDate? {
    get {
      if let stringValue = self.recipeKeyValueDictionary["created_at"] as? String {
        return self.dateFormatter.dateFromString(stringValue)
      }
      return nil
    } set {
      self.created_at = newValue
    }
  }
  
  var updated_at: NSDate? {
    get {
      if let stringValue = self.recipeKeyValueDictionary["updated_at"] as? String {
        return self.dateFormatter.dateFromString(stringValue)
      }
      return nil
    } set {
      self.updated_at = newValue
    }
  }
  
  var url: String? {
    if let photoKeyValue = self.recipeKeyValueDictionary["photo"] as? [String: AnyObject] {
      return photoKeyValue["url"] as? String
    }
    return nil
  }
  
  var thumbnail_url: String? {
    if let photoKeyValue = self.recipeKeyValueDictionary["photo"] as? [String: AnyObject] {
      return photoKeyValue["thumbnail_url"] as? String
    }
    return nil
  }
  
  var photoData: NSData?
  
  var serverRepresentation: [String: AnyObject] {
    var representation = self.recipeKeyValueDictionary
    representation["id"] = nil
    representation["photo"] = nil
    representation["created_at"] = nil
    representation["updated_at"] = nil
    return representation
  }
  
  init(recipeKeyValue keyValue:[String: AnyObject]) {
    super.init()
    self.recipeKeyValueDictionary = keyValue
  }
  
  class func fromRecipe(recipe: Recipe) -> RecipeApiModel {
    let recipeApiModel = RecipeApiModel(recipe: recipe)
    return recipeApiModel
  }
  
  init(recipe: Recipe) {
    super.init()
    self.id = recipe.id
    self.name = recipe.name!
    self.difficulty = recipe.difficulty
    self.instructions = recipe.instructions
    self.specification = recipe.specification
    self.favorite = recipe.favorite
    self.created_at = recipe.createdAt
    self.updated_at = recipe.updatedAt
    self.photoData = recipe.photo
  }
}
