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
  
  func testFetchingOfRecipes() {
    let expectation = expectationWithDescription("Recipes")
    RecipeApi.sharedAPI.recipes { recipes in
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func testSavingOfRecipe() {
    let expectation = expectationWithDescription("SaveRecipe")
    let recipeApiModel = RecipeApiModel(recipeKeyValue: ["name":"TestRecipe","difficulty":NSNumber(integer: 2)])
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
