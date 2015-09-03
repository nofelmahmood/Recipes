//
//  RecipeStore.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
  case Get = "GET"
  case Post = "POST"
  case Delete = "DELETE"
}

enum HTTPHeader: String {
  case ContentType = "Content-Type"
  case Accept = "Accept"
  case Authorization = "Authorization"
}

enum ApiEndPoint: String {
  case Base = "http://hyper-recipes.herokuapp.com"
  case Recipes = "/recipes"
  case Users = "/users"
}


let ApiTokenKey = "~!@ApiTokenKey"
let ApiServerNameKey = "serverName"
let ApiDateFormatString = "YYYY'-'MM'-'DD'T'HH:mm:ss.SSS'Z'"

let RecipeEntityName = "Recipe"
let PhotoEntityName = "Photo"
let InstructionEntityName = "Instruction"

let RecipeInstructionsSeparator = ","

let RecipeEntityIDAttributeName = "id"
let RecipeEntityPhotoRelationshipName = "photo"
let RecipeEntityInstructionsRelationshipName = "instructions"

let InstructionEntityIDAttributeName = "id"
let InstructionEntityNameAttributeName = "name"

enum RecipeStoreError: ErrorType {
  case InvalidEntity
}

class RecipeStore: NSIncrementalStore
{
  var cache = [NSNumber: [String: AnyObject]]()
  
  class var type:String {
    return NSStringFromClass(self)
  }
  
  override class func initialize() {
    NSPersistentStoreCoordinator.registerStoreClass(self, forStoreType: self.type)
  }
  
  override func loadMetadata() throws {
    self.metadata=[
      NSStoreUUIDKey: NSProcessInfo().globallyUniqueString,
      NSStoreTypeKey: self.dynamicType.type
    ]
  }
  
  // MARK: Requests
  override func executeRequest(request: NSPersistentStoreRequest, withContext context: NSManagedObjectContext?) throws -> AnyObject {
    
    if let context = context {
      if request is NSFetchRequest {
        return self.executeInResponseToFetchRequest(request as! NSFetchRequest, withContext: context)
      } else if request is NSSaveChangesRequest {
        return self.executeInResponseToSaveChangesRequest(request as! NSSaveChangesRequest, withContext: context)
      }
    }
    return []
  }
  
  func executeInResponseToFetchRequest(request: NSFetchRequest, withContext context: NSManagedObjectContext) -> [NSManagedObject] {
    
    if let entityName = request.entityName where entityName == RecipeEntityName {
      let requestURL = NSURL(string: "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)")
      if let requestURL = requestURL {
        let urlRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.addValue("application/json", forHTTPHeaderField: HTTPHeader.ContentType.rawValue)
        urlRequest.addValue("application/json", forHTTPHeaderField: HTTPHeader.Accept.rawValue)
        let token = NSUserDefaults.standardUserDefaults().objectForKey(ApiTokenKey)
        urlRequest.addValue("Token token=\"\(token!)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
        var response: NSURLResponse?
        guard let data = try? NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response) else {
          return []
        }
        guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) else {
          return []
        }
        if let recipesKeyValues = json as? [[String: AnyObject]] {
          var fetchedObjects = [NSManagedObject]()
          for recipeKeyValue in recipesKeyValues {
            if let id = recipeKeyValue[RecipeEntityIDAttributeName] as? NSNumber {
              self.cache[id] = recipeKeyValue
              let managedObjectID = self.newObjectIDForEntity(request.entity!, referenceObject: id)
              let managedObject = context.objectWithID(managedObjectID)
              fetchedObjects.append(managedObject)
              self.keepInCacheByArrangingKeyValues(usingKeyValuesFromDictionary: recipeKeyValue)
            }
          }
          return fetchedObjects
        }
      }
    }
  
