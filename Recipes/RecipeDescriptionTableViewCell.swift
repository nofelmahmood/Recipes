//
//  RecipeDescriptionTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeDescriptionTableViewCell: UITableViewCell {
  
  @IBOutlet var descriptionTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.descriptionTextView.editable = false
    self.descriptionTextView.selectable = false
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    self.descriptionTextView.editable = false
  }
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
