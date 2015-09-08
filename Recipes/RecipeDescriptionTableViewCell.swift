//
//  RecipeDescriptionTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

let RecipeDescriptionTextPlaceholder = "A little description here would look very nice !"

// MARK: UITextViewDelegate
extension RecipeDescriptionTableViewCell: UITextViewDelegate {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    if textView.text == RecipeDescriptionTextPlaceholder {
      textView.text = ""
    }
    return true
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    self.didBecomeFirstResponder?()
  }
  
  func textViewDidChange(textView: UITextView) {
    self.descriptionDidChange?(description: textView.text)
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
    if textView.text.isEmpty {
      textView.text = RecipeDescriptionTextPlaceholder
    }
  }
}

// MARK: -
class RecipeDescriptionTableViewCell: UITableViewCell {
  
  @IBOutlet var descriptionTextView: UITextView!
  
  var didBecomeFirstResponder: (() -> Void)?
  var descriptionDidChange: ((description: String) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.descriptionTextView.delegate = self
    self.descriptionTextView.editable = false
    self.descriptionTextView.selectable = false
  }
  
  func refreshCellUsingRecipeDescription(recipeDescription: String?) {
    if recipeDescription == nil || recipeDescription!.isEmpty {
      self.descriptionTextView.text = RecipeDescriptionTextPlaceholder
    } else {
      self.descriptionTextView.text = recipeDescription!
    }
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
    self.descriptionTextView.text = ""
  }
  
}
