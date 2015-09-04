//
//  RecipeDescriptionTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

// MARK: UITextViewDelegate
extension RecipeDescriptionTableViewCell: UITextViewDelegate {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    return true
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    guard let indexPath = self.tableView?.indexPathForCell(self) else {
      return
    }
    self.tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
  }
}

class RecipeDescriptionTableViewCell: UITableViewCell {
  
  @IBOutlet var descriptionTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.descriptionTextView.delegate = self
    self.descriptionTextView.editable = false
    self.descriptionTextView.selectable = false
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    self.descriptionTextView.editable = editing
    if editing {
    } else {
      self.descriptionTextView.resignFirstResponder()
    }
  }
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
