//
//  SyncManager.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

class SyncManager: NSObject {
  
  func perform(completion: (() -> Void)?) {
    RecipeApi.sharedAPI.recipes({ fetchedRecipes in
      if let fetchedRecipes = fetchedRecipes {
        let fetchedRecipesIDs = fetchedRecipes.map({ $0.id! })
        let mainContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        mainContext.parentContext = CoreDataStack.defaultStack.managedObjectContext
        let tombstoneEntries = Recipe.deletedRecipeTombstoneEntriesSinceLastSync(inContext: mainContext)
        self.deleteFromServer(tombstoneEntries)
        let newRecipes = Recipe.newRecipesSinceLastSync(inContext: mainContext)
        self.saveOnServer(newRecipes)
        Recipe.deleteRecipes(exceptWithIDs: fetchedRecipesIDs, inContext: mainContext)
        if let modifiedRecipes = Recipe.recipes(withIDs: fetchedRecipesIDs, inContext: mainContext) {
          var modifiedRecipesWithIDs = [NSNumber: Recipe]()
          modifiedRecipes.forEach({ recipe in
            modifiedRecipesWithIDs[recipe.id!] = recipe
          })
          for fetchedRecipe in fetchedRecipes {
            if let modifiedRecipe = modifiedRecipesWithIDs[fetchedRecipe.id!] {
              modifiedRecipe.updateFromApiModel(fetchedRecipe)
            } else {
              Recipe.insertNewRecipe(usingRecipeApiModel: fetchedRecipe, inManagedObjectContext: mainContext)
            }
          }
        }
        let _ = try? mainContext.save()
      }
      completion?()
    })
  }
  
  func saveOnServer(newRecipes: [Recipe]?) {
    guard let newRecipes = newRecipes else {
      return
    }
    for recipe in newRecipes {
      let recipeObjectID = recipe.objectID
      RecipeApi.sharedAPI.save(RecipeApiModel(recipe: recipe), completionBlock: { recipeApiModel in
        if let recipeApiModel = recipeApiModel {
          let saveContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
          saveContext.parentContext = CoreDataStack.defaultStack.managedObjectContext
          let currentRecipe = Recipe.recipeWithObjectID(recipeObjectID, inContext: saveContext)
          currentRecipe.id = recipeApiModel.id
          let _ = try? saveContext.save()
        }
      })
    }
  }
  
  func deleteFromServer(tombstoneEntries: [Tombstone]?) {
    guard let tombstoneEntries = tombstoneEntries else {
      return
    }
    for tombstone in tombstoneEntries {
      let tombstoneObjectID = tombstone.objectID
      RecipeApi.sharedAPI.delete(tombstone.recordID!.integerValue, completionBlock: { successful in
        if successful {
          let deleteContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
          deleteContext.parentContext = CoreDataStack.defaultStack.managedObjectContext
          deleteContext.deleteObject(deleteContext.objectWithID(tombstoneObjectID))
          let _ = try? deleteContext.save()
        }
      })
    }
  }
}
