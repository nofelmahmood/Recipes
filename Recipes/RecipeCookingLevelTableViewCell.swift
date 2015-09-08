//
//  RecipeCookingLevelTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeCookingLevelTableViewCell: UITableViewCell {
  
  @IBOutlet var levelSegmentedControl: UISegmentedControl!
  
  var cookingLevelDidChange: ((selectedLevel: Int) -> ())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func segmentControlValueDidChange(sender: AnyObject) {
    self.cookingLevelDidChange?(selectedLevel: self.levelSegmentedControl.selectedSegmentIndex + 1)
  }
}
