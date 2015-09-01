//
//  RecipeInstructionTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeInstructionTableViewCell: UITableViewCell {
  
  @IBOutlet var instructionTextView: UITextView!
  @IBOutlet var instructionNumberLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.instructionTextView.editable = false
    self.instructionTextView.selectable = false
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    self.instructionTextView.editable = editing
  }
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
