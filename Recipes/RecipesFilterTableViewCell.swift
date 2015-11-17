//
//  RecipeFilterTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 01/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipesFilterTableViewCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    nameLabel.textColor = UIColor.darkGrayColor()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    if selected {
      accessoryType = UITableViewCellAccessoryType.Checkmark
    } else {
      accessoryType = UITableViewCellAccessoryType.None
    }
  }
  
}
