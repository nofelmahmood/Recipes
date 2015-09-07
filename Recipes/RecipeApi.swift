//
//  RecipeApi.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case Get = "GET"
  case Post = "POST"
  case Delete = "DELETE"
  case Put = "PUT"
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

let HTTPHeaderJSONTypeValue = "application/json"

let ApiToken = "780572e2326694c5a58c"
let ApiDateFormatString = "YYYY'-'MM'-'DD'T'HH:mm:ss.SSS'Z'"

let RecipeInstructionsSeparator = ","

enum RecipeKey: String {
  case ID = "id"
  case Name = "name"
  case Difficulty = "difficulty"
  case Description = "description"
  case Instructions = "instructions"
  case Favorite = "favorite"
  case Photo = "recipe[photo]"
}

class RecipeApi: NSObject {
  
  static let sharedAPI = RecipeApi()
  
  let manager = AFHTTPRequestOperationManager()
  
  override init() {
    super.init()
    manager.requestSerializer.setValue("Token token=\"\(ApiToken)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
  }
  
  // MARK: Api Calls
  func recipes() -> [Recipe]? {
    let urlString = "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)"
    let URL = NSURL(string: urlString)
    if let URL = URL {
      let urlRequest = NSMutableURLRequest(URL: URL)
      urlRequest.addValue(HTTPHeaderJSONTypeValue, forHTTPHeaderField: HTTPHeader.ContentType.rawValue)
      urlRequest.addValue(HTTPHeaderJSONTypeValue, forHTTPHeaderField: HTTPHeader.Accept.rawValue)
      urlRequest.addValue("Token token=\"\(ApiToken)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
      var urlResponse: NSURLResponse?
      let data = try? NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &urlResponse)
      guard let jsonData = data else {
        return nil
      }
      guard let json = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)) else {
        return nil
      }
      if let recipesJson = json as? [[String: AnyObject]] {
        var recipeModels = [Recipe]()
        for recipeKeyValue in recipesJson {
          recipeModels.append(Recipe(fillFromRemoteKeyValue: recipeKeyValue))
        }
        return recipeModels
      }
      return nil
    }
    return nil
  }
  
  func createOrUpdate(withRecipeID ID: Int?, usingRecipeParameters parameters: [String: AnyObject], photoData: NSData?, completionBlock: ((error: NSError?) -> Void)?) {
    let manager = AFHTTPRequestOperationManager()
    var url = "\(ApiEndPoint.Base.rawValue)/\(ApiEndPoint.Recipes.rawValue)"
    if let ID = ID {
      url = "\(url)/\(ID)"
    }
    manager.POST( url, parameters: parameters,
      constructingBodyWithBlock: { (data: AFMultipartFormData!) in
        if let photoData = photoData, let name = parameters[RecipeKey.Name.rawValue] as? String {
          data.appendPartWithFileData(photoData, name: RecipeKey.Photo.rawValue, fileName: "\(name)", mimeType: "image/jpeg")
        }
      },
      success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
        completionBlock?(error: nil)
      },
      failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
        completionBlock?(error: error)
    })
  }
  
  func delete(recipeID: Int, completionBlock: ((error: NSError?) -> Void)?) {
    let urlString = "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)/\(recipeID)"
    self.manager.DELETE(urlString, parameters: nil, success: { (requestOperation, responseObject) -> Void in
      completionBlock?(error: nil)
      }) { (requestOperation, error) -> Void in
        completionBlock?(error: error)
    }
  }
}