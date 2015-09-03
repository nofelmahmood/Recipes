//
//  NSPropertyDescription+RecipeStore.swift
//  Recipes
//
//  Created by Nofel Mahmood on 03/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation
import CoreData

extension NSPropertyDescription {
  func serverName() -> String? {
    return self.userInfo?[ApiServerNameKey] as? String
  }
}