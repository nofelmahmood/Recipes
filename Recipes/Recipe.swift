//
//  Recipe.swift
//  Recipes
//
//  Created by Nofel Mahmood on 24/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

class Recipe: NSManagedObject {
  
  // Insert code here to add functionality to your managed object subclass
  class var excludedKeysFromChangeTracking: [String] {
    return ["createdAt","id","lastSyncedAt","photoThumbnailURL","photoURL","updatedAt","isNew","changedKeys"]
  }
  
  class func insertNewRecipe(inManagedObjectContext context: NSManagedObjectContext) -> Recipe? {
    guard let recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: context) as? Recipe else {
      return nil
    }
    recipe.isNew = NSNumber(bool: true)
    let date = NSDate()
    recipe.createdAt = date
    recipe.updatedAt = date
    return recipe
  }
    
  class func insertNewRecipe(usingRecipeApiModel recipeApiModel: RecipeApiModel, inManagedObjectContext context: NSManagedObjectContext) -> Recipe? {
    guard let recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: context) as? Recipe else {
      return nil
    }
    recipe.id = recipeApiModel.id
    recipe.name = recipeApiModel.name
    recipe.instructions = recipeApiModel.instructions
    recipe.specification = recipeApiModel.specification
    recipe.favorite = recipeApiModel.favorite
    recipe.difficulty = recipeApiModel.difficulty
    recipe.photoURL = recipeApiModel.photo.url
    recipe.photoThumbnailURL = recipeApiModel.photo.thumbnail_url
    recipe.createdAt = recipeApiModel.created_at
    recipe.updatedAt = recipeApiModel.updated_at
    recipe.isNew = NSNumber(bool: false)
    return recipe
  }
  
  class func recipeWithObjectID(objectID: NSManagedObjectID, inContext context: NSManagedObjectContext) -> Recipe {
    return context.objectWithID(objectID) as! Recipe
  }
  
  class func all(inContext context: NSManagedObjectContext) -> [Recipe]? {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false),NSSortDescriptor(key: "createdAt", ascending: false)]
    let result = try? context.executeFetchRequest(fetchRequest)
    if let recipes = result as? [Recipe] {
      return recipes
    }
    return nil
  }
  
  class func allForView(inContext context: NSManagedObjectContext) -> [RecipeViewModel]? {
    return Recipe.all(inContext: context)?.map({ RecipeViewModel(withModel: $0) })
  }
  
  class func deleteAll(inContext context: NSManagedObjectContext) {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    if let result = try? context.executeFetchRequest(fetchRequest) {
      if let recipes = result as? [Recipe] {
        for recipe in recipes {
          guard let recipeID = recipe.id else {
            context.deleteObject(recipe)
            continue
          }
          _ = Tombstone.insertNewTombstone(forRecipeID: recipeID, inManagedObjectContext: context)
          context.deleteObject(recipe)
        }
        let _ = try? context.saveIfHasChanges()
      }
    }
  }
  
  class func recipes(withIDs ids: [NSNumber], inContext context: NSManagedObjectContext) -> [Recipe]? {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
    let result = try? context.executeFetchRequest(fetchRequest)
    if let recipes = result as? [Recipe] {
      return recipes
    }
    return nil
  }
  
  class func deleteRecipes(exceptWithIDs ids: [NSNumber], inContext context: NSManagedObjectContext) {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", ids)
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    _ = try? context.executeRequest(batchDeleteRequest)
  }
  
  class func newRecipesSinceLastSync(inContext context: NSManagedObjectContext) -> [Recipe]? {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    fetchRequest.predicate = NSPredicate(format: "isNew == %@", NSNumber(bool: true))
    let result = try? context.executeFetchRequest(fetchRequest)
    if let recipes = result as? [Recipe] {
      return recipes
    }
    return nil
  }
  
  class func deletedRecipeTombstoneEntriesSinceLastSync(inContext context: NSManagedObjectContext) -> [Tombstone]? {
    return Tombstone.all(inContext: context)
  }
  
  class func deleteRecipe(recipe: Recipe) -> Bool {
    if let recipeID = recipe.id, context = recipe.managedObjectContext {
      if let _ = Tombstone.insertNewTombstone(forRecipeID: recipeID, inManagedObjectContext: context) {
        context.deleteObject(recipe)
        return true
      } else {
        return false
      }
    }
    return true
  }
  
  func updateFromApiModel(apiModel: RecipeApiModel) {
    self.name = apiModel.name
    self.instructions = apiModel.instructions
    self.specification = apiModel.specification
    self.favorite = apiModel.favorite
    self.difficulty = apiModel.difficulty
    self.createdAt = apiModel.created_at
    self.updatedAt = apiModel.updated_at
    self.photoThumbnailURL = apiModel.photo.thumbnail_url
    self.photoURL = apiModel.photo.url
  }
  
  func recordChange() {
    if !self.objectID.temporaryID {
      let changedAttributeKeys = Array(self.changedValues().keys).filter {
        return !Recipe.excludedKeysFromChangeTracking.contains($0)
      }
      if changedAttributeKeys.count > 0 {
        if self.changedKeys != nil {
          let changedKeysString = self.changedKeys!.componentsSeparatedByString(",")
          let changedAttributeKeys = changedAttributeKeys.filter {
            return !changedKeysString.contains($0)
          }
          if changedAttributeKeys.count > 0 {
            self.changedKeys!.appendContentsOf(changedAttributeKeys.joinWithSeparator(","))
          }
        } else {
          self.changedKeys = changedAttributeKeys.joinWithSeparator(",")
        }
      }
    }
  }
}
