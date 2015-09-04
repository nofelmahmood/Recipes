//
//  RecipeApiKeyValueTransformer.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

class RecipeKeyValueTransformer: NSValueTransformer {
  
  var recipeEntity: NSEntityDescription!
  var dateFormatter: NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = ApiDateFormatString
    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return dateFormatter
  }
  private var photoKeyValueTransformer: PhotoKeyValueTransformer? {
    guard let photoEntity = self.recipeEntity.relationshipsByName[RecipeEntityPhotoRelationshipName]?.destinationEntity else {
      return nil
    }
    return PhotoKeyValueTransformer(photoEntity: photoEntity)
  }
  private var instructionsKeyValueTransformer: InstructionsKeyValueTransformer? {
    return InstructionsKeyValueTransformer()
  }
  
  init(recipeEntity: NSEntityDescription) {
    super.init()
    self.recipeEntity = recipeEntity
  }
  
  override class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  override class func transformedValueClass() -> AnyClass {
    return AnyObject.self
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    if let keyValueDictionary = value as? [String: AnyObject] {
      var transformedKeyValue = [String: NSObject]()
      if let instructionsKeyValue = keyValueDictionary[RecipeEntityInstructionsRelationshipName] {
        if let instructionsTransformedKeyValue = self.instructionsKeyValueTransformer?.transformedValue(instructionsKeyValue) as? [Int: String] {
          transformedKeyValue[RecipeEntityInstructionsRelationshipName] = instructionsTransformedKeyValue
        }
      }
      if let photoKeyValue = keyValueDictionary[RecipeEntityPhotoRelationshipName] {
        if let photoTransformedValue = self.photoKeyValueTransformer?.transformedValue(photoKeyValue) as? [String: NSObject] {
          transformedKeyValue[RecipeEntityPhotoRelationshipName] = photoTransformedValue
        }
      }
      let attributesByName = self.recipeEntity.attributesByName
      for (key, value) in attributesByName {
        if let serverName = value.serverName {
          if let attributeValue = keyValueDictionary[serverName] as? String {
            if let attributeDateValue = self.dateFormatter.dateFromString(attributeValue) {
              transformedKeyValue[key] = attributeDateValue
            } else {
              transformedKeyValue[key] = attributeValue
            }
          } else if let attributeValue = keyValueDictionary[serverName] as? NSNumber {
            transformedKeyValue[key] = attributeValue
          }
        }
      }
      return transformedKeyValue
    }
    return nil
  }
  
  override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
    guard let keyValueDictionary = value as? [String: NSObject] else {
      return nil
    }
    var reverseTransformedValue = [String: AnyObject]()
    if let instructionsKeyValue = keyValueDictionary[RecipeEntityInstructionsRelationshipName] {
      if let instructionsReverseTransformedKeyValue = self.instructionsKeyValueTransformer?.reverseTransformedValue(instructionsKeyValue) as? String {
        reverseTransformedValue[RecipeEntityInstructionsRelationshipName] = instructionsReverseTransformedKeyValue
      }
    }
    if let photoKeyValue = keyValueDictionary[RecipeEntityPhotoRelationshipName] {
      if let photoReversedTransformedValue = self.photoKeyValueTransformer?.reverseTransformedValue(photoKeyValue) as? [String: NSObject] {
        reverseTransformedValue[RecipeEntityPhotoRelationshipName] = photoReversedTransformedValue
      }
    }
    let attributesByName = self.recipeEntity.attributesByName
    for (_, value) in attributesByName {
      if let serverName = value.serverName {
        if let attributeValue = keyValueDictionary[serverName] as? NSDate {
          let dateStringValue = self.dateFormatter.stringFromDate(attributeValue)
          reverseTransformedValue[serverName] = dateStringValue
        } else if let attributeValue = keyValueDictionary[serverName] as? String {
          reverseTransformedValue[serverName] = attributeValue
        } else if let attributeValue = keyValueDictionary[serverName] as? NSNumber {
          reverseTransformedValue[serverName] = attributeValue
        }
      }
    }
    return reverseTransformedValue
  }
}