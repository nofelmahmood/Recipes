//
//  RecipeApi.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPHeader: String {
  case ContentType = "Content-Type"
  case Accept = "Accept"
  case Authorization = "Authorization"
}

struct ApiEndPoint {
  static let Base = "https://hyper-recipes.herokuapp.com"
  static let Recipes = "/recipes"
  static let Users = "/users"
}

let HTTPHeaderJSONTypeValue = "application/json"

let ApiDateFormatString = "YYYY'-'MM'-'DD'T'HH:mm:ss.SSS'Z'"

let ApiImageMimeType = "image/jpeg"

class RecipeApi: NSObject {
  
  static let sharedAPI = RecipeApi()
  
  let authorizationHeaderValue = "Token token=\"83163fd9411cb7b7303a\""
  
  override init() {
    super.init()
  }
  
  // MARK: Api Calls
  func recipes(completionBlock: ((recipes: [RecipeApiModel]?)->())?) {
    let urlString = ApiEndPoint.Base + ApiEndPoint.Recipes
    let headers = [HTTPHeader.ContentType.rawValue: HTTPHeaderJSONTypeValue, HTTPHeader.Accept.rawValue: HTTPHeaderJSONTypeValue, HTTPHeader.Authorization.rawValue: authorizationHeaderValue]
    Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers).responseJSON { _,_, result in
      if let jsonData = result.value as? [[String: AnyObject]] where result.isSuccess {
        var recipeApiModels = [RecipeApiModel]()
        for recipeKeyValue in jsonData {
          recipeApiModels.append(RecipeApiValueTransformer.modelValueFromKeyValue(recipeKeyValue))
        }
        completionBlock?(recipes: recipeApiModels)
      } else {
        completionBlock?(recipes: nil)
      }
    }
  }
  
  func save(recipe: RecipeApiModel, completionBlock: ((recipeApiModel: RecipeApiModel?) -> Void)?) {
    var urlString = ApiEndPoint.Base + ApiEndPoint.Recipes
    var httpMethod = Alamofire.Method.POST
    if let ID = recipe.id?.integerValue {
      urlString = "\(urlString)/\(ID)"
      httpMethod = Alamofire.Method.PUT
    }
    let serverRepresentation = RecipeApiValueTransformer.apiRepresentationFromApiModel(recipe)
    let headers = [HTTPHeader.Authorization.rawValue: authorizationHeaderValue]
    Alamofire.upload(httpMethod, urlString, headers: headers, multipartFormData: { (multipartFormData: MultipartFormData) -> Void in
      for (key,value) in serverRepresentation {
        if let value = value.description {
          multipartFormData.appendBodyPart(data: value.dataUsingEncoding(0)!, name: "recipe[\(key)]")
        }
      }
      if let photoData = recipe.photoData {
        multipartFormData.appendBodyPart(data: photoData, name: "recipe[photo]", fileName: "recipe_Photo", mimeType: ApiImageMimeType)
      }
      }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold, encodingCompletion: { encodingResult in
        switch(encodingResult) {
        case .Success(let request,_,_):
          request.responseJSON {
            request, response, result in
            switch result {
            case .Success(let JSON):
              if let recipeKeyValue = JSON as? [String: AnyObject] {
                let recipeApiModel = RecipeApiValueTransformer.modelValueFromKeyValue(recipeKeyValue)
                completionBlock?(recipeApiModel: recipeApiModel)
              }
            default:
              break
            }
            completionBlock?(recipeApiModel: nil)
          }
        case .Failure(_):
          completionBlock?(recipeApiModel: nil)
        }
    })
  }
  
  func delete(recipeID: Int, completionBlock: ((successful: Bool) -> Void)?) {
    let urlString = ApiEndPoint.Base + ApiEndPoint.Recipes + "/" + "\(recipeID)"
    let headers = [HTTPHeader.Authorization.rawValue: authorizationHeaderValue]
    Alamofire.request(.DELETE, urlString, parameters: nil, encoding: .URL, headers: headers).responseString { _,_, result  in
      completionBlock?(successful: result.isSuccess)
    }
  }
  
  func downloadPhotoFromURL(url: String, completion: ((image: UIImage?)->())?) {
    Alamofire.request(.GET, url).response { request, response, data, error in
      if let photoData = data {
        completion?(image: UIImage(data: photoData))
      } else {
        completion?(image: nil)
      }
    }
  }
  
}