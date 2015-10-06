//
//  RecipeApiModel.swift
//  Recipes
//
//  Created by Nofel Mahmood on 13/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation

typealias RecipeApiModel = (id:NSNumber?, name:String, specification:String?, instructions:String?, favorite: NSNumber?, difficulty:NSNumber, created_at:NSDate?, updated_at:NSDate?, photo:(url:String?, thumbnail_url: String?), photoData:NSData?)


class RecipeApiValueTransformer {
  
  class func modelValueFromRecipe(recipe: Recipe) -> RecipeApiModel {
    let recipeApiModel: RecipeApiModel
    recipeApiModel.id = recipe.id
    recipeApiModel.name = recipe.name!
    recipeApiModel.difficulty = recipe.difficulty!
    recipeApiModel.instructions = recipe.instructions
    recipeApiModel.specification = recipe.specification
    recipeApiModel.favorite = recipe.favorite
    recipeApiModel.created_at = recipe.createdAt
    recipeApiModel.updated_at = recipe.updatedAt
    recipeApiModel.photoData = recipe.photo
    recipeApiModel.photo.url = nil
    recipeApiModel.photo.thumbnail_url = nil
    return recipeApiModel
  }
  
  class func modelValueFromKeyValue(value: [String: AnyObject]) -> RecipeApiModel {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = ApiDateFormatString
    let recipeApiModel: RecipeApiModel
    recipeApiModel.id = value["id"] as? NSNumber
    recipeApiModel.name = value["name"] as! String
    recipeApiModel.specification = value["description"] as? String
    recipeApiModel.instructions = value["instructions"] as? String
    recipeApiModel.difficulty = value["difficulty"] as! NSNumber
    recipeApiModel.favorite = value["favorite"] as? NSNumber
    recipeApiModel.photo.url = value["photo"]!["url"] as? String
    recipeApiModel.photo.thumbnail_url = value["photo"]!["thumbnail_url"] as? String
    recipeApiModel.created_at = dateFormatter.dateFromString(value["created_at"] as! String)!
    recipeApiModel.updated_at = dateFormatter.dateFromString(value["updated_at"] as! String)!
    recipeApiModel.photoData = nil
    return recipeApiModel
  }
  
  class func apiRepresentationFromApiModel(value: RecipeApiModel) -> [String: AnyObject] {
    var recipeKeyValue = [String: AnyObject]()
    recipeKeyValue["name"] = value.name
    recipeKeyValue["difficulty"] = value.difficulty
    recipeKeyValue["description"] = value.specification
    recipeKeyValue["instructions"] = value.instructions
    recipeKeyValue["favorite"] = value.favorite
    return recipeKeyValue
  }
  
}

//class RecipesdaApiModel: NSObject {
//
//  private var recipeKeyValueDictionary: [String: AnyObject]!
//  private var dateFormatter: NSDateFormatter {
//    let formatter = NSDateFormatter()
//    formatter.dateFormat = ApiDateFormatString
//    return formatter
//  }
//
//  var id: NSNumber? {
//    get {
//      return self.recipeKeyValueDictionary["id"] as? NSNumber
//    } set {
//      self.recipeKeyValueDictionary["id"] = newValue
//    }
//  }
//
//  var name: String {
//    get {
//    return self.recipeKeyValueDictionary["name"] as! String
//    } set {
//      self.recipeKeyValueDictionary["name"] = newValue
//    }
//  }
//
//  var difficulty: NSNumber! {
//    get {
//    return self.recipeKeyValueDictionary["difficulty"] as! NSNumber
//    } set {
//      self.recipeKeyValueDictionary["difficulty"] = newValue
//    }
//  }
//
//  var instructions: String? {
//    get {
//    return self.recipeKeyValueDictionary["instructions"] as? String
//    } set {
//      self.recipeKeyValueDictionary["instructions"] = newValue
//    }
//  }
//
//  var specification: String? {
//    get {
//    return self.recipeKeyValueDictionary["description"] as? String
//    } set {
//      self.recipeKeyValueDictionary["description"] = newValue
//    }
//  }
//
//  var favorite: NSNumber? {
//    get {
//    return self.recipeKeyValueDictionary["favorite"] as? NSNumber
//    } set {
//      self.recipeKeyValueDictionary["favorite"] = newValue
//    }
//  }
//
//  var created_at: NSDate? {
//    get {
//      if let stringValue = self.recipeKeyValueDictionary["created_at"] as? String {
//        return self.dateFormatter.dateFromString(stringValue)
//      }
//      return nil
//    } set {
//      self.created_at = newValue
//    }
//  }
//
//  var updated_at: NSDate? {
//    get {
//      if let stringValue = self.recipeKeyValueDictionary["updated_at"] as? String {
//        return self.dateFormatter.dateFromString(stringValue)
//      }
//      return nil
//    } set {
//      self.updated_at = newValue
//    }
//  }
//
//  var url: String? {
//    if let photoKeyValue = self.recipeKeyValueDictionary["photo"] as? [String: AnyObject] {
//      return photoKeyValue["url"] as? String
//    }
//    return nil
//  }
//
//  var thumbnail_url: String? {
//    if let photoKeyValue = self.recipeKeyValueDictionary["photo"] as? [String: AnyObject] {
//      return photoKeyValue["thumbnail_url"] as? String
//    }
//    return nil
//  }
//
//  var photoData: NSData?
//
//  var serverRepresentation: [String: AnyObject] {
//    var representation = self.recipeKeyValueDictionary
//    representation["id"] = nil
//    representation["photo"] = nil
//    representation["created_at"] = nil
//    representation["updated_at"] = nil
//    return representation
//  }
//
//  init(recipeKeyValue keyValue:[String: AnyObject]) {
//    super.init()
//    self.recipeKeyValueDictionary = keyValue
//  }
//
//  class func fromRecipe(recipe: Recipe) -> RecipeApiModel {
//    let recipeApiModel = RecipeApiModel(recipe: recipe)
//    return recipeApiModel
//  }
//
//  init(recipe: Recipe) {
//    super.init()
//    self.id = recipe.id
//    self.name = recipe.name!
//    self.difficulty = recipe.difficulty
//    self.instructions = recipe.instructions
//    self.specification = recipe.specification
//    self.favorite = recipe.favorite
//    self.created_at = recipe.createdAt
//    self.updated_at = recipe.updatedAt
//    self.photoData = recipe.photo
//  }
//}
