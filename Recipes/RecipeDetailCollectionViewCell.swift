//
//  RecipeDetailCollectionViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 12/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import QuartzCore

extension RecipeDetailCollectionViewCell: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    self.scrollViewDidScroll?(contentOffset: scrollView.contentOffset)
  }
}

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

class RecipeDetailCollectionViewCell: UICollectionViewCell {
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var photoImageViewAspectRatioConstraint: NSLayoutConstraint!
  @IBOutlet var photoEditButton: UIButton!
  @IBOutlet var photoEditButtonAspectRationConstraint: NSLayoutConstraint!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var mainStackView: UIStackView!
  @IBOutlet var instructionsStackView: UIStackView!
  
  var animateEditingChange = false
  var editing = false {
    didSet {
      if editing {
        self.nameTextField.userInteractionEnabled = true
        self.mainStackView.insertArrangedSubview(self.photoEditButton, atIndex: 0)
        self.mainStackView.removeArrangedSubview(self.photoImageView)
        self.photoImageView.removeFromSuperview()
        self.photoEditButton.hidden = false
        self.descriptionTextView.editable = true
        for instructionView in self.instructionsStackView.arrangedSubviews {
          if let instructionView = instructionView as? RecipeInstructionView {
            instructionView.instructionTextView.editable = true
          }
        }
        if self.animateEditingChange {
          UIView.animateWithDuration(1.0, animations: {
            self.mainStackView.layoutIfNeeded()
          })
        } else {
          self.mainStackView.layoutIfNeeded()
        }
      } else {
        self.nameTextField.userInteractionEnabled = false
        self.mainStackView.insertArrangedSubview(self.photoImageView, atIndex: 0)
        self.mainStackView.removeArrangedSubview(self.photoEditButton)
        self.photoEditButton.removeFromSuperview()
        self.descriptionTextView.editable = false
        for instructionView in self.instructionsStackView.arrangedSubviews {
          if let instructionView = instructionView as? RecipeInstructionView {
            instructionView.instructionTextView.editable = false
          }
        }
        if animateEditingChange {
          UIView.animateWithDuration(1.0, animations: {
            self.mainStackView.layoutIfNeeded()
          })
        } else {
          self.mainStackView.layoutIfNeeded()
        }
      }
    }
  }
  
  var scrollViewDidScroll: ((contentOffset: CGPoint) -> Void)?
  
  var storyboard: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
  
  override func awakeFromNib() {
    self.scrollView.delegate = self
    self.photoEditButton.hidden = true
    self.photoEditButton.layer.borderWidth = 1.0
    self.photoEditButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.editing = false
  }
  
  func configureCellWithRecipe(recipe: RecipeViewModel) {
    self.nameTextField.text = recipe.name
    if let specification = recipe.specification {
      self.descriptionTextView.text = specification
    }
    if let instructions = recipe.instructions {
      for instruction in instructions {
        self.addInstructionView(instruction, focusOnTextView: false, atIndex: nil)
      }
    }
  }
  
  func refreshInstructionsNumbering() {
    for instructionView in self.instructionsStackView.arrangedSubviews {
      if let instructionView = instructionView as? RecipeInstructionView {
        instructionView.numberLabel.text = "\((self.instructionsStackView.arrangedSubviews.indexOf(instructionView)!) + 1)"
      }
    }
  }
  
  func addInstructionView(instructionText: String, focusOnTextView: Bool, atIndex index: Int?) {
    if let instructionView = RecipeInstructionView.view {
      instructionView.instructionTextView.delegate = self
      UIView.animateWithDuration(0.5, animations: {
        if let index = index {
          instructionView.setUpWithInstruction(instructionText, number: index)
          self.instructionsStackView.insertArrangedSubview(instructionView, atIndex: index)
        } else {
          self.instructionsStackView.addArrangedSubview(instructionView)
          instructionView.setUpWithInstruction(instructionText, number: self.instructionsStackView.arrangedSubviews.count)
        }
        self.refreshInstructionsNumbering()
        }, completion: { completed in
          if focusOnTextView {
            instructionView.instructionTextView.becomeFirstResponder()
          }
      })
    }
  }
  
  func removeInstructionView(withInstructionTextView textView: UITextView, shiftFocusToPrevious: Bool) {
    if let instructionView = textView.superview?.superview?.superview as? RecipeInstructionView {
      let index = self.instructionsStackView.arrangedSubviews.indexOf(instructionView)
      self.instructionsStackView.removeArrangedSubview(instructionView)
      UIView.animateWithDuration(0.5, animations: {
        instructionView.hidden = true
        self.refreshInstructionsNumbering()
        }, completion: { completed in
          instructionView.removeFromSuperview()
          if shiftFocusToPrevious {
            if var index = index where self.instructionsStackView.arrangedSubviews.count != 0 {
              index = index - 1
              if index >= 0 {
                if let previousInstructionView = self.instructionsStackView.arrangedSubviews[index] as? RecipeInstructionView {
                  previousInstructionView.instructionTextView.becomeFirstResponder()
                }
              }
            }
          }
      })
    }
  }
  
  override func prepareForReuse() {
    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    self.photoEditButton.hidden = true
    self.editing = false
    for view in self.instructionsStackView.subviews {
      view.removeFromSuperview()
    }
  }
}
