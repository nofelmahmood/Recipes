//
//  RecipesTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 30/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var favoriteButton: UIButton!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var backgroundImageViewWrapper: UIView!
  
  var recipe: Recipe!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.backgroundImageViewWrapper.clipsToBounds = true
    self.backgroundColor = UIColor.clearColor()
    
  }
  
  func updateCellFromRecipe() {
    self.nameLabel.text = recipe.name!
    self.descriptionLabel.text = recipe.specification!
    self.favoriteButton.selected = recipe.favorite!.boolValue
  }
  
  @IBAction func favoriteButtonTapped(sender: AnyObject?) {
    self.favoriteButton.selected = !self.favoriteButton.selected
    self.recipe.favorite = NSNumber(bool: self.favoriteButton.selected)
  }
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  
  
}
