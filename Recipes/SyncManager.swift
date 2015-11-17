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
  
  static let sharedManager = SyncManager()
  var managedObjectContext: NSManagedObjectContext!
  
  override init() {
    managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    managedObjectContext.parentContext = CoreDataStack.defaultStack.managedObjectContext
    super.init()
  }
  
  func perform(completion: (() -> Void)?) {
    RecipeApi.sharedAPI.recipes({ fetchedRecipes in
      if let fetchedRecipes = fetchedRecipes {
        let fetchedRecipesIDs = fetchedRecipes.map({ $0.id! })
        let mainContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        mainContext.parentContext = self.managedObjectContext
        let tombstoneEntries = Recipe.deletedRecipeTombstoneEntriesSinceLastSync(inContext: mainContext)
        self.deleteFromServer(tombstoneEntries)
        let newRecipes = Recipe.newRecipesSinceLastSync(inContext: mainContext)
        self.saveOnServer(newRecipes)
        Recipe.deleteRecipes(exceptWithIDs: fetchedRecipesIDs, inContext: mainContext)
        var modifiedRecipesWithIDs = [NSNumber: Recipe]()
        if let modifiedRecipes = Recipe.recipes(withIDs: fetchedRecipesIDs, inContext: mainContext) {
          var modifiedRecipesWithIDs = [NSNumber: Recipe]()
          modifiedRecipes.forEach({ recipe in
            modifiedRecipesWithIDs[recipe.id!] = recipe
          })
        }
        for fetchedRecipe in fetchedRecipes {
          if let modifiedRecipe = modifiedRecipesWithIDs[fetchedRecipe.id!] {
            if fetchedRecipe.updated_at!.compare(modifiedRecipe.updatedAt!) == NSComparisonResult.OrderedAscending {
              modifiedRecipe.updateFromApiModel(fetchedRecipe)
            } else {
              let recipeObjectID = modifiedRecipe.objectID
              RecipeApi.sharedAPI.save(RecipeApiValueTransformer.modelValueFromRecipe(modifiedRecipe), completionBlock: { recipeApiModel in
                if let recipeApiModel = recipeApiModel {
                  let saveContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
                  saveContext.parentContext = self.managedObjectContext
                  if let recipeToModify = saveContext.objectWithID(recipeObjectID) as? Recipe {
                    recipeToModify.updatedAt = recipeApiModel.updated_at
                    let _ = try? saveContext.saveIfHasChanges()
                  }
                }
              })
            }
          } else {
            Recipe.insertNewRecipe(usingRecipeApiModel: fetchedRecipe, inManagedObjectContext: mainContext)
          }
        }
        let _ = try? mainContext.saveIfHasChanges()
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({
        let _ = try? self.managedObjectContext.saveIfHasChanges()
      })
      completion?()
    })
  }
  
  func saveOnServer(newRecipes: [Recipe]?) {
    guard let newRecipes = newRecipes else {
      return
    }
    for recipe in newRecipes {
      let recipeObjectID = recipe.objectID
      RecipeApi.sharedAPI.save(RecipeApiValueTransformer.modelValueFromRecipe(recipe), completionBlock: {
        recipeApiModel in
        if let recipeApiModel = recipeApiModel {
          let saveContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
          saveContext.parentContext = self.managedObjectContext
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
          deleteContext.parentContext = self.managedObjectContext
          deleteContext.deleteObject(deleteContext.objectWithID(tombstoneObjectID))
          let _ = try? deleteContext.save()
        }
      })
    }
  }
}
