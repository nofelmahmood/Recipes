//
//  SyncManagerTests.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import XCTest
import CoreData
@testable import Recipes

class SyncManagerTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSyncManager() {
    let expectation = self.expectationWithDescription("SyncManager")
    SyncManager.sharedManager.perform({
      expectation.fulfill()
    })
  }
  
  func testPerformanceExample() {
    let expectation = self.expectationWithDescription("SyncManager.perform")
    self.waitForExpectationsWithTimeout(5.0, handler: nil)
    self.measureBlock {
      SyncManager.sharedManager.perform({
        expectation.fulfill()
      })
    }
  }
  
}
