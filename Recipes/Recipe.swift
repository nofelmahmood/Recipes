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
  var instructions: NSMutableOrderedSet?
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
    var representation = ["name": self.name, "difficulty": self.difficulty]
    if let favorite = favorite {
      representation["favorite"] = favorite
    }
    if let description = self.specification {
      representation["description"] = description
    }
    if let instructions = (self.instructions?.array as? [String])?.joinWithSeparator(",") {
      representation["instructions"] = instructions
    }
    return ["recipe":representation]
  }
  
  init(fillFromRemoteKeyValue keyValue:[String: AnyObject]) {
    self.name = ""
    super.init()
    self.fill(keyValue)
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
      self.instructions!.addObject(name)
    }
  }
  
  private func fill(keyValue: [String: AnyObject]) {
    if let id = keyValue["id"] as? NSNumber {
      self.id = id
    }
    if let name = keyValue["name"] as? String {
      self.name = name
    }
    if let description = keyValue["description"] as? String {
      self.specification = description
    }
    if let instructions = (keyValue["instructions"] as? String)?.componentsSeparatedByString(",") {
      self.instructions = NSOrderedSet(array: instructions)
    }
    if let favorite = (keyValue["favorite"] as? NSNumber)?.boolValue {
      self.favorite = favorite
    }
    if let difficulty = keyValue["difficulty"] as? NSNumber {
      self.difficulty = difficulty
    }
    if let photo = keyValue["photo"] as? [String: String] {
      if let photoURL = photo["url"] {
        self.photoURL = photoURL
      }
      if let photoThumbnailURL = photo["thumbnail_url"] {
        self.photoThumbnailURL = photoThumbnailURL
      }
    }
  }
  
  func createOrUpdateOnRemote(completionBlock: ((successful: Bool)-> Void)?) {
    RecipeApi.sharedAPI.createOrUpdate(withRecipeID: self.id?.integerValue, usingRecipeParameters: self.serverRepresentation, photoData: self.photoData, completionBlock: { (error) -> Void in
      print("Saved")
      if error == nil {
        completionBlock?(successful: true)
      } else {
        completionBlock?(successful: false)
      }
    })
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
