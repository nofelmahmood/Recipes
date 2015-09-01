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

enum RecipeApiObjectAttributesMapping: String {
  
  case id = "id"
  case name = "name"
  case specification = "description"
  case instructions = "instructions"
  case favorite = "favorite"
  case difficulty = "difficulty"
  case createdAt = "created_at"
  case updatedAt = "updated_at"
  case photo = "photo"

}

enum PhotoApiObjectAttributesMapping: String {
  
  case photo_URL = "url"
  case photo_thumbnailURL = "thumbnail_url"
}

let ApiTokenKey = "~!@ApiTokenKey"
let ApiDateFormatString = "YYYY'-'MM'-'DD'T'HH:mm:ss.SSS'Z'"

let RecipeEntityName = "Recipe"
let PhotoEntityName = "Photo"




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
            let id = recipeKeyValue[RecipeApiObjectAttributesMapping.id.rawValue]
            if let id = id as? NSNumber {
              let managedObjectID = self.newObjectIDForEntity(request.entity!, referenceObject: id)
              let managedObject = context.objectWithID(managedObjectID)
              fetchedObjects.append(managedObject)
              self.cache[id] = recipeKeyValue
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
  
  // MARK: Faulting
  override func newValuesForObjectWithID(objectID: NSManagedObjectID, withContext context: NSManagedObjectContext) throws -> NSIncrementalStoreNode {
    
    if let referenceObject = self.referenceObjectForObjectID(objectID) as? NSNumber {
      if let cachedValue = self.cache[referenceObject] {
        var valuesByKeys = [String: AnyObject]()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = ApiDateFormatString
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        for (key, value) in cachedValue {
          if let attribute = RecipeApiObjectAttributesMapping(rawValue: key) {
            if attribute == RecipeApiObjectAttributesMapping.createdAt || attribute == RecipeApiObjectAttributesMapping.updatedAt {
              valuesByKeys["\(attribute)"] = dateFormatter.dateFromString(value as! String)
              continue
            }
            if attribute == RecipeApiObjectAttributesMapping.photo {
              let photoValues = value as! [String: String]
              valuesByKeys["\(PhotoApiObjectAttributesMapping.photo_URL)"] = photoValues[PhotoApiObjectAttributesMapping.photo_URL.rawValue]
              valuesByKeys["\(PhotoApiObjectAttributesMapping.photo_thumbnailURL)"] = photoValues[PhotoApiObjectAttributesMapping.photo_thumbnailURL.rawValue]
              continue
            }
            valuesByKeys["\(attribute)"] = value
          }
        }
        return NSIncrementalStoreNode(objectID: objectID, withValues: valuesByKeys, version: 0)
      }
    }
    return NSIncrementalStoreNode()
  }

}
