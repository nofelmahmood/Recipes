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

