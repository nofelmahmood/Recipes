//
//  RecipeModel.swift
//  Recipes
//
//  Created by Nofel Mahmood on 07/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import CoreData

struct RecipeDifficulty {
  static let Easy = "Easy"
  static let Medium = "Medium"
  static let Hard = "Hard"
}

let RecipeInstructionsSeparator = ","

class RecipeViewModel: NSObject {
  
  private var recipe: Recipe!
  
  var id: NSNumber? {
    get {
      return recipe.id
    } set {
      recipe.id = newValue
    }
  }
  
  var name: String {
    get {
      return recipe.name!
    } set {
      recipe.name = newValue
    }
  }
  
  var specification: String? {
    get {
      return recipe.specification
    } set {
      recipe.specification = newValue
    }
  }
  
  var instructions: [String]? {
    get {
      if let separatedInstructions = recipe.instructions?.componentsSeparatedByString(RecipeInstructionsSeparator) {
        if separatedInstructions.count != 0 && separatedInstructions.first!.isEmpty == false {
          return separatedInstructions
        }
      }
      return nil
    } set {
      recipe.instructions = newValue?.joinWithSeparator(RecipeInstructionsSeparator)
    }
  }
  
  var favorite: Bool? {
    get {
      return recipe.favorite?.boolValue
    } set {
      if let newValue = newValue {
        recipe.favorite = NSNumber(bool: newValue)
      } else {
        recipe.favorite = nil
      }
    }
  }
  
  var difficulty: String {
    get {
      switch(recipe.difficulty!.integerValue) {
      case 1:
        return RecipeDifficulty.Easy
      case 2:
        return RecipeDifficulty.Medium
      case 3:
        return RecipeDifficulty.Hard
      default:
        break
      }
      return RecipeDifficulty.Easy
    } set {
      switch(newValue) {
      case RecipeDifficulty.Easy:
        recipe.difficulty = NSNumber(integer: 1)
      case RecipeDifficulty.Medium:
        recipe.difficulty = NSNumber(integer: 2)
      case RecipeDifficulty.Hard:
        recipe.difficulty = NSNumber(integer: 3)
      default: break
      }
    }
  }
  
  var photo: UIImage? {
    get {
      if let photoData = recipe.photo {
        return UIImage(data: photoData)
      }
      return nil
    } set {
      if let image = newValue {
        recipe.photo = UIImageJPEGRepresentation(image, 1.0)
      } else {
        recipe.photo = nil
      }
    }
  }
  
  var photoURL: NSURL? {
    if let photoURLString = recipe.photoURL {
      if let photoURL = NSURL(string: photoURLString) {
        return photoURL
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
  
  var photoThumbnailURL: NSURL? {
    if let thumbnailURLString = recipe.photoThumbnailURL {
      if let thumbnailURL = NSURL(string: thumbnailURLString) {
        return thumbnailURL
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
  
  class func allRecipes(inContext context: NSManagedObjectContext) -> [RecipeViewModel]? {
    return Recipe.all(inContext: context)?.map { recipe in
      return RecipeViewModel(withModel: recipe)
    }
  }
  
  // Pass instance of Recipe to initiate. Pass nil to initiate with a new instance of Recipe type.
  init(withModel recipeModel: Recipe?) {
    super.init()
    if let recipe = recipeModel {
      self.recipe = recipe
    } else {
      recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: CoreDataStack.defaultStack.managedObjectContext) as? Recipe
      recipe.createdAt = NSDate()
      try! CoreDataStack.defaultStack.managedObjectContext.save()
    }
  }
  
  func deleteUnderlyingRecipe() -> Bool {
    return Recipe.deleteRecipe(recipe)
  }
  
  func photo(completionBlock: ((image: UIImage?) -> Void)) {
    if let photo = recipe.photo {
      completionBlock(image: UIImage(data: photo))
      return
    } else if let thumbnailURL = recipe.photoThumbnailURL {
      RecipeApi.sharedAPI.downloadPhotoFromURL(thumbnailURL, completion: { image in
        completionBlock(image: image)
        if let image = image {
          NSOperationQueue.mainQueue().addOperationWithBlock {
            self.recipe.photo = UIImageJPEGRepresentation(image, 1.0)
          }
        }
      })
    }
  }
  
  func save() {
    if CoreDataStack.defaultStack.managedObjectContext.hasChanges {
      recipe.updatedAt = NSDate()
      try! CoreDataStack.defaultStack.managedObjectContext.save()
    }
  }
}
