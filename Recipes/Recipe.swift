//
//  RecipeModel.swift
//  Recipes
//
//  Created by Nofel Mahmood on 07/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

enum RecipeDifficulty: Int {
  case Easy = 1
  case Medium = 2
  case Hard = 3
}

class Recipe: NSObject {
  
  var difficulty: NSNumber = NSNumber(integer: 1)
  var favorite: Bool?
  var id: NSNumber?
  var name: String
  var specification: String?
  var instructions: [String]?
  var photoURL: String?
  var photoThumbnailURL: String?
  var photoData: NSData?
  
  private var fromRemote: Bool {
    if self.id != nil {
      return true
    }
    return false
  }
  
  private var serverRepresentation: [String: AnyObject] {
    var representation = [RecipeKey.Name.rawValue: self.name, RecipeKey.Difficulty.rawValue: self.difficulty]
    if let favorite = favorite {
      representation[RecipeKey.Favorite.rawValue] = favorite
    }
    if let description = self.specification {
      representation[RecipeKey.Description.rawValue] = description
    }
    if let instructions = self.instructions?.joinWithSeparator(",") {
      representation[RecipeKey.Instructions.rawValue] = instructions
    }
    
    return [RecipeKey.Recipe.rawValue: representation]
  }
  
  init(fillFromRemoteKeyValue keyValue:[String: AnyObject]) {
    self.name = ""
    super.init()
    self.fill(keyValue)
  }
  
  override init() {
    self.name = ""
    super.init()
  }
  
  func difficultyDescription() -> String? {
    switch(difficulty) {
    case RecipeDifficulty.Easy.rawValue:
      return "\(RecipeDifficulty.Easy)"
    case RecipeDifficulty.Medium.rawValue:
      return "\(RecipeDifficulty.Medium)"
    case RecipeDifficulty.Hard.rawValue:
      return "\(RecipeDifficulty.Hard)"
    default: break
    }
    return nil
  }
  
  func addInstruction(name: String){
    if self.instructions != nil {
      self.instructions?.append(name)
    } else {
      self.instructions = [name]
    }
  }
  
  private func fill(keyValue: [String: AnyObject]) {
    if let id = keyValue[RecipeKey.ID.rawValue] as? NSNumber {
      self.id = id
    }
    if let name = keyValue[RecipeKey.Name.rawValue] as? String {
      self.name = name
    }
    if let description = keyValue[RecipeKey.Description.rawValue] as? String {
      self.specification = description
    }
    if let instructions = (keyValue[RecipeKey.Instructions.rawValue] as? String)?.componentsSeparatedByString(",") {
      self.instructions = instructions
    }
    if let favorite = (keyValue[RecipeKey.Favorite.rawValue] as? NSNumber)?.boolValue {
      self.favorite = favorite
    }
    if let difficulty = keyValue[RecipeKey.Difficulty.rawValue] as? NSNumber {
      self.difficulty = difficulty
    }
    if let photo = keyValue[PhotoKey.Photo.rawValue] as? [String: String] {
      if let photoURL = photo[PhotoKey.URL.rawValue] {
        self.photoURL = photoURL
      }
      if let photoThumbnailURL = photo[PhotoKey.ThumbnailURL.rawValue] {
        self.photoThumbnailURL = photoThumbnailURL
      }
    }
  }
  
  func createOrUpdateOnRemote(completionBlock: ((successful: Bool)-> Void)?) {
    RecipeApi.sharedAPI.createOrUpdate(withRecipeID: self.id?.integerValue, usingRecipeParameters: self.serverRepresentation, photoData: self.photoData) { (successful) -> Void in
      completionBlock?(successful: successful)
    }
  }
  
  func deleteFromRemote(completionBlock: ((successful: Bool) -> Void)?) {
    if let id = self.id?.integerValue {
      RecipeApi.sharedAPI.delete(id, completionBlock: { (error) -> Void in
        if error == nil {
          completionBlock?(successful: true)
        } else {
          completionBlock?(successful: false)
        }
      })
    }
  }
  
}
