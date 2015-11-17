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
      removeInstructionView(withInstructionTextView: textView, shiftFocusToPrevious: true)
      return false
    }
    if text == "\n" {
      if textView.text.isEmpty {
        return false
      }
      if let instructionView = textView.superview?.superview?.superview as? RecipeInstructionView {
        if var index = instructionsStackView.arrangedSubviews.indexOf(instructionView) {
          index = index + 1
          if index < instructionsStackView.arrangedSubviews.count {
            addInstructionView("", focusOnTextView: true, atIndex: index)
          } else {
            addInstructionView("", focusOnTextView: true, atIndex: nil)
          }
        }
      }
      return false
    }
    return true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView.text.isEmpty {
      removeInstructionView(withInstructionTextView: textView, shiftFocusToPrevious: false)
    }
  }
}