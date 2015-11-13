//
//  RecipeViewModelTests.swift
//  Recipes
//
//  Created by Nofel Mahmood on 28/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import XCTest
import CoreData
@testable import Recipes

class RecipeViewModelTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testInitializationFromRecipeModel() {
    let recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: CoreDataStack.defaultStack.managedObjectContext) as? Recipe
    XCTAssertNotNil(RecipeViewModel(withModel: recipe!))
  }
  
  func testRecipeViewModel() {
    XCTAssertNotNil(Recipe.allForView(inContext: CoreDataStack.defaultStack.managedObjectContext))
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      // Put the code you want to measure the time of here.
    }
  }
  
}
