//
//  RecipeInstructionTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

// MARK: UITextViewDelegate
extension RecipeInstructionTableViewCell: UITextViewDelegate {
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
  
  func textViewDidEndEditing(textView: UITextView) {
    self.instructionDidChange?()
  }
}

class RecipeInstructionTableViewCell: UITableViewCell {
  
  @IBOutlet var instructionTextView: UITextView!
  @IBOutlet var instructionNumberLabel: UILabel!
  
  var didBecomeFirstResponder: (() -> Void)?
  var instructionDidChange: (() -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.instructionTextView.delegate = self
    self.instructionTextView.editable = false
    self.instructionTextView.selectable = false
  }
  
  func refreshCellUsingInstruction(instruction: String, number: Int) {
    self.instructionNumberLabel.text = "\(number + 1)"
    self.instructionTextView.text = instruction
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    self.instructionTextView.editable = editing
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.instructionTextView.text = ""
  }
}
