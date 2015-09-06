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
    self.didBecomeFirstResponder?()
  }
  
  func textViewDidChange(textView: UITextView) {
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
}

class RecipeDescriptionTableViewCell: UITableViewCell {
  
  @IBOutlet var descriptionTextView: UITextView!
  
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
  
}
