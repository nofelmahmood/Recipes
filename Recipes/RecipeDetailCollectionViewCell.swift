//
//  RecipeDetailCollectionViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 12/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import QuartzCore

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
  
  private var recipe: RecipeViewModel!
  
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
          if instructionView is UILabel {
            instructionView.removeFromSuperview()
            continue
          }
          if let instructionView = instructionView as? RecipeInstructionView {
            instructionView.instructionTextView.editable = true
          }
        }
        if self.instructionsStackView.arrangedSubviews.count == 0 {
          self.addInstructionView("", focusOnTextView: false, atIndex: nil)
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
        if self.recipe != nil {
          self.recipe.photo({ image in
            if let image = image {
              NSOperationQueue.mainQueue().addOperationWithBlock({
                self.photoImageView.image = image
                self.backgroundImageView.image = image
              })
            }
          })
          if let recipeName = self.nameTextField.text {
            self.recipe.name = recipeName
          }
          if let recipeDescription = self.descriptionTextView.text {
            self.recipe.specification = recipeDescription
          }
          if let recipeInstructions = self.instructions() {
            self.recipe.instructions = recipeInstructions
          }
        }
        self.mainStackView.insertArrangedSubview(self.photoImageView, atIndex: 0)
        self.mainStackView.removeArrangedSubview(self.photoEditButton)
        self.photoEditButton.removeFromSuperview()
        self.descriptionTextView.editable = false
        for instructionView in self.instructionsStackView.arrangedSubviews {
          if let instructionView = instructionView as? RecipeInstructionView {
            instructionView.instructionTextView.editable = false
          }
        }
        if self.instructionsStackView.arrangedSubviews.count == 1 {
          if let instructionView = self.instructionsStackView.arrangedSubviews.first as? RecipeInstructionView {
            if instructionView.instructionTextView.text.isEmpty {
              instructionView.removeFromSuperview()
              self.addInstructionsPlaceholder()
            }
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
  var photoEditButtonDidPress: (() -> Void)?
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
    self.recipe = recipe
    self.nameTextField.text = recipe.name
    if let specification = recipe.specification {
      self.descriptionTextView.text = specification
    }
    if let instructions = recipe.instructions {
      for instruction in instructions {
        self.addInstructionView(instruction, focusOnTextView: false, atIndex: nil)
      }
      for instructionView in self.instructionsStackView.arrangedSubviews {
        if let instructionView = instructionView as? RecipeInstructionView {
          instructionView.instructionTextView.editable = false
        }
      }
    } else {
      self.addInstructionsPlaceholder()
    }
  }
  
  func addInstructionsPlaceholder() {
    let label = UILabel()
    label.text = "  Edit to add some steps to this recipe !"
    label.textColor = UIColor.darkGrayColor()
    label.font = UIFont(name: "Avenir", size: 18.0)
    label.numberOfLines = 0
    self.instructionsStackView.addArrangedSubview(label)
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
  
  func instructions() -> [String]? {
    guard self.instructionsStackView.arrangedSubviews.count > 0 else {
      return nil
    }
    var instructionsArray = [String]()
    for instructionView in self.instructionsStackView.arrangedSubviews {
      if let instructionView = instructionView as? RecipeInstructionView {
        instructionsArray.append(instructionView.instructionTextView.text)
      }
    }
    return instructionsArray
  }
  
  override func prepareForReuse() {
    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    self.photoEditButton.hidden = true
    self.editing = false
    for view in self.instructionsStackView.subviews {
      view.removeFromSuperview()
    }
  }
  
  @IBAction func photoEditButtonDidPress(sender: AnyObject) {
    self.photoEditButtonDidPress?()
  }
}