    return []
  }
  
  func executeInResponseToSaveChangesRequest(request: NSSaveChangesRequest, withContext context: NSManagedObjectContext) -> [NSManagedObjectContext] {
    
    return []
  }
  
  func keepInCacheByArrangingKeyValues(usingKeyValuesFromDictionary keyValueDictionary: [String: AnyObject]) {
    if let propertiesByServerName = self.persistentStoreCoordinator?.managedObjectModel.entitiesByName[RecipeEntityName]?.propertiesByServerName() {
      var cacheKeyValues = [String: NSObject]()
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = ApiDateFormatString
      dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
      for (key, value) in keyValueDictionary {
        if let propertyDescription = propertiesByServerName[key] {
          if let attributeDescription = propertyDescription as? NSAttributeDescription {
            switch(attributeDescription.attributeType) {
            case .DateAttributeType:
              if let date = dateFormatter.dateFromString(value as! String) {
                cacheKeyValues[key] = date
              }
            default:
              cacheKeyValues[key] = value as? NSObject
            }
            continue
          } else if let relationshipDescription = propertyDescription as? NSRelationshipDescription {
            if relationshipDescription.name == RecipeEntityInstructionsRelationshipName {
              if let separatedInstructions = (value as? String)?.componentsSeparatedByString(RecipeInstructionsSeparator) {
                var instructionsByID = [Int: String]()
                var startID = 1
                for instruction in separatedInstructions {
                  if instruction.isEmpty {
                    continue
                  }
                  instructionsByID[startID] = instruction
                  startID = startID + 1
                }
                cacheKeyValues[key] = instructionsByID
                continue
              }
            }
          }
          if let value = value as? NSObject {
            cacheKeyValues[key] = value
          }
        }
      }
      if let id = keyValueDictionary[RecipeEntityIDAttributeName] as? NSNumber {
        self.cache[id] = cacheKeyValues
      }
    }
  }
  
  // MARK: Faulting
  override func newValuesForObjectWithID(objectID: NSManagedObjectID, withContext context: NSManagedObjectContext) throws -> NSIncrementalStoreNode {
    
    if let entityName = objectID.entity.name {
      if entityName == RecipeEntityName {
        if let recipeID = self.referenceObjectForObjectID(objectID) as? NSNumber {
          if let cachedValue = self.cache[recipeID] {
            let propertiesByServerName = objectID.entity.propertiesByServerName()
            var incrementalStoreNodeValues = [String: AnyObject]()
            for (key,property) in propertiesByServerName {
              if property is NSAttributeDescription {
                if let valueForKey = cachedValue[key] {
                  incrementalStoreNodeValues[key] = valueForKey
                }
              } else if let relationshipDescription = property as? NSRelationshipDescription {
                if relationshipDescription.toMany {
                  continue
                }
                if let destinationEntity = relationshipDescription.destinationEntity, let id = cachedValue[RecipeEntityIDAttributeName] as? NSNumber {
                  let relationshipObjectID = self.newObjectIDForEntity(destinationEntity, referenceObject: id)
                  incrementalStoreNodeValues[key] = relationshipObjectID
                }
              }
            }
            return NSIncrementalStoreNode(objectID: objectID, withValues: incrementalStoreNodeValues, version: 0)
          }
        }
      } else if entityName == PhotoEntityName, let photoID = self.referenceObjectForObjectID(objectID) as? NSNumber {
        if let cachedValue = self.cache[photoID] {
          if let photoCachedValue = cachedValue[RecipeEntityPhotoRelationshipName] as? [String: AnyObject] {
            let attributesByServerName = objectID.entity.attributesByServerName()
            var incrementalStoreNodeValues = [String: AnyObject]()
            for (key, attributeDescription) in attributesByServerName {
              if let value = photoCachedValue[key] {
                incrementalStoreNodeValues[attributeDescription.name] = value
              }
            }
            return NSIncrementalStoreNode(objectID: objectID, withValues: incrementalStoreNodeValues, version: 0)
          }
        }
      } else if entityName == InstructionEntityName {
        if let referenceObject = (self.referenceObjectForObjectID(objectID) as? String)?.componentsSeparatedByString(RecipeInstructionsSeparator) {
          if  referenceObject.count == 2 {
            let recipeID = NSNumber(integer: (referenceObject[0] as NSString).integerValue)
            let instructionID = (referenceObject[1] as NSString).integerValue
            if let cachedValue = self.cache[recipeID] {
              if let instructions = cachedValue[RecipeEntityInstructionsRelationshipName] as? [Int: String] {
                var incrementalStoreNodeValues = [String: AnyObject]()
                incrementalStoreNodeValues[InstructionEntityNameAttributeName] = instructions[instructionID]
                incrementalStoreNodeValues[InstructionEntityIDAttributeName] = instructionID
                return NSIncrementalStoreNode(objectID: objectID, withValues: incrementalStoreNodeValues, version: 0)
              }
            }
          }
        }
      }
    }
    throw RecipeStoreError.InvalidEntity
  }
  
  override func newValueForRelationship(relationship: NSRelationshipDescription, forObjectWithID objectID: NSManagedObjectID, withContext context: NSManagedObjectContext?) throws -> AnyObject {
    
    if let entityName = relationship.destinationEntity?.name {
      if entityName == InstructionEntityName {
        if let recipeID = self.referenceObjectForObjectID(objectID) as? NSNumber {
          if let cachedValue = self.cache[recipeID] {
            if let instructionsValue = cachedValue[RecipeEntityInstructionsRelationshipName] as? [Int: String] {
              var objectIDs = [NSManagedObjectID]()
              for (key, _) in instructionsValue {
                let referenceObject = "\(recipeID.integerValue)\(RecipeInstructionsSeparator)\(key)"
                let objectID = self.newObjectIDForEntity(relationship.destinationEntity!, referenceObject: referenceObject)
                objectIDs.append(objectID)
              }
            }
          }
        }
      }
    }
    throw RecipeStoreError.InvalidEntity
  }
}
