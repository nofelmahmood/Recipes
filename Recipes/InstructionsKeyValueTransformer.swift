//
//  InstructionKeyValueTransformer.swift
//  Recipes
//
//  Created by Nofel Mahmood on 04/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import Foundation

class InstructionsKeyValueTransformer: NSValueTransformer {
  
  override class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  override class func transformedValueClass() -> AnyClass {
    return AnyObject.self
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    guard let value = (value as? String)?.componentsSeparatedByString(RecipeInstructionsSeparator) else {
      return nil
    }
    var instructionNumber = 1
    var instructionsByNumber = [Int: String]()
    for instruction in value {
      if instruction.isEmpty {
        continue
      }
      instructionsByNumber[instructionNumber] = instruction
      instructionNumber = instructionNumber + 1
    }
    return instructionsByNumber
  }
  
  override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
    guard let value = value as? [Int: String] else {
      return nil
    }
    return value.sort {
      $0.0.0 < $0.1.0 }.map {
        return $0.1
      }.joinWithSeparator(RecipeInstructionsSeparator)
  }
}