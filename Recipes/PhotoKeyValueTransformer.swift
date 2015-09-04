//
//  PhotoKeyValueTransformer.swift
//  Recipes
//
//  Created by Nofel Mahmood on 04/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

class PhotoKeyValueTransformer: NSValueTransformer {
  
  var photoEntity: NSEntityDescription!
  
  init(photoEntity: NSEntityDescription) {
    super.init()
    self.photoEntity = photoEntity
  }
  override class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  override class func transformedValueClass() -> AnyClass {
    return AnyObject.self
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    guard let photoValues = value as? [String: AnyObject] else {
      return nil
    }
    let attributesByServerName = self.photoEntity.attributesByServerName
    var keyValue = [String: NSObject]()
    for (key, value) in photoValues {
      if let attributeDescription = attributesByServerName[key], let value = value as? String {
        keyValue[attributeDescription.name] = value
      }
    }
    return keyValue
  }
  
  override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
    guard let photoValues = value as? [String: NSObject] else {
      return nil
    }
    let attributesByName = self.photoEntity.attributesByName
    var keyValue = [String: NSObject]()
    for (key, value) in photoValues {
      if let serverName = attributesByName[key]?.serverName, let value = value as? String {
        keyValue[serverName] = value
      }
    }
    return keyValue
  }
}
