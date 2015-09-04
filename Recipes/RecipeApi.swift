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

class RecipeApi: NSObject {
  
  // MARK: Api Calls
  class func fetchAllRecipes() -> [[String: AnyObject]]? {
    let requestURL = NSURL(string: "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)")
    if let requestURL = requestURL {
      let urlRequest = RecipeApi.urlRequestWithRequestURL(requestURL, httpMethod: HTTPMethod.Get)
      var response: NSURLResponse?
      guard let data = try? NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response) else {
        return nil
      }
      guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) else {
        return nil
      }
      return json as? [[String: AnyObject]]
    }
    return nil
  }
  
//  class func createRecipe(fromRecipeKeyValue recipe: [String: AnyObject]) {
//    let requestURL = NSURL(string: "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)")
//    if let requestURL = requestURL {
//      let urlRequest = RecipeApi.urlRequestWithRequestURL(requestURL, httpMethod: HTTPMethod.Post)
//    }
//  }
  
//  class func updateRecipe(fromRecipeKeyValue recipe: [String: AnyObject]) {
//    if let recipeID = recipe.id?.integerValue {
//      let requestURL = NSURL(string: "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)/\(recipeID))")
//      if let requestURL = requestURL {
//        let urlRequest = RecipeApi.urlRequestWithRequestURL(requestURL, httpMethod: HTTPMethod.Put)
//      }
//    }
//  }
  
  class func deleteRecipe(recipeID: Int, completionBlock: ((error: NSError?) -> Void)?) {
    let requestURL = NSURL(string: "\(ApiEndPoint.Base.rawValue)\(ApiEndPoint.Recipes.rawValue)/\(recipeID)")
    if let requestURL = requestURL {
      let urlRequest = RecipeApi.urlRequestWithRequestURL(requestURL, httpMethod: HTTPMethod.Delete)
      let session = NSURLSession.sharedSession()
      let dataTask = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
        print(response,data,error)
        completionBlock?(error: error)
      })
      dataTask.resume()
    }
  }
  
  // MARK: Helpers
  class func urlRequestWithRequestURL(url: NSURL, httpMethod: HTTPMethod) -> NSURLRequest {
    let urlRequest = NSMutableURLRequest(URL: url)
    urlRequest.addValue(HTTPHeaderJSONTypeValue, forHTTPHeaderField: HTTPHeader.ContentType.rawValue)
    urlRequest.addValue(HTTPHeaderJSONTypeValue, forHTTPHeaderField: HTTPHeader.Accept.rawValue)
    urlRequest.addValue("Token token=\"\(ApiToken)\"", forHTTPHeaderField: HTTPHeader.Authorization.rawValue)
    urlRequest.HTTPMethod = httpMethod.rawValue
    return urlRequest
  }
  
}