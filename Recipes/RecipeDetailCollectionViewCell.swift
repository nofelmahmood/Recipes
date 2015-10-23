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
      if let instructionViewController = self.instructionViewController(forTextView: textView) {
        if var index = self.instructionsStackView.arrangedSubviews.indexOf(instructionViewController.mainStackView) {
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
        for instructionViewController in self.instructionViewControllers {
          instructionViewController.instructionTextView.editable = true
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
        for instructionViewController in self.instructionViewControllers {
          instructionViewController.instructionTextView.editable = false
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
  
  var instructionViewControllers = [RecipeInstructionViewController]()
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
  
  func addInstructionView(instructionText: String, focusOnTextView:Bool, atIndex index: Int?) {
    let instructionViewController = self.storyboard.instantiateViewControllerWithIdentifier("RecipeInstructionViewController") as! RecipeInstructionViewController
    _ = instructionViewController.view
    self.instructionViewControllers.append(instructionViewController)
    instructionViewController.instructionTextView.delegate = self
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
      if let index = index {
        instructionViewController.setUpWithInstruction(instructionText, number: index)
        self.instructionsStackView.insertArrangedSubview(instructionViewController.mainStackView, atIndex: index)
      } else {
        self.instructionsStackView.addArrangedSubview(instructionViewController.mainStackView)
        instructionViewController.setUpWithInstruction(instructionText, number: self.instructionsStackView.arrangedSubviews.count)
      }
      }, completion: { completed in
        if focusOnTextView {
          instructionViewController.instructionTextView.becomeFirstResponder()
        }
    })
  }
  
  func removeInstructionView(withInstructionTextView textView: UITextView, shiftFocusToPrevious: Bool) {
    if let instructionViewController = self.instructionViewController(forTextView: textView) {
      let index = self.instructionsStackView.arrangedSubviews.indexOf(instructionViewController.mainStackView)
      self.instructionsStackView.removeArrangedSubview(instructionViewController.mainStackView)
      UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        instructionViewController.mainStackView.hidden = true
        }, completion: { completed in
          instructionViewController.mainStackView.removeFromSuperview()
          if shiftFocusToPrevious {
            if var index = index where self.instructionsStackView.arrangedSubviews.count != 0 {
              index = index - 1
              if index >= 0 {
                let mainStackView = self.instructionsStackView.arrangedSubviews[index] as! UIStackView
                if let previousInstructionViewController = self.instructionViewController(forMainStackView: mainStackView) {
                  previousInstructionViewController.instructionTextView.becomeFirstResponder()
                }
              }
            }
          }
      })
    }
  }
  
  func instructionViewController(forTextView textView: UITextView) -> RecipeInstructionViewController? {
    return self.instructionViewControllers.filter({ viewController in
      return viewController.instructionTextView == textView
    }).first
  }
  
  func instructionViewController(forMainStackView stackView: UIStackView) -> RecipeInstructionViewController? {
    return self.instructionViewControllers.filter({ viewController in
      return viewController.mainStackView == stackView
    }).first
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
