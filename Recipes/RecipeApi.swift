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
  case Base = "https://hyper-recipes.herokuapp.com"
  case Recipes = "/recipes"
  case Users = "/users"
}

let HTTPHeaderJSONTypeValue = "application/json"

let ApiToken = "780572e2326694c5a58c"
let ApiDateFormatString = "YYYY'-'MM'-'DD'T'HH:mm:ss.SSS'Z'"

let ApiImageMimeType = "image/jpeg"

let RecipeInstructionsSeparator = ","

enum RecipeKey: String {
  case Recipe = "recipe"
  case ID = "id"
  case Name = "name"
  case Difficulty = "difficulty"
  case Description = "description"
  case Instructions = "instructions"
  case Favorite = "favorite"
  case Photo = "recipe[photo]"
}

enum PhotoKey: String {
  case Photo = "photo"
  case URL = "url"
  case ThumbnailURL = "thumbnail_url"
}

class RecipeApi: NSObject {
  
  static let sharedAPI = RecipeApi()
  
  let manager = AFHTTPRequestOperationManager()
  
  override init() {
    super.init()
    manager.requestSerializer.setValue("Token token=\"\(ApiToken)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
  }
  
  // MARK: Api Calls
  func recipes(completionBlock: ((recipes: [Recipe]?)->())?) {
    let urlString = "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)"
    manager.requestSerializer.setValue(HTTPHeaderJSONTypeValue, forHTTPHeaderField: HTTPHeader.ContentType.rawValue)
    manager.requestSerializer.setValue(HTTPHeaderJSONTypeValue, forHTTPHeaderField: HTTPHeader.Accept.rawValue)
    manager.GET(urlString, parameters: nil, success: { (requestOperation, object) -> Void in
      if let jsonData = object as? [[String: AnyObject]] {
        var recipeModels = [Recipe]()
        for recipeKeyValue in jsonData {
          recipeModels.append(Recipe(fillFromRemoteKeyValue: recipeKeyValue))
        }
        completionBlock?(recipes: recipeModels)
      } else {
        completionBlock?(recipes: nil)
      }
      }) { (requestOperation, error) -> Void in
        completionBlock?(recipes: nil)
    }
  }
  
  func createOrUpdate(withRecipeID ID: Int?, usingRecipeParameters parameters: [String: AnyObject], photoData: NSData?, completionBlock: ((successful: Bool) -> Void)?) {
    let manager = AFHTTPRequestOperationManager()
    var url = "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)"
    var httpMethod = HTTPMethod.Post.rawValue
    if let ID = ID {
      url = "\(url)/\(ID)"
      httpMethod = HTTPMethod.Put.rawValue
    }
    var error: NSError?
    let urlRequest = manager.requestSerializer.multipartFormRequestWithMethod(httpMethod, URLString: url, parameters: parameters, constructingBodyWithBlock: { (data: AFMultipartFormData) -> Void in
      if let photoData = photoData {
        data.appendPartWithFileData(photoData, name: RecipeKey.Photo.rawValue, fileName: "recipe_Photo", mimeType: ApiImageMimeType)
      }
      }, error: &error)
    urlRequest.addValue("Token token=\"\(ApiToken)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        completionBlock?(successful: true)
      } else {
        completionBlock?(successful: false)
      }
    })
    dataTask.resume()
  }

  func delete(recipeID: Int, completionBlock: ((error: NSError?) -> Void)?) {
    let urlString = "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)/\(recipeID)"
    self.manager.DELETE(urlString, parameters: nil, success: { (requestOperation, responseObject) -> Void in
      completionBlock?(error: nil)
      }) { (requestOperation, error) -> Void in
        completionBlock?(error: error)
    }
  }
  
  // MARK: Helpers 
  func addAuthenticationTokenToRequestSerializer() {
    manager.requestSerializer.setValue("Token token=\"\(ApiToken)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
  }

}