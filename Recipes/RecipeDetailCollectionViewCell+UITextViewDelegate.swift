//
//  RecipeDetailCollectionViewCell+UITextViewDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailCollectionViewCell: UITextViewDelegate {
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if range.length <= 1 && text.isEmpty && textView.text.isEmpty {
      self.removeInstructionView(withInstructionTextView: textView, shiftFocusToPrevious: true)
      return false
    }
    if text == "\n" {
      if textView.text.isEmpty {
        return false
      }
      if let instructionView = textView.superview?.superview?.superview as? RecipeInstructionView {
        if var index = self.instructionsStackView.arrangedSubviews.indexOf(instructionView) {
          index = index + 1
          if index < self.instructionsStackView.arrangedSubviews.count {
            self.addInstructionView("", focusOnTextView: true, atIndex: index)
          } else {
            self.addInstructionView("", focusOnTextView: true, atIndex: nil)
          }
        }
      }
      return false
    }
    return true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView.text.isEmpty {
      self.removeInstructionView(withInstructionTextView: textView, shiftFocusToPrevious: false)
    }
  }
}