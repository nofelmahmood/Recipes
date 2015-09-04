//
//  NSEntityDescription+Helpers.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

extension NSEntityDescription {
  
  var propertiesByServerName: [String: NSPropertyDescription] {
    var propertiesByServerName = [String: NSPropertyDescription]()
    for property in self.properties {
      if let propertyServerName = property.serverName {
        propertiesByServerName[propertyServerName] = property
      }
    }
    return propertiesByServerName
  }
  
  var attributesByServerName: [String: NSAttributeDescription] {
    var attributesByServerName = [String: NSAttributeDescription]()
    let propertiesByServerName = self.propertiesByServerName
    for (key, value) in propertiesByServerName {
      if value is NSAttributeDescription {
        attributesByServerName[key] = (value as! NSAttributeDescription)
      }
    }
    return attributesByServerName
  }
  
  var relationshipsByServerName: [String: NSRelationshipDescription] {
    var relationshipsByServerName = [String: NSRelationshipDescription]()
    let propertiesByServerName = self.propertiesByServerName
    for (key, value) in propertiesByServerName {
      if value is NSRelationshipDescription {
        relationshipsByServerName[key] = (value as! NSRelationshipDescription)
      }
    }
    return relationshipsByServerName
  }
}