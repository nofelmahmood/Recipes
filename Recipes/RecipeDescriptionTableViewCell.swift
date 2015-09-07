//
//  RecipeDescriptionTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

let RecipeDescriptionTextPlaceholder = "A little description about the recipe would look very nice !"

// MARK: UITextViewDelegate
extension RecipeDescriptionTableViewCell: UITextViewDelegate {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    if self.hasPlaceholder() {
      textView.text = ""
    }
    return true
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    self.didBecomeFirstResponder?()
  }
  
  func textViewDidChange(textView: UITextView) {
    self.recipe.specification = textView.text
    let size = textView.bounds.size
    let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
    if size.height != newSize.height {
      UIView.setAnimationsEnabled(false)
      tableView?.beginUpdates()
      tableView?.endUpdates()
      UIView.setAnimationsEnabled(true)
      if let indexPath = self.indexPath {
        tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
      }
    }
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if self.hasPlaceholder() {
      textView.text = RecipeDescriptionTextPlaceholder
    }
  }
}

class RecipeDescriptionTableViewCell: UITableViewCell {
  
  @IBOutlet var descriptionTextView: UITextView!
  private var recipe: Recipe!
  
  var didBecomeFirstResponder: (() -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.descriptionTextView.delegate = self
    self.descriptionTextView.editable = false
    self.descriptionTextView.selectable = false
  }
  
  func refreshCellUsingRecipe(recipe: Recipe) {
    self.recipe = recipe
    guard let recipeDescription = recipe.specification else {
      self.descriptionTextView.text = RecipeDescriptionTextPlaceholder
      return
    }
    if recipeDescription.isEmpty {
      self.descriptionTextView.text = RecipeDescriptionTextPlaceholder
    } else {
      self.descriptionTextView.text = recipeDescription
    }
  }
  
  func hasPlaceholder() -> Bool {
    guard let recipeDescription = self.recipe.specification else {
      return true
    }
    return recipeDescription.isEmpty
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    self.descriptionTextView.editable = editing
    if !editing {
      self.descriptionTextView.resignFirstResponder()
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.descriptionTextView.text = RecipeDescriptionTextPlaceholder
  }
  
}
