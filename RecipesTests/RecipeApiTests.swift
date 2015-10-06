//
//  RecipeApiTests.swift
//  Recipes
//
//  Created by Nofel Mahmood on 17/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import XCTest
import CoreData
@testable import Recipes

class RecipeApiTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testRecipeApiModelTuple() {
    typealias RecipeModel = (id:NSNumber, name:String, specification:String?, instructions:String?, difficulty:NSNumber, created_at:NSDate, updated_at:NSDate, photo:(url:String?, thumbnail_url: String?))
    let recipeModel: RecipeModel
    recipeModel.name = "Nofel"
    recipeModel.id = NSNumber(int: 12)
    recipeModel.specification = "Nofel"
    recipeModel.instructions = nil
    recipeModel.difficulty = NSNumber(int: 12)
    recipeModel.created_at = NSDate()
    recipeModel.updated_at = NSDate()
    recipeModel.photo.thumbnail_url = nil
    recipeModel.photo.url = nil
  }
  
  func testFetchingOfRecipes() {
    let expectation = expectationWithDescription("Recipes")
    RecipeApi.sharedAPI.recipes { recipes in
      XCTAssertNotNil(recipes)
      recipes?.forEach({ recipe in
        print(recipe.photo.url,recipe.photo.thumbnail_url)
      })
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func testSavingOfRecipe() {
    let expectation = expectationWithDescription("SaveRecipe")
    let recipeApiModel: RecipeApiModel
    recipeApiModel.id = nil
    recipeApiModel.specification = nil
    recipeApiModel.instructions = nil
    recipeApiModel.updated_at = nil
    recipeApiModel.created_at = nil
    recipeApiModel.favorite = nil
    recipeApiModel.photo.url = nil
    recipeApiModel.photo.thumbnail_url = nil
    recipeApiModel.name = "Test Recipe"
    recipeApiModel.difficulty = NSNumber(integer: 2)
    let image = UIImage(named: "ImagePlaceholder")
    let jpeg = UIImageJPEGRepresentation(image!, 1.0)
    recipeApiModel.photoData = jpeg!
    RecipeApi.sharedAPI.save(recipeApiModel) { recipeApiModel in
      if let recipeApiModel = recipeApiModel {
        print(recipeApiModel.id)
      }
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
}
