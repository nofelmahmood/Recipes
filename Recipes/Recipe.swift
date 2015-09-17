//
//  Recipe.swift
//  Recipes
//
//  Created by Nofel Mahmood on 15/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

class Recipe: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  class func insertNewRecipe(usingRecipeApiModel recipeApiModel: RecipeApiModel, inContext context: NSManagedObjectContext) -> Recipe? {
    if let recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: context) as? Recipe {
      recipe.id = recipeApiModel.id
      recipe.name = recipeApiModel.name
      recipe.difficulty = recipeApiModel.difficulty
      recipe.instructions = recipeApiModel.instructions
      recipe.favorite = recipeApiModel.favorite
      recipe.createdAt = recipeApiModel.created_at
      recipe.updatedAt = recipeApiModel.updated_at
      recipe.specification = recipeApiModel.specification
      recipe.photo = recipeApiModel.photoData
      recipe.photoURL = recipeApiModel.url
      recipe.photoThumbnailURL = recipeApiModel.thumbnail_url
      return recipe
    }
    return nil
  }
  
  class func recipesWithIDs(IDs: [NSNumber], inContext context: NSManagedObjectContext) -> [Recipe]? {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    fetchRequest.predicate = NSPredicate(format: "id IN %@", IDs)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    let result = try? context.executeFetchRequest(fetchRequest)
    if let result = result as? [Recipe] {
      return result
    }
    return nil
  }
  
  class func allRecipes(inContext context: NSManagedObjectContext) -> [Recipe]? {
    let fetchRequest = NSFetchRequest(entityName: "Recipe")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false),NSSortDescriptor(key: "createdAt", ascending: false)]
    if let result = try? context.executeFetchRequest(fetchRequest) as? [Recipe] {
      return result
    }
    return nil
  }
}
